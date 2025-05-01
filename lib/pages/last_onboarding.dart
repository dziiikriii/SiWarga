import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_warga/pages/login_page.dart';

class LastOnboarding extends StatelessWidget {
  const LastOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECFCEC),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Laporan Keuangan Otomatis',
                style: TextStyle(
                  color: Color(0xFF184E0E),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'Dapatkan laporan keuangan RT secara otomatis dan pantau riwayat pembayaran warga tanpa ribet.',
                style: TextStyle(color: Color(0xFF184E0E), fontSize: 15),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lens, color: Color(0xFFB4CCAC), size: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(Icons.lens, color: Color(0xFFB4CCAC), size: 12),
                  ),
                  Icon(Icons.lens, color: Color(0xFF184E0E), size: 12),
                ],
              ),
              SizedBox(height: 30),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('onboardingSeen', true);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF184E0E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 52,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
