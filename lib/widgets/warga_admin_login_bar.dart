import 'package:flutter/material.dart';

class WargaAdminLoginBar extends StatefulWidget {
  const WargaAdminLoginBar({super.key});

  @override
  State<WargaAdminLoginBar> createState() => _WargaAdminLoginBarState();
}

class _WargaAdminLoginBarState extends State<WargaAdminLoginBar> {

    String selectedRole = 'warga'; // Default pilihan aktif
  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
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
            );
  }
}