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
        title: const Text('키와 몸무게 선택'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '키와 몸무게를 입력해주세요.',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _buildDial('몸무게 입력', _weight, 30, 150, 'kg', (value) {
              setState(() {
                _weight = value;
              });
            }),
            const SizedBox(height: 30),
            _buildDial('키 입력', _height, 100, 250, 'cm', (value) {
              setState(() {
                _height = value;
              });
            }),
            const SizedBox(height: 40),
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
                        selectedHeight: _height),
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
              child: const Text('다음 3/4 »'),
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
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 100,
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
                      color: Colors.white,
                      fontSize: 20,
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
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
