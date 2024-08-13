import 'package:flutter/material.dart';
import 'wod_block.dart';

class SavedWodBlock extends StatelessWidget {
  final String date;
  final String wodName;
  final String wodDescription;
  final List<Map<String, String>> wods;
  final int colorIndex;

  const SavedWodBlock({
    required this.date,
    required this.wodName,
    required this.wodDescription,
    required this.wods,
    required this.colorIndex, // 색상 인덱스 추가
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          Text(
            date,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            wodName,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            wodDescription,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ...wods.map((wod) => WodBlock(
                time: wod['time']!,
                title: wod['title']!,
                description: wod['description']!,
                colorIndex: colorIndex,
                onEdit: () {},
                onDelete: () {},
                showActions: false,
              )),
        ],
      ),
    );
  }
}
