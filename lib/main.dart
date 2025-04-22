import 'package:flutter/material.dart';
import 'package:si_warga/pages/warga_tagihan_warga.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiWarga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF184E0E)),
        fontFamily: 'Neue Montreal',
      ),
      home: const WargaTagihanWarga(),
    );
  }
}
