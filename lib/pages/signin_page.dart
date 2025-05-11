import 'package:flutter/material.dart';
import 'package:si_warga/pages/auth_service.dart';
import 'package:si_warga/pages/login_page.dart';
import 'package:si_warga/widgets/blok_no_rumah_input.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_password.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final blokControler = TextEditingController();
  final noRumahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFCEC),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded, size: 30),
              ),
              // WargaAdminLoginBar(),
              const SizedBox(height: 40),
              Text(
                'Daftar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37672F),
                  fontSize: 35,
                ),
              ),
              const SizedBox(height: 40),
              DefaultInput(
                hint: 'Masukkan Nama',
                label: 'Nama',
                controller: nameController,
              ),
              DefaultInput(
                hint: 'Masukkan Alamat',
                label: 'Alamat',
                controller: addressController,
              ),
              BlokNoRumahInput(
                blokController: blokControler,
                noRumahController: noRumahController,
              ),
              DefaultInput(
                hint: 'Masukkan email anda',
                label: 'Email',
                controller: emailController,
              ),
              const SizedBox(height: 10),
              DefaultInputPassword(controller: passwordController),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    final name = nameController.text.trim();
                    final address = addressController.text.trim();
                    final blok = blokControler.text.trim();
                    final noRumah = noRumahController.text.trim();

                    if (email.isEmpty ||
                        password.isEmpty ||
                        name.isEmpty ||
                        address.isEmpty ||
                        blok.isEmpty ||
                        blok == 'Blok' ||
                        noRumah.isEmpty ||
                        noRumah == 'No. Rumah') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Semua data harus diisi dengan benar'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    final user = await AuthService().registerWithEmail(
                      email,
                      password,
                    );
                    if (user != null) {
                      // Simpan data tambahan ke Firestore
                      await AuthService().saveUserData(
                        user.uid,
                        name,
                        email,
                        address,
                        blok,
                        noRumah,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Email verifikasi telah dikirim. Silahkan cek email anda.',
                          ),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal mendaftar')),
                      );
                    }
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
                    'Daftar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: TextStyle(color: Color(0xFF777777)),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        splashFactory: NoSplash.splashFactory,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Masuk',
                        style: TextStyle(color: Color(0xFF184E0E)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
