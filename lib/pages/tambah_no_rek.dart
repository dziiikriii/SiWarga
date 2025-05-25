import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class TambahNoRek extends StatelessWidget {
  final namaBankController = TextEditingController();
  final noRekController = TextEditingController();
  final pemilikController = TextEditingController();

  TambahNoRek({super.key});

  void simpanRekening(BuildContext context) async {
    await FirebaseFirestore.instance.collection('nomor_rekening').add({
      'nama_bank': namaBankController.text,
      'no_rek': noRekController.text,
      'nama_pemilik': pemilikController.text,
    });

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nomor rekening berhasil ditambahkan')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tambah Nomor Rekening'),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultInput(
              hint: 'Nama Bank',
              label: 'Nama Bank',
              controller: namaBankController,
            ),
            DefaultInput(
              hint: 'Nomor Rekening',
              label: 'Nomor Rekening',
              keyboardType: TextInputType.numberWithOptions(),
              controller: noRekController,
            ),
            DefaultInput(
              hint: 'Nama Pemilik Rekening',
              label: 'Nama Pemilik Rekening',
              controller: pemilikController,
            ),
            FullWidthButton(
              text: 'Simpan',
              onPressed: () => simpanRekening(context),
            ),
          ],
        ),
      ),
    );
  }
}
