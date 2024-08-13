import 'package:flutter/material.dart';
import 'package:google_cloud_project/widget/edit_wod_dialog.dart';
// import 'package:google_cloud_project/widget/filter_buttons.dart';
import 'package:google_cloud_project/widget/save_wod_dialog.dart';
import 'package:google_cloud_project/widget/saved_wod_block.dart';
import 'package:google_cloud_project/widget/wod_block.dart';

class WodScreen extends StatefulWidget {
  const WodScreen({super.key});

  @override
  WodScreenState createState() => WodScreenState();
}

class WodScreenState extends State<WodScreen> {
  List<Map<String, String>> currentWod = [];
  List<Map<String, dynamic>> savedWods = [];
  bool showAllWods = false;

  static const List<Color> colors = [
    Color(0xFF4E849C),
    Color(0xFF224D60),
    Color(0xFF006182),
    Color(0xFFDCDBD9),
    Color(0xFF3B626E),
    Color(0xFF27383E),
  ];

  void _onTodayPressed() {
    setState(() {
      showAllWods = false;
    });
  }

  void _onAllPressed() {
    setState(() {
      showAllWods = true;
    });
  }

  void _editWod(int index) async {
    Map<String, String>? editedWod = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => EditWodDialog(wod: currentWod[index]),
    );

    if (editedWod != null) {
      setState(() {
        currentWod[index] = editedWod;
      });
    }
  }

  void _deleteWod(int index) {
    setState(() {
      currentWod.removeAt(index);
    });
  }

  void _saveWod() async {
    if (currentWod.isNotEmpty) {
      final Map<String, String>? result = await showDialog<Map<String, String>>(
        context: context,
        builder: (context) => const SaveWodDialog(), // Save WOD 다이얼로그 표시
      );

      if (result != null &&
          result['wodName']!.isNotEmpty &&
          result['wodDescription']!.isNotEmpty) {
        setState(() {
          savedWods.add({
            'date': DateTime.now(),
            'wodName': result['wodName']!,
            'wodDescription': result['wodDescription']!,
            'wods': List<Map<String, String>>.from(currentWod),
          });
          currentWod.clear();
        });
      }
    }
  }

  void _resetWods() {
    setState(() {
      currentWod.clear();
    });
  }

  void _addNewWod() async {
    Map<String, String>? newWod = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => const EditWodDialog(
        wod: {'time': '', 'title': '', 'description': ''},
      ),
    );

    if (newWod != null) {
      setState(() {
        currentWod.add(newWod);
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 27),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10, // 상태바 높이만큼 패딩 추가
              left: 25.0,
              right: 30.0,
              bottom: 10,
            ),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'YOUR',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      color: Color.fromARGB(255, 227, 227, 227),
                      fontSize: 35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' WOD',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      color: Color.fromARGB(255, 99, 180, 254),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 0, // 상태바 높이만큼 패딩 추가
              left: 25.0,
              right: 10.0,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
              children: [
                _buildFilterButton(
                  label: 'Today',
                  isSelected: !showAllWods,
                  onPressed: _onTodayPressed,
                ),
                const SizedBox(width: 8), // 버튼 사이 간격
                _buildFilterButton(
                  label: 'All',
                  isSelected: showAllWods,
                  onPressed: _onAllPressed,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  showAllWods ? savedWods.length + 1 : currentWod.length + 1,
              itemBuilder: (context, index) {
                if (showAllWods) {
                  if (index == savedWods.length) {
                    return const SizedBox.shrink(); // 마지막 아이템에 + 버튼 없음
                  }
                  final savedWod = savedWods[index];
                  return SavedWodBlock(
                    date: _formatDate(savedWod['date']),
                    wodName: savedWod['wodName'] ?? '',
                    wodDescription: savedWod['wodDescription'] ?? '',
                    wods: List<Map<String, String>>.from(savedWod['wods']),
                    colorIndex: index % colors.length, // 색상 팔레트 적용
                  );
                } else {
                  if (index == currentWod.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_circle,
                                color: const Color.fromARGB(255, 182, 178, 178)
                                    .withOpacity(0.4),
                                size: 60),
                            onPressed: _addNewWod,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        WodBlock(
                          time: currentWod[index]['time']!,
                          title: currentWod[index]['title']!,
                          description: currentWod[index]['description']!,
                          colorIndex: index % colors.length,
                          onEdit: () => _editWod(index),
                          onDelete: () => _deleteWod(index),
                          showActions: true,
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          ),
          if (!showAllWods)
            Padding(
              padding: const EdgeInsets.only(
                top: 10, // 상태바 높이만큼 패딩 추가
                left: 30.0,
                right: 30.0,
                bottom: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveWod,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                    ),
                    child: const Text(
                      "Save WOD",
                      style: TextStyle(
                        color: Color.fromARGB(255, 23, 23, 27),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _resetWods,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
                    ),
                    child: const Text(
                      "Reset",
                      style: TextStyle(
                        color: Color.fromARGB(255, 23, 23, 27),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 227, 227, 227)
            : const Color.fromARGB(255, 23, 23, 27),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Row(
        children: [
          if (isSelected)
            const Icon(
              Icons.check,
              color: Colors.black,
              size: 18,
            ),
          if (isSelected) const SizedBox(width: 2), // 체크 아이콘과 텍스트 사이 간격
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
