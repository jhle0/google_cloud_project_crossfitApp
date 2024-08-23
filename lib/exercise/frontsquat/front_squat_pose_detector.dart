import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:camera/camera.dart';
// import 'package:dio/dio.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis/aiplatform/v1.dart';
import 'package:dio/dio.dart';


import '../Component/calculate_angle.dart';
import '../Component/pose_painter.dart';
import '../Component/detector_view.dart';

import 'front_squat_result.dart';

class frontSquatPoseDetector extends StatefulWidget {
  final int targetCount;
  final int targetMinute;
  final int targetSecond;

  const frontSquatPoseDetector({
    super.key,
    required this.targetCount,
    required this.targetMinute,
    required this.targetSecond
  });

  @override
  State<frontSquatPoseDetector> createState() => _frontSquatPoseDetectorState();
}

class _frontSquatPoseDetectorState extends State<frontSquatPoseDetector> {

  // 동작 인식 변수
  final PoseDetector _poseDetector = PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  final _cameraLensDirection = CameraLensDirection.back;

  // 시간 관련 변수
  bool isCountdownFinished = false;
  int _remainingTime = 0; // 남은시간 (초)
  int countdown = 5;
  Timer? fulltimer;

  // 처리 관련 변수
  bool _isDetecting = false;
  bool _isBenting = false;
  int poseCount = 0;
  List <double?> angles = [];
  var result = List.filled(4, 0); // 지워도 되는 변수인지 확인하기.
  String? _previousCsvFilePath;
  String? _currentCsvFilePath;
  String? formattedDate;
  int heel = 0;
  int elbowFault = 0;
  int elbowUnderFault = 0;

  final String endpointUrl = 'https://us-central1-aiplatform.googleapis.com/v1/projects/397646731950/locations/us-central1/endpoints/8603632307858833408:predict';
  final String accessToken = 'ya29.a0AcM612yDQQFZi711wlDelonewfi01iF4TENXhYJEmZvbJxRvGB622Viixk8A77nMcoMYsm978VQsxFzuwt2ZyJwWw-0NqY-WjDYyBZ6fW050z9HU9RSUftziwzwAjwtqKPGSzUkmxYDZim4fJzmxb2a1FVZk8Yve6sBlJ3uW7w3bZj362CN3pYrjnGTQ5ASxa2UM9bt4azG5wrpl5jcGopeNFnQRmZBXqQnbHm29o8PyGkC25G85j8EwLVH3amg4DiOUbZv-1nVr0vz0XaXJdltWVPFI8nlnYwzh4zD_lcjBYWDoR4xlp-6Ma7Evd1rNvJu9JDDkvQcbZOwPQzKsF9Rfnc1CkkvbSTaPLPe30ejWSM652BOZMldKRuO_kEst8ui32uXnMFNTNIbh8yBJwaNNxISwv2caCgYKAU0SARISFQHGX2Miarwbo8aowUYIW3MfUINmqQ0422';

  // 공통 함수
  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.targetMinute * 60 + widget.targetSecond;
    _startCountdown();

    // formattedDate 변수 초기화
    final now = DateTime.now();
    formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);
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
                                '에어 스쿼트',
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
                                '$poseCount/${widget.targetCount}',
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

          Positioned(
            top: 150,
            left: 0,
            right: 0,
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
                //
              ],
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.15,
            left: 0,
            right: 0,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Opacity(
                  opacity: 0.46,
                  child: Center(
                      child: SizedBox(
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: _isDetecting? 100.0 : 200.0,
                              height: 50.0,
                              child: Container( // 버튼들을 감싸는 컨테이너 추가
                                decoration: BoxDecoration(
                                  color: const Color(0xff464646), // 배경색 설정
                                  borderRadius: BorderRadius.circular(8), // 둥근 모서리 설정
                                ),
                                child: _isDetecting ? ElevatedButton( // 동작 인식 중에는 일시 정지 버튼만 표시
                                  onPressed: () {
                                    setState(() {
                                      _isDetecting = false;
                                      fulltimer?.cancel();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, // 배경색 투명하게 설정
                                    elevation: 0, // 그림자 제거
                                    foregroundColor: const Color(0xffFFFFFF),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                  child: const Icon(Icons.pause_circle_filled),
                                )
                                    : Row( // 동작 인식 정지 상태에서는 재생 및 정지 버튼 표시
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _isDetecting = true;
                                          _startTimer();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent, // 배경색 투명하게 설정
                                        elevation: 0, // 그림자 제거
                                        foregroundColor: const Color(0xffFFFFFF),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      child: const Icon(Icons.play_circle_filled),
                                    ),
                                    ),
                                    Expanded(child: ElevatedButton( // 정지 버튼
                                      onPressed: () {
                                        setState(() {
                                          stopExercise(context);
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent, // 배경색 투명하게 설정
                                        elevation: 0, // 그림자 제거
                                        foregroundColor: const Color(0xffFFFFFF),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      child: const Icon(Icons.stop_circle),
                                    ),
                                    )
                                  ],
                                ),
                              )
                          )
                      )
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  void stopExercise(BuildContext context) {
    setState(() {
      _isDetecting = false;
      fulltimer?.cancel();
      _remainingTime = 0;
    });

    _convertCsvToJson();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('운동 종료'),
          content: const Text('운동이 종료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('결과 확인'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context)=> FrontSquatResult(
                      correct: poseCount,
                      elbowError: elbowFault,
                      elbowUnderError: elbowUnderFault,
                      targetCount: widget.targetCount
                  )),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // 시간 관련 함수
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _startCountdown() {
    isCountdownFinished = false;
    countdown = 5;

    fulltimer?.cancel();

    fulltimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (countdown > 0) {
        // 1. 효과음 재생

        // 2. UI 업데이트
        setState(() {
          countdown--;
        });
      } else {
        fulltimer?.cancel();
        isCountdownFinished = true;
        _startTimer();
        _isDetecting = true;
      }
    });
  }

  void _startTimer() {
    if (fulltimer?.isActive ?? false) return; // 이미 실행 중이면 중복 실행 방지
    fulltimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0 && _isDetecting) {
          _remainingTime--;
        } else {
          fulltimer?.cancel();
          _isDetecting = false;
          stopExercise(context);
        }
      });
    });
  }

  // 이미지 인식 함수
  Future<void> _processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final poses = await _poseDetector.processImage(inputImage);

    if (_isDetecting) { // _isDetecting이 true일 때만 자세 인식
      angles = [];

      for (Pose pose in poses) {
        // 각도 계산 및 2차원 리스트에 추가
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftHip,
            PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, "왼쪽 무릎"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightHip,
            PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, "오른쪽 무릎"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftShoulder,
            PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, "왼쪽 엉덩이"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightShoulder,
            PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee,
            "오른쪽 엉덩이"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftKnee,
            PoseLandmarkType.leftHeel, PoseLandmarkType.leftFootIndex, "왼쪽 뒷꿈치"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightKnee,
            PoseLandmarkType.rightHeel, PoseLandmarkType.rightFootIndex,
            "오른쪽 뒷꿈치"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftWrist,
            PoseLandmarkType.leftElbow, PoseLandmarkType.leftShoulder,
            "왼쪽 팔꿈치"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightWrist,
            PoseLandmarkType.rightElbow, PoseLandmarkType.rightShoulder,
            "오른쪽 팔꿈치"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftKnee,
            PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex, "왼쪽 발목"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightKnee,
            PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex,
            "오른쪽 발목"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.leftElbow,
            PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip,
            "왼쪽 어깨"));
        angles.add(calculateAngleWithLandmark(pose, PoseLandmarkType.rightElbow,
            PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip,
            "오른쪽 어깨"));

        double? leftKneeAngle = angles[0];

        if (leftKneeAngle != null) {
          if (leftKneeAngle < 165 && !_isBenting) {
            _isBenting = true;
            _createNewCsvFile();
            debugPrint('측정 시작');
          } else if (leftKneeAngle >= 165 && _isBenting){
            _isBenting = false;
            debugPrint('측정 종료');

            setState(() {}); // UI Update

            if (poseCount == widget.targetCount) {
              if (mounted) { // context 사용 전에 mounted 확인
                stopExercise(context);
              }
            }
          }
        }

        if (_isDetecting && _isBenting) {
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

  // 파일 처리 함수
  Future<void> _createNewCsvFile() async {
    Directory externalDirectory = Directory('/storage/emulated/0/Download');

    // formattedDate 변수 재초기화
    final now = DateTime.now();
    formattedDate = DateFormat('yyyyMMdd_HHmmss').format(now);

    // 새로운 CSV 파일 경로 생성
    String newCsvFilePath = '${externalDirectory.path}/frontSquat_$formattedDate.csv';

    // 이전 CSV 파일이 존재하고, 현재 CSV 파일과 경로가 다를 때 JSON으로 변환
    if (_currentCsvFilePath != null && _currentCsvFilePath != newCsvFilePath) {
      _previousCsvFilePath = _currentCsvFilePath;
      await _convertCsvToJson();
    }

    // 현재 CSV 파일 경로 업데이트
    _currentCsvFilePath = newCsvFilePath;
  }

  Future<void> writeAnglesToCsv(List<double?> angles) async {
    if (_currentCsvFilePath == null) {
      _createNewCsvFile();
    }

    final file = File(_currentCsvFilePath!);

    final csvData = angles.map((angle) => angle?.toStringAsFixed(2) ?? '').join(',');
    await file.writeAsString('$csvData\n', mode: FileMode.append);
  }

  Future<void> _convertCsvToJson() async {
    if (_previousCsvFilePath  == null) return;

    try {
      if (await File(_previousCsvFilePath!).exists()) {

        // CSV 파일 읽기
        String csvString = await File(_previousCsvFilePath!).readAsString();
        List<String> lines = csvString.split('\n');

        List<List<double>> maskingInput = [];
        for (String line in lines) {
          if (line
              .trim()
              .isNotEmpty) { // 빈 줄 건너뛰기
            List<String> values = line.split(',');
            List<double> row = values.map((value) =>
            double.tryParse(value) ?? 0.0).toList();
            maskingInput.add(row);
          }
        }

        // JSON 객체 생성
        Map<String, dynamic> jsonData = {
          'instances': [
            {
              'masking_input': maskingInput
            }
          ]
        };

        // JSON 문자열 생성 및 저장 (줄 바꿈 추가)
        // JSON 문자열 생성 및 저장 (줄 바꿈 추가 및 masking_input 형식 유지)
        final encoder = JsonEncoder.withIndent('  ', (data) {
          return data is List<dynamic> // 리스트인 경우
              ? data.map((item) => item is List<double> // 숫자 리스트인 경우
              ? item // 숫자 리스트는 있는 그대로 반환
              : item.toJson()) // 다른 객체는 toJson() 메서드 호출
              .toList()
              : data.toJson(); // 다른 객체는 toJson() 메서드 호출
        });
        String jsonString = encoder.convert(jsonData);
        String jsonFilePath = _currentCsvFilePath!.replaceAll(
            '.csv', '.json');
        await File(jsonFilePath).writeAsString(jsonString);

        debugPrint("JSON 파일 변환 및 저장 완료: $jsonFilePath");
        _sendJsonToVertexAI(jsonFilePath, accessToken);
      } else {
        debugPrint("변환할 CSV 파일이 존재하지 않습니다: $_previousCsvFilePath");
      }
    } catch (e) {
      debugPrint("CSV 파일 변환 중 오류 발생 $e");
    }
  }

  Future<void> _sendJsonToVertexAI(String jsonFilePath, String accessToken) async {
    final client = await _createAuthenticatedClient(); // 인증 방식에 맞춰 구현
    final dio = Dio();



    try {
      // JSON 파일 읽기
      String jsonString = await File(jsonFilePath).readAsString();

      debugPrint('Vertex AI 요청 (파일: $jsonFilePath)');

      var response = await dio.post(
        endpointUrl,
        data: jsonString,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // 액세스 토큰 헤더 추가
          },
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data; // Dio는 자동으로 JSON 디코딩을 수행합니다.

        final Map<String, dynamic> jsonData = responseData;
        final List<dynamic> predictions = jsonData['predictions'][0]; // 첫 번째 예측 결과 가져오기
        final double highestProbability = predictions.reduce((a, b) => a > b ? a : b); // 가장 높은 확률 값 찾기
        final int predictedClassIndex = predictions.indexOf(highestProbability); // 예측된 클래스 인덱스 찾기

        if (predictedClassIndex == 0) {
          poseCount++;
        } else if (predictedClassIndex == 1) {
          elbowFault++;
        } else if (predictedClassIndex == 2) {
          elbowUnderFault++;
        }
      } else {
        final errorMessage = response.data;
        debugPrint('Vertex AI 요청 실패 (파일: $jsonFilePath): ${response.statusCode}, 상세 오류 메시지: $errorMessage');

        // 오류 처리 로직 강화 (예시)
        if (response.statusCode == 400) {
          // 잘못된 요청 처리
        } else if (response.statusCode == 401) {
          // 인증 오류 처리
        } else if (response.statusCode == 500) {
          // 서버 오류 처리
        }

        throw Exception('Vertex AI 요청 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('오류 발생 (파일: $jsonFilePath): ${e.response?.statusCode}, ${e.response?.data}');
      } else {
        debugPrint('오류 발생 (파일: $jsonFilePath): ${e.message}');
      } // 오류 처리 (예: 사용자에게 알림, 로그 기록 등)
    } finally {
      client.close();
    }
  }

  Future<http.Client> _createAuthenticatedClient() async {
    final serviceAccountJson = await rootBundle.loadString('assets/jeju-24-team-105-d6a84cd49d5f.json');
    final credentials = ServiceAccountCredentials.fromJson(jsonDecode(serviceAccountJson));
    final scopes = [AiplatformApi.cloudPlatformScope];
    return clientViaServiceAccount(credentials, scopes);
  }
}