import 'package:flutter/material.dart';

class EditWodDialog extends StatefulWidget {
  final Map<String, String> wod;

  const EditWodDialog({required this.wod, super.key});

  @override
  _EditWodDialogState createState() => _EditWodDialogState();
}

class _EditWodDialogState extends State<EditWodDialog> {
  late TextEditingController _timeController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _timeController = TextEditingController(text: widget.wod['time']);
    _titleController = TextEditingController(text: widget.wod['title']);
    _descriptionController =
        TextEditingController(text: widget.wod['description']);
  }

  @override
  void dispose() {
    _timeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: const Text("Edit WOD", style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _timeController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Time",
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Title",
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          TextField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: "Description",
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
              'time': _timeController.text,
              'title': _titleController.text,
              'description': _descriptionController.text,
            });
          },
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
