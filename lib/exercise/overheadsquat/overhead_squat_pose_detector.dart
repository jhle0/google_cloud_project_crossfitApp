import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../Component/calculate_angle.dart';
import '../Component/pose_painter.dart';
import '../Component/detector_view.dart';

class OverheadSquatPoseDetector extends StatefulWidget {
  final int targetCount;
  final int targetMinute;
  final int targetSecond;

  const OverheadSquatPoseDetector({
    super.key,
    required this.targetCount,
    required this.targetMinute,
    required this.targetSecond
  });


  @override
  State<OverheadSquatPoseDetector> createState() => _OverheadSquatPoseDetectorState();
}

class _OverheadSquatPoseDetectorState extends State<OverheadSquatPoseDetector> {
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  bool _isDetecting = false;
  CustomPaint? _customPaint;
  final _cameraLensDirection = CameraLensDirection.back;
  final Stopwatch _stopwatch = Stopwatch();
  List <double?> angles = [];
  String? _csvFilePath;
  Timer? _timer;
  Timer? _timer2;
  int _remainingTime = 0; // 남은시간 (초)
  String? _currentCsvFilePath;
  int _frameCount = 0;
  double _actualFps = 0.0;
  static const defaultFps = 30.0;
  bool isCountdownFinished = false;
  int countdown = 3;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1000~/ defaultFps), (timer){
      if (_isDetecting){
        _createNewCsvFile();
        writeAnglesToCsv(angles);
        angles = [];
      }
    });
    _remainingTime = widget.targetMinute * 60 + widget.targetSecond;
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetectorView(
            customPaint: _customPaint,
            onImage: _processImage,
            initialCameraLensDirection: _cameraLensDirection,
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: ClipRRect( // 둥근 모서리 적용을 위한 ClipRRect 추가
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Opacity(
                opacity: 0.46,
                child: SizedBox( // Container를 SizedBox로 변경
                  height: 100, // SizedBox의 높이 지정 (필요에 따라 조절)
                  child: DecoratedBox( // 배경색 및 텍스트 스타일 적용
                    decoration: const BoxDecoration(color: Color(0xFF797979)),
                    child: Row(
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.10,
                              MediaQuery.of(context).size.width * 0.03,
                              MediaQuery.of(context).size.width * 0.10,
                              MediaQuery.of(context).size.width * 0.03),
                          child: const Opacity(
                            opacity: 1.0,
                            child: Text(
                              '오버헤드 스쿼트',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFffffff)
                              ),
                            ),
                          ),
                        ),
                        Padding(padding:
                        EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * 0.15,
                            MediaQuery.of(context).size.width * 0.03,
                            MediaQuery.of(context).size.width * 0.10,
                            MediaQuery.of(context).size.width * 0.03),
                          child: Opacity(
                          opacity: 1.0,
                          child: Text(
                            // 나중에 카운트 변수 처리
                            '00/${widget.targetCount}',
                            style: const TextStyle(
                                fontSize: 30,
                                color: Color(0xFFffffff)
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isCountdownFinished) // 카운트다운 중
                  Text(
                    '$countdown',
                    style: const TextStyle(
                        fontSize: 48,
                        color: Colors.white
                    ),
                  )
                else // 타이머 실행 중
                  Text(
                    '남은 시간: ${_formatTime(_remainingTime)}',
                    style: const TextStyle(
                        fontSize: 24,
                    color: Colors.white),
                  ),
                // TODO: 다른 UI 요소 추가 (예: 운동 횟수 표시 등)
              ],
            ),
          ),
          Positioned( // 버튼 위치 조정 (예시: 화면 하단 중앙)
              bottom: MediaQuery.of(context).size.width * 0.15,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Opacity(
                  opacity: 0.46,
                  child: Center(
                      child: SizedBox(
                        // AnimationButton 사용하세요.
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: _isDetecting? 100.0 : 200.0,
                              height: 50.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isDetecting = !_isDetecting; // 버튼 클릭 시 상태 변경
                                    if (!_isDetecting) { // 자세 인식 종료 시
                                      if (angles.isNotEmpty) { // angles1D가 비어있지 않은 경우에만 저장
                                        writeAnglesToCsv(angles).then((_) { // 2차원 리스트 형태로 감싸서 전달
                                          debugPrint("CSV 파일이 저장되었습니다.");
                                          angles = []; // angles1D 초기화
                                        });
                                      }
                                    }
                                  });
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(const Color(0xff464646)),
                                    foregroundColor: WidgetStateProperty.all<Color>(const Color(0xffFFFFFF)),
                                    padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    elevation: WidgetStateProperty.all<double>(3)
                                ), child: Icon(
                                  _isDetecting ?
                                  Icons.pause_circle_filled :
                                  Icons.play_circle_filled
                              ),
                              ),
                          )
                      )
                  )
                ),
              )
          ),
        ],
      ),
    );
  }

  void _startCountdown() {
    isCountdownFinished = false;
    countdown = 3;

    // _timer2가 이미 실행 중인 경우 멈춤
    _timer2?.cancel(); // null-aware 연산자 사용

    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (countdown > 0) {
          countdown--;
        } else {
          _timer2?.cancel();
          isCountdownFinished = true;
          _startTimer();
        }
      });
    });
  }

  void _startTimer() {
    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer2?.cancel(); // null-aware 연산자 사용
          // TODO: 타이머 종료 후 필요한 동작 수행 (예: 알림, 페이지 이동 등)
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final poses = await _poseDetector.processImage(inputImage);

    if (_isDetecting) { // _isDetecting이 true일 때만 자세 인식
      if (! _stopwatch.isRunning){
        _stopwatch.start();
      }

      _frameCount++;

      if (_stopwatch.elapsedMilliseconds >= 1000) { // 1초 경과 시
        _actualFps = _frameCount / (_stopwatch.elapsedMilliseconds / 1000); // 실제 FPS 계산
        _stopwatch.reset();
        _frameCount = 0;
      }

      final frameInterval = 1000 / _actualFps;

      // 1000ms 당 1초, 일단 1초에 1회 갱신 (실제는 최대 30fps)
      if (_stopwatch.elapsedMilliseconds >= frameInterval){
        _stopwatch.reset();

        angles = [];

        for (Pose pose in poses) {

          // 각도 계산 및 2차원 리스트에 추가
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftWrist,
              PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder,
              "왼쪽 팔꿈치"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftElbow,
              PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip,
              "왼쪽 어깨"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftShoulder,
              PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, "왼쪽 엉덩이"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftHip,
              PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, "왼쪽 무릎"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightWrist,
              PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder,
              "오른쪽 팔꿈치"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightElbow,
              PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
              "오른쪽 어깨"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightShoulder,
              PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee,
              "오른쪽 엉덩이"));
          angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightHip,
              PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle,
              "오른쪽 무릎"));

          await writeAnglesToCsv(angles);
        }
      }

      if (inputImage.metadata?.size != null &&
          inputImage.metadata?.rotation != null) {
        final painter = PosePainter(
          poses,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          _cameraLensDirection,
        );
        _customPaint = CustomPaint(painter: painter);
      }
    } else {
      _customPaint = null; // _isDetecting이 false이면 _customPaint를 null로 설정하여 화면에서 지움
    }

    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> writeAnglesToCsv(List<double?> angles) async {
    if (_currentCsvFilePath == null) {
      _createNewCsvFile();
    }

    final file = File(_currentCsvFilePath!);

    final csvData = angles.map((angle) => angle?.toStringAsFixed(2) ?? '').join(',');
    await file.writeAsString('$csvData\n', mode: FileMode.append);
    debugPrint("CSV 파일에 데이터가 추가되었습니다.");
    debugPrint("CSV 파일 경로: $_currentCsvFilePath"); // 올바른 경로 출력
  }

  void _createNewCsvFile() {
    Directory externalDirectory = Directory('/storage/emulated/0/Download');
    final now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
    _currentCsvFilePath = '${externalDirectory.path}/OverheadSquat_$formattedDate.csv'; // _currentCsvFilePath 변수에 할당
  }
}
