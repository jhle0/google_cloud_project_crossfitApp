import 'package:flutter/material.dart';

class DailyChallengeWidget extends StatelessWidget {
  const DailyChallengeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Challenge',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          // 가운데 정렬을 위해 Center 위젯 추가
          child: Column(
            children: [
              Text(
                '메트콘 챌린지',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
              ),
              SizedBox(height: 8),
              Text(
                '자신의 한계를 도전해보세요!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center, // 텍스트 가운데 정렬
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: const DecorationImage(
              image: AssetImage('assets/crossfit_challenge.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Icon(Icons.timer, color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      'AMRAP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '주어진 시간 동안 반복 횟수를\n수행하게 됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '시작하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: 1,
                color: Colors.white30,
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Icon(Icons.directions_run,
                        color: Colors.white, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      'EMOM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '분마다 정해진 수의 운동을\n수행하게 됩니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        '시작하기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
