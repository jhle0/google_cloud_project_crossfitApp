import 'package:flutter/material.dart';

class FrontSquatPage extends StatelessWidget {
  const FrontSquatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 23, 27),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20.0,
                right: 0.0,
                bottom: 0,
              ),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '프런트',
                      style: TextStyle(
                        color: Color.fromARGB(255, 99, 180, 254),
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: ' 스쿼트',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Center(
              child: Image.asset(
                'assets/airsquat-ex.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '허리의 아치 형태를 유지한다.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '정면을 응시한다',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '뒤꿈치에 체중을 실은 상태로 유지한다',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '완전한 가동범위에 도달한다(즉, 수평선 밑)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '가슴을 높은 상태로 유지한다',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text(
                      '체간을 팽팽하게 유지한다',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text(
                      '무릎이 발 안쪽으로 모임',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text(
                      '뒤꿈치가 바닥에서 떨어짐',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text(
                      '요추 신전 상실 (등이 휘어짐, 가장 잘못된 자세)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 227, 227, 227),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 시작 버튼 눌렀을 때의 동작을 정의합니다.
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                  backgroundColor:
                      const Color.fromARGB(255, 99, 180, 254), // 버튼 배경색
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 227, 227, 227),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
