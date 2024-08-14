import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_cloud_project/screen/start_select_weight_height_screen.dart';

class SelectAgeScreen extends StatefulWidget {
  final String selectedGender;

  const SelectAgeScreen({required this.selectedGender, super.key});

  @override
  _SelectAgeScreenState createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends State<SelectAgeScreen> {
  int selectedAge = 20; // 초기 설정을 20으로 시작

  Future<void> _saveAge() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'age': selectedAge},
        SetOptions(merge: true),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 23, 27),
        title: const Text('나이 선택'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // 원래 코드로 되돌림
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '나이선택',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '70%',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 16.0),
                ),
                child: Slider(
                  value: 70, // 현재 화면이 70%임을 나타내는 값
                  min: 0,
                  max: 100,
                  onChanged: (double value) {},
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '나이를 선택해주세요.',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListWheelScrollView.useDelegate(
                itemExtent: 100,
                perspective: 0.003,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedAge = index + 1;
                  });
                },
                controller: FixedExtentScrollController(
                    initialItem: 19), // 20이 선택된 상태로 시작
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: List<Widget>.generate(
                    100,
                    (index) => Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index + 1 == selectedAge
                              ? Colors.blue
                              : Colors.white,
                          fontSize: 50,
                          fontWeight: index + 1 == selectedAge
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await _saveAge();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectWeightHeightScreen(
                      selectedGender: widget.selectedGender,
                      selectedAge: selectedAge,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('다음 2/4 »'),
            ),
          ],
        ),
      ),
    );
  }
}
