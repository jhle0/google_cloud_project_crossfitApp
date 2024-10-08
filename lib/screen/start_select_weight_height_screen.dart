import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_cloud_project/screen/start_select_username_screen.dart';

class SelectWeightHeightScreen extends StatefulWidget {
  final String selectedGender;
  final int selectedAge;

  const SelectWeightHeightScreen({
    required this.selectedGender,
    required this.selectedAge,
    super.key,
  });

  @override
  _SelectWeightHeightScreenState createState() =>
      _SelectWeightHeightScreenState();
}

class _SelectWeightHeightScreenState extends State<SelectWeightHeightScreen> {
  double _weight = 65.0;
  double _height = 175.0;

  Future<void> _saveWeightHeight() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'weight': _weight,
        'height': _height,
      }, SetOptions(merge: true));
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
                      '키 몸무게 선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 220,
                    ),
                    Text(
                      '95%',
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
                    value: 90,
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '키와 몸무게를 입력해주세요.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildDial('몸무게 입력', _weight, 30, 150, 'kg',
                            (value) {
                          setState(() {
                            _weight = value;
                          });
                        }),
                      ),
                      const SizedBox(width: 20), // 여유 공간 추가
                      Expanded(
                        child: _buildDial('키 입력', _height, 100, 250, 'cm',
                            (value) {
                          setState(() {
                            _height = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 150),
                  ElevatedButton(
                    onPressed: () async {
                      await _saveWeightHeight();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserNameScreen(
                            selectedGender: widget.selectedGender,
                            selectedAge: widget.selectedAge,
                            selectedWeight: _weight,
                            selectedHeight: _height,
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
                      '다음 3/4 »',
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

  Widget _buildDial(
    String label,
    double currentValue,
    double min,
    double max,
    String unit,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        Text(
          '${currentValue.toStringAsFixed(1)}$unit',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 240,
          child: ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(
              initialItem: (currentValue - min).toInt(),
            ),
            itemExtent: 50,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              onChanged(min + index);
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Center(
                  child: Text(
                    '${(min + index).toStringAsFixed(1)}$unit',
                    style: TextStyle(
                      color: currentValue == min + index
                          ? Colors.blue
                          : Colors.white,
                      fontSize: currentValue == min + index ? 22 : 20,
                      fontWeight: currentValue == min + index
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: (max - min + 1).toInt(),
            ),
          ),
        ),
      ],
    );
  }
}
