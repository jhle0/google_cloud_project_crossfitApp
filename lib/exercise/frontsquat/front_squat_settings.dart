import 'package:flutter/material.dart';

import 'front_squat_pose_detector.dart';

class frontSquatSettings extends StatefulWidget {
  const frontSquatSettings({super.key});

  @override
  State<frontSquatSettings> createState() => _frontSquatSettingsState();
}

class _frontSquatSettingsState extends State<frontSquatSettings> {
  int count = 0;
  int minute = 0;
  int second = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF17171B),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                      child:const Text(
                        "에어 스쿼트",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 30
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.20),
                      child:Row(
                        children: [
                          const Text(
                            "횟수",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20
                            ),
                          ),
                          Expanded( // Expanded 추가
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  count = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.20),
                      child:Row(
                        children: [
                          const Text(
                            "시간",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            ),
                          ),
                          Expanded( // Expanded 추가
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  minute = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "분",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16
                            ),
                          ),
                          Expanded( // Expanded 추가
                            child: TextField(
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  second = int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                          const Text(
                            "초",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                        child:ElevatedButton(
                          onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: const Row(
                                    children: <Widget>[
                                      Icon(Icons.warning, color: Colors.red), // 경고 아이콘 추가
                                      SizedBox(width: 8), // 아이콘과 텍스트 사이 간격 추가
                                      Text("주의 사항 안내"),
                                    ]
                                ),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min, // Column의 크기를 내용에 맞게 조절
                                  children: <Widget>[
                                    Text('핸드폰의 정면 카메라에 전신이 인식되도록 떨어져 위치해 주세요.',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text("운동 전 충분한 스트레칭을 하고, 자신의 체력 수준에 맞게 운동 강도를 조절하세요.",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14
                                        )
                                    ),
                                    SizedBox(height: 8), // 문장 사이 간격 추가
                                    Text("부상 위험이 있으니 무리하지 마세요.",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14
                                        )),
                                    SizedBox(height: 8),
                                    Text("운동 중 불편함이나 통증이 느껴지면 즉시 중단하세요.",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14
                                        )
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)=>frontSquatPoseDetector(targetCount: count, targetMinute: minute, targetSecond: second)
                                        )
                                    );
                                  },
                                      child: const Text("확인")
                                  )
                                ],
                              );
                            }
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                            backgroundColor:
                            const Color.fromARGB(255, 99, 180, 254), // 버튼 배경색
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const
                          Text("준비 완료",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.white
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }
}
