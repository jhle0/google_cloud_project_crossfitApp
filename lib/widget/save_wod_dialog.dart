import 'package:flutter/material.dart';

class SaveWodDialog extends StatefulWidget {
  const SaveWodDialog({super.key});

  @override
  _SaveWodDialogState createState() => _SaveWodDialogState();
}

class _SaveWodDialogState extends State<SaveWodDialog> {
  late TextEditingController _wodNameController;
  late TextEditingController _wodDescriptionController;

  @override
  void initState() {
    super.initState();
    _wodNameController = TextEditingController();
    _wodDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _wodNameController.dispose();
    _wodDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text("Save WOD", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _wodNameController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "WOD Name",
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _wodDescriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "WOD Description",
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop({
              'wodName': _wodNameController.text,
              'wodDescription': _wodDescriptionController.text,
            });
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
