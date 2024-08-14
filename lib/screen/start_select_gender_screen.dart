import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_cloud_project/screen/start_select_age_screen.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  _SelectGenderScreenState createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  String? selectedGender;

  Future<void> _saveGender() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && selectedGender != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {'gender': selectedGender},
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
        title: const Text('성별 선택'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Slider
            Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '성별선택',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '35%',
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
                    value: 35,
                    min: 0,
                    max: 100,
                    onChanged: (double value) {},
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 130),
            const Text(
              '성별을 선택해주세요.',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = '남';
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            selectedGender == '남' ? Colors.blue : Colors.grey,
                        child: const Icon(Icons.male,
                            size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Male',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = '여';
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            selectedGender == '여' ? Colors.blue : Colors.grey,
                        child: const Icon(Icons.female,
                            size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Female',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: selectedGender == null
                  ? null
                  : () async {
                      await _saveGender();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectAgeScreen(selectedGender: selectedGender!),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedGender != null ? Colors.blue : Colors.grey,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('다음 1/4 »'),
            ),
          ],
        ),
      ),
    );
  }
}
