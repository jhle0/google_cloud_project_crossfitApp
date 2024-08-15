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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Slider
            Column(
              children: [
                const Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '나이선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 180,
                    ),
                    Text(
                      '70%',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4.0,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 16.0),
                  ),
                  child: Slider(
                    value: 70,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {},
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '나이를 선택해주세요.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 60),
                  SizedBox(
                    // 추가: Expanded 대신 SizedBox를 사용
                    height: 400, // 필요한 높이를 명시적으로 지정
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
                  const SizedBox(height: 90),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      '다음 2/4 »',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
