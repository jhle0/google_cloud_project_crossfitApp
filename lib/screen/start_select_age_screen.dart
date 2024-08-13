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
  int selectedAge = 20;

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
            SizedBox(
              height: 100,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                perspective: 0.005,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  selectedAge = index + 1;
                },
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: List<Widget>.generate(
                    100,
                    (index) => Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
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
                          selectedAge: selectedAge)),
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
