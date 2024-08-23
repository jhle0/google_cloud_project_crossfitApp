import 'package:flutter/material.dart';

import '../../main.dart';

class FrontSquatResult extends StatefulWidget {
  const FrontSquatResult({super.key,
    required this.correct,
    required this.targetCount,
    required this.elbowError,
    required this.elbowUnderError
  });

  final int targetCount;
  final int correct;
  final int elbowError;
  final int elbowUnderError;

  @override
  State<FrontSquatResult> createState() => _FrontSquatResultState();
}

class _FrontSquatResultState extends State<FrontSquatResult> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SizedBox.expand(
        child:
          Container(
            decoration: const BoxDecoration(color: Color(0xFF17171B)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.width * 0.15,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 99, 180, 254),// 둥근 모서리 (선택 사항)
                        ),
                        child: const Center(
                          child: Text("운동 결과",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22
                              )
                          ),
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                  child: Column(
                    children: <Widget>[
                      Text('${widget.targetCount} 회 중 ${widget.correct} 회 성공했습니다.',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18
                        ),
                      ),
                      Text(
                        (() {
                          if (widget.correct == widget.targetCount) {
                            return '운동을 성공적으로 마치셨습니다!';
                          } else {
                            return '다음엔 더 잘 할거에요!';
                          }
                        })(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                        ),
                      ),
                    ],
                  )
                ),

                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center, // 아이콘과 원을 중앙 정렬
                          children: [
                            Container( // 흰 원 추가
                              width: 40, // 원하는 크기로 조절
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.check, color: Colors.blue,),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.14),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: ' 정상 동작 '),
                              TextSpan(
                                text: '${widget.correct}', // 변수 부분에 다른 스타일 적용
                                style: const TextStyle(
                                  color: Colors.blue, // 원하는 색상으로 변경
                                  fontWeight: FontWeight.bold, // 추가적인 스타일 적용 가능
                                ),
                              ),
                              const TextSpan(text: ' 회.'),
                            ],
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center, // 아이콘과 원을 중앙 정렬
                          children: [
                            Container( // 흰 원 추가
                              width: 40, // 원하는 크기로 조절
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.close, color: Colors.red),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.14),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: ' 팔꿈치 오류 '),
                              TextSpan(
                                text: '${widget.elbowError}', // 변수 부분에 다른 스타일 적용
                                style: const TextStyle(
                                  color: Colors.red, // 원하는 색상으로 변경
                                  fontWeight: FontWeight.bold, // 추가적인 스타일 적용 가능
                                ),
                              ),
                              const TextSpan(text: ' 회.'),
                            ],
                          ),
                        )
                      ],
                    )
                ),

                Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.10),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center, // 아이콘과 원을 중앙 정렬
                          children: [
                            Container( // 흰 원 추가
                              width: 40, // 원하는 크기로 조절
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                            const Icon(Icons.close, color: Colors.red),
                          ],
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 22
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                  text: ' 팔꿈치 하방 오류 '),
                              TextSpan(
                                text: '${widget.elbowUnderError}', // 변수 부분에 다른 스타일 적용
                                style: const TextStyle(
                                  color: Colors.red, // 원하는 색상으로 변경
                                  fontWeight: FontWeight.bold, // 추가적인 스타일 적용 가능
                                ),
                              ),
                              const TextSpan(text: ' 회.'),
                            ],
                          ),
                        )
                      ],
                    )
                ),

                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context)=>const MainScreen())
                      );
                    });
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
                  child: const Text("돌아가기",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          )
        )
    );
  }
}
