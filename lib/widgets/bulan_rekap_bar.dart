import 'package:flutter/material.dart';

class BulanRekapBar extends StatelessWidget {
  final List<String> labels;
  const BulanRekapBar({super.key, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFEAEAEA),
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Text(
                'Warga',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            for (var label in labels)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: Text(
                  label.length > 3 ? label.substring(0, 3) : label,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
