import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveWodDialog extends StatelessWidget {
  final List<Map<String, String>> currentWod; // 사용자 추가 WOD 리스트를 받기 위한 파라미터

  const SaveWodDialog({super.key, required this.currentWod});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return AlertDialog(
      title: const Text('Save WOD'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'WOD Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'WOD Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            String wodName = nameController.text;
            String wodDescription = descriptionController.text;

            if (wodName.isNotEmpty && wodDescription.isNotEmpty) {
              // Firestore에 데이터 저장
              await FirebaseFirestore.instance.collection('wods').add({
                'name': wodName,
                'description': wodDescription,
                'date': DateTime.now(),
                'wods': currentWod, // 사용자 추가 WOD 데이터도 함께 저장
              });

              Navigator.of(context).pop(<String, dynamic>{
                'wodName': wodName,
                'wodDescription': wodDescription,
                'wods': currentWod,
              });
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
