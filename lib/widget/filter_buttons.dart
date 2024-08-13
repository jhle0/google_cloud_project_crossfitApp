import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const FilterButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
