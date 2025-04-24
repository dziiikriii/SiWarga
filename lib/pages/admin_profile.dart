import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Detail Akun'),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Image.asset('lib/assets/siwarga_logo.png', height: 100),
            SizedBox(height: 20),
            Text(
              'Admin Perum',
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
                  'Admin Perum',
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
                  'admin@gmail.com',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No. Telepon',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Text(
                  '089768374874',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
            SizedBox(height: 20),
            FullWidthButton(text: 'Edit Akun', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
