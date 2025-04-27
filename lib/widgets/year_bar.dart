import 'package:flutter/material.dart';

class YearBar extends StatelessWidget {
  const YearBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15),
              onPressed: () {
                debugPrint('back');
              },
            ),
            Text('2025', style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              onPressed: () {
                debugPrint('next');
              },
            ),
          ],
        ),
      ),
    );
  }
}
