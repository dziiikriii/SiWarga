import 'package:flutter/material.dart';

class LogoWarga extends StatelessWidget {
  final String kode; // misal: 'A01'
  const LogoWarga({super.key, required this.kode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Color(0xFF777777),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(Icons.person_2, color: Colors.white, size: 25),
        ),
        Positioned(
          bottom: -7, // atur seberapa jauh oval keluar dari bawah
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Color(0xFF37672F),
              // border: Border.all(color: Color(0xFF777777), width: 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              kode,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
