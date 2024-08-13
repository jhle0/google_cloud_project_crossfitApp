import 'package:flutter/material.dart';

class WodBlock extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final int colorIndex;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showActions; // Edit/Delete 버튼을 표시할지 여부

  const WodBlock({
    required this.time,
    required this.title,
    required this.description,
    required this.colorIndex,
    required this.onEdit,
    required this.onDelete,
    this.showActions = false, // 기본값은 false로 설정
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 13,
            height: 100,
            color: colors[colorIndex],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.blue),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (showActions) ...[
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Color.fromARGB(255, 192, 188, 188),
                size: 20,
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 221, 97, 88),
                size: 18,
              ),
              onPressed: onDelete,
            ),
          ],
        ],
      ),
    );
  }
}

const List<Color> colors = [
  Color(0xFF224D60),
  Color(0xFF4E849C),
  Color(0xFF006182),
  Color(0xFFDCDBD9),
  Color(0xFF3B626E),
  Color(0xFF27383E),
];
