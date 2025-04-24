import 'package:flutter/material.dart';

class BlokBarItem extends StatelessWidget {
  final String blok;
  final String warga;
  final bool isSelected;
  final VoidCallback onTap;

  const BlokBarItem({
    super.key,
    required this.blok,
    required this.warga,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            blok,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isSelected ? Color(0xFF37672F) : Color(0xFF777777),
            ),
          ),
          Text(
            warga,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? Color(0xFF37672F) : Color(0xFF777777),
            ),
          ),
          SizedBox(height: 5),
          Container(
            height: 2,
            width: 100,
            color: isSelected ? Color(0xFF37672F) : Color(0xFFCCCCCC),
          ),
        ],
      ),
    );
  }
}
