import 'package:flutter/material.dart';

import 'overhead_squat_pose_detector.dart';

class OverheadSquatSettings extends StatefulWidget {
  const OverheadSquatSettings({super.key});

  @override
  State<OverheadSquatSettings> createState() => _OverheadSquatSettingsState();
}

class _OverheadSquatSettingsState extends State<OverheadSquatSettings> {
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
                color: Colors.cyanAccent,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                    child:const Text(
                      "에어 스쿼트",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "PretendardSemiBold",
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
                              fontFamily: "PretendardSemiBold",
                              fontSize: 20
                          ),
                        ),
                        Expanded( // Expanded 추가
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "PretendardSemiBold",
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
                              fontFamily: "PretendardSemiBold",
                              fontSize: 20
                          ),
                        ),
                        Expanded( // Expanded 추가
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "PretendardSemiBold",
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
                              fontFamily: "PretendardSemiBold",
                              fontSize: 16
                          ),
                        ),
                        Expanded( // Expanded 추가
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "PretendardSemiBold",
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
                              fontFamily: "PretendardSemiBold",
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
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>
                                      OverheadSquatPoseDetector(
                                        targetCount: count,
                                        targetMinute: minute,
                                        targetSecond: second
                                      ))
                              );
                            });
                          },
                          child: const Text("준비 완료")
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
