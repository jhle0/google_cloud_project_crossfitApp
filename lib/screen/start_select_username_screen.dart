import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_cloud_project/main.dart';

class UserNameScreen extends StatefulWidget {
  final String selectedGender;
  final int selectedAge;
  final double selectedWeight;
  final double selectedHeight;

  const UserNameScreen(
      {required this.selectedGender,
      required this.selectedAge,
      required this.selectedWeight,
      required this.selectedHeight,
      super.key});

  @override
  _UserNameScreenState createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _nameController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'gender': widget.selectedGender,
        'age': widget.selectedAge,
        'weight': widget.selectedWeight,
        'height': widget.selectedHeight,
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 23, 27),
        title: const Text('사용자 이름 입력'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '이름을 입력해주세요.',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: '이름',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  await _saveUserName();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('완료'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
