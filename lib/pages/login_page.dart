import 'package:flutter/material.dart';
// import 'package:si_warga/pages/first_onboarding.dart';
// import 'package:si_warga/pages/homepage.dart';
import 'package:si_warga/widgets/bottom_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = 'warga'; // Default pilihan aktif
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: const Color(0xFFECFCEC),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.close_rounded, size: 30),
            const SizedBox(height: 40),
            Container(
              width: boxWidth,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFF184E0E),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRole = 'warga';
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            selectedRole == 'warga'
                                ? const Color(0xFF1F6711)
                                : const Color(0xFF184E0E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Warga',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 10), // Jarak antar tombol
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          selectedRole = 'admin';
                        });
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            selectedRole == 'admin'
                                ? const Color(0xFF1F6711)
                                : const Color(0xFF184E0E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Masuk',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF37672F),
                fontSize: 35,
              ),
            ),
            const SizedBox(height: 40),
            Text('Email', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Masukkan email anda',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF777777)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text('Password', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: _obscurePassword,
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Masukkan password anda',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF777777)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: boxWidth,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => BottomBar()),
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
                  'Masuk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'Lupa password?',
                style: TextStyle(color: Color(0xFF777777)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
