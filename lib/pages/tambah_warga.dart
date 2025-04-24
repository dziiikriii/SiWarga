import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:si_warga/pages/homepage.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_password.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class TambahWarga extends StatelessWidget {
  const TambahWarga({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Kelola Warga'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Tambahkan Warga Baru!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Color(0xFF37672F),
              ),
            ),
            DefaultInput(label: 'Username', hint: 'Masukkan Username'),
            DefaultInputPassword(),
            DefaultInput(label: 'Alamat', hint: 'Masukkan Alamat'),
            DefaultInput(
              label: 'Blok & No. Rumah',
              hint: 'Masukkan Blok dan No. Rumah',
            ),
            DefaultInput(
              label: 'No. Telepon',
              hint: 'Masukkan No. Telepon',
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan Warga',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Homepage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
