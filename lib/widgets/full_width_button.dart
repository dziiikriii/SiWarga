import 'package:flutter/material.dart';

class FullWidthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double width; // 👈 tambahan parameter

  const FullWidthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color(0xFF184E0E),
    this.width = double.infinity, // 👈 default: penuh
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, // gunakan nilai parameter width
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
