import 'package:flutter/material.dart';

class FrontSquatPage extends StatelessWidget {
  const FrontSquatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프런트 스쿼트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            Text(
              '에어 스쿼트',
              style: TextStyle(
                color: Colors.blue[800],
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('허리의 아치 형태를 유지한다.'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('정면을 응시한다'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('뒤꿈치에 체중을 실은 상태로 유지한다'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('완전한 가동범위에 도달한다(즉, 수평선 밑)'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('가슴을 높은 상태로 유지한다'),
                  ),
                  ListTile(
                    leading: Icon(Icons.check, color: Colors.blue),
                    title: Text('체간을 팽팽하게 유지한다'),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text('무릎이 발 안쪽으로 모임'),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text('뒤꿈치가 바닥에서 떨어짐'),
                  ),
                  ListTile(
                    leading: Icon(Icons.close, color: Colors.red),
                    title: Text('요추 신전 상실 (등이 휘어짐, 가장 잘못된 자세)'),
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
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  backgroundColor: Colors.blue, // 버튼 배경색
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('시작'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
