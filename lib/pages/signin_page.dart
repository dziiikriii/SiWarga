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
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Email', style: TextStyle(fontSize: 14)),
            //     TextButton(
            //       style: TextButton.styleFrom(
            //         padding: EdgeInsets.zero,
            //         splashFactory: NoSplash.splashFactory,
            //         minimumSize: Size.zero,
            //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //       ),
            //       onPressed: () {
            //         // Navigator.push(
            //         //   context,
            //         //   MaterialPageRoute(builder: (context) => LoginPage()),
            //         // );
            //       },
            //       child: Text(
            //         'Daftar dengan No. Telepon',
            //         style: TextStyle(color: Color(0xFF184E0E)),
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 10),
            DefaultInput(
              hint: 'Masukkan email anda',
              label: 'Email',
              controller: emailController,
            ),
            const SizedBox(height: 10),
            DefaultInputPassword(controller: passwordController),
            SizedBox(height: 30),
            SizedBox(
              width: boxWidth,
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Gagal mendaftar')));
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
              // child: Text(
              //   'Lupa password?',
              //   style: TextStyle(color: Color(0xFF777777)),
              //   textAlign: TextAlign.center,
              // ),
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:si_warga/pages/auth_service.dart';
// import 'package:si_warga/pages/first_onboarding.dart';
// import 'package:si_warga/pages/login_page.dart';
// import 'package:si_warga/widgets/blok_no_rumah_input.dart';
// import 'package:si_warga/widgets/default_input.dart';
// import 'package:si_warga/widgets/default_input_password.dart';

// class SigninPage extends StatefulWidget {
//   const SigninPage({super.key});

//   @override
//   State<SigninPage> createState() => _SigninPageState();
// }

// class _SigninPageState extends State<SigninPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final nameController = TextEditingController();
//   final addressController = TextEditingController();
//   final blokControler = TextEditingController();
//   final noRumahController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final boxWidth = screenWidth * 0.9;

//     return Scaffold(
//       backgroundColor: const Color(0xFFECFCEC),
//       body: Padding(
//         padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Icon(Icons.close_rounded, size: 30),
//             const SizedBox(height: 40),
//             const SizedBox(height: 40),
//             const Text(
//               'Daftar',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF37672F),
//                 fontSize: 35,
//               ),
//             ),
//             const SizedBox(height: 40),
//             DefaultInput(
//               hint: 'Masukkan Nama',
//               label: 'Nama',
//               controller: nameController,
//             ),
//             DefaultInput(
//               hint: 'Masukkan Alamat',
//               label: 'Alamat',
//               controller: addressController,
//             ),
//             BlokNoRumahInput(
//               blokController: blokControler,
//               noRumahController: noRumahController,
//             ),
//             DefaultInput(
//               hint: 'Masukkan email anda',
//               label: 'Email',
//               controller: emailController,
//             ),
//             const SizedBox(height: 10),
//             DefaultInputPassword(controller: passwordController),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: boxWidth,
//               child: TextButton(
//                 onPressed: () async {
//                   final email = emailController.text.trim();
//                   final password = passwordController.text.trim();
//                   final name = nameController.text.trim();
//                   final address = addressController.text.trim();
//                   final blok = blokControler.text.trim();
//                   final noRumah = noRumahController.text.trim();

//                   if (email.isEmpty ||
//                       password.isEmpty ||
//                       name.isEmpty ||
//                       address.isEmpty ||
//                       blok.isEmpty ||
//                       blok == 'Blok' ||
//                       noRumah.isEmpty ||
//                       noRumah == 'No. Rumah') {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Semua data harus diisi dengan benar')),
//                     );
//                     return;
//                   }

//                   final user = await AuthService().registerWithEmail(
//                     email: email,
//                     password: password,
//                     name: name,
//                     address: address,
//                     blok: blok,
//                     noRumah: noRumah,
//                   );

//                   if (user != null) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => const FirstOnboarding()),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Gagal mendaftar')),
//                     );
//                   }
//                 },
//                 style: TextButton.styleFrom(
//                   backgroundColor: const Color(0xFF184E0E),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 child: const Text(
//                   'Daftar',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Center(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Sudah punya akun? ',
//                     style: TextStyle(color: Color(0xFF777777)),
//                   ),
//                   TextButton(
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.zero,
//                       splashFactory: NoSplash.splashFactory,
//                       minimumSize: Size.zero,
//                       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                     onPressed: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => const LoginPage()),
//                       );
//                     },
//                     child: const Text(
//                       'Masuk',
//                       style: TextStyle(color: Color(0xFF184E0E)),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
