import 'package:flutter/material.dart';

class TrainingTipsWidget extends StatelessWidget {
  const TrainingTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Training Tips & Videos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          color: Colors.grey[800],
          child: const Center(
            child: Text(
              '트레이닝 팁과 비디오가 여기에 표시됩니다.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
