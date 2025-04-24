import 'package:flutter/material.dart';

class PengeluaranPemasukanButton extends StatelessWidget {
  final String text;
  const PengeluaranPemasukanButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(width: 5),
          Icon(Icons.arrow_outward_rounded, color: Colors.black),
        ],
      ),
    );
  }
}
