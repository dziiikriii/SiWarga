import 'package:flutter/material.dart';

class HeaderLaporanKeuangan extends StatelessWidget {
  final String title;
  final bool arrow;
  const HeaderLaporanKeuangan({
    super.key,
    required this.title,
    required this.arrow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFB4CCAC),
        // borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(width: 10),
            if (arrow) const Icon(Icons.arrow_outward_rounded, size: 17),
          ],
        ),
      ),
    );
  }
}
