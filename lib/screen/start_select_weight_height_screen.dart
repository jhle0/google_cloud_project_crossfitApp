import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_cloud_project/screen/start_select_username_screen.dart';

class SelectWeightHeightScreen extends StatefulWidget {
  final String selectedGender;
  final int selectedAge;

  const SelectWeightHeightScreen(
      {required this.selectedGender, required this.selectedAge, super.key});

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
            const Text(
              '몸무게 입력',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: '$_weight kg',
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            Text(
              '${_weight.toStringAsFixed(1)} kg',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            const Text(
              '키 입력',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _height,
              min: 100,
              max: 250,
              divisions: 150,
              label: '$_height cm',
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            Text(
              '${_height.toStringAsFixed(1)} cm',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
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
}
