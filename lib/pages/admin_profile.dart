import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/auth_service.dart';
import 'package:si_warga/pages/edit_akun_admin.dart';
import 'package:si_warga/pages/login_page.dart';
import 'package:si_warga/pages/tambah_admin.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String nama = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchDataProfil();
    // Future.delayed(Duration.zero, fetchDataProfil());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchDataProfil();
  }

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> fetchDataProfil() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final docSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        debugPrint('UID: ${FirebaseAuth.instance.currentUser?.uid}');

        if (docSnapshot.exists) {
          setState(() {
            nama = capitalizeEachWord(docSnapshot.data()?['name']);
            email = user.email ?? '';
            // email = docSnapshot.data()?['email'];
          });
        }
      }
    } catch (e) {
      debugPrint('Error mengambil data user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: 'Detail Akun',
        actions: [
          IconButton(
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text(
                        'Konfirmasi Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      content: Text('Apakah Anda yakin ingin logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Batal',
                            style: TextStyle(color: Color(0xFF777777)),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 42, 42),
                            ),
                          ),
                        ),
                      ],
                    ),
              );

              if (shouldLogout == true) {
                await AuthService().logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Image.asset('lib/assets/siwarga_logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              nama,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Nama',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(
                  nama,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(
                  email,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       'No. Telepon',
            //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            //     ),
            //     Text(
            //       '089768374874',
            //       style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            //     ),
            //   ],
            // ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Edit Akun',
              onPressed: () async {
                final updatedName = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditAkunAdmin()),
                );

                if (updatedName != null && updatedName is String) {
                  setState(() {
                    nama = capitalizeEachWord(updatedName);
                  });
                }
              },
            ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Tambah Admin',
              color: Color(0xFF749C6C),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TambahAdmin()),
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
