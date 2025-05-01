import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/blok_no_rumah_input.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class EditAkunWarga extends StatefulWidget {
  const EditAkunWarga({super.key});

  @override
  State<EditAkunWarga> createState() => _EditAkunWargaState();
}

class _EditAkunWargaState extends State<EditAkunWarga> {
  String nama = '';
  String alamat = '';
  String blok = '';
  String noRumah = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _blokController = TextEditingController();
  final TextEditingController _noRumahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNamaUser();
  }

  Future<void> fetchNamaUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final docSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (docSnapshot.exists) {
          setState(() {
            nama = docSnapshot.data()?['name'] ?? 'Admin';
            alamat = docSnapshot.data()?['address'] ?? '';
            blok = docSnapshot.data()?['blok'] ?? '';
            noRumah = docSnapshot.data()?['no_rumah'] ?? '';

            // Set default value ke controller
            _nameController.text = nama;
            _alamatController.text = alamat;
            _blokController.text = blok;
            _noRumahController.text = noRumah;
          });
        }
      }
    } catch (e) {
      debugPrint('Error mengambil nama user: $e');
    }
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

  Future<void> updateData(
    String newName,
    String newAlamat,
    String newBlok,
    String newNoRumah,
  ) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': newName,
          'address': newAlamat,
          'blok': newBlok,
          'no_rumah': newNoRumah,
        });

        if (!mounted) return;

        setState(() {
          nama = capitalizeEachWord(newName);
          alamat = newAlamat;
          blok = newBlok;
          noRumah = newNoRumah;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Data berhasil diperbarui')));

        Navigator.pop(context, {
          'name': newName,
          'address': newAlamat,
          'blok': newBlok,
          'no_rumah': newNoRumah,
        });
      }
    } catch (e) {
      debugPrint('Gagal memperbarui nama: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui nama')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Edit Akun'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultInput(
              // hint: capitalizeEachWord(nama),
              hint: '',
              label: 'Nama',
              controller: _nameController,
            ),
            SizedBox(height: 20),
            DefaultInput(
              // hint: capitalizeEachWord(alamat),
              hint: '',
              label: 'Alamat',
              controller: _alamatController,
            ),
            SizedBox(height: 20),
            BlokNoRumahInput(
              blokController: _blokController,
              noRumahController: _noRumahController,
            ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan Perubahan',
              onPressed: () async {
                final newName = _nameController.text.trim();
                final newAddress = _alamatController.text.trim();
                final newBlok = _blokController.text.trim();
                final newNoRumah = _noRumahController.text.trim();
                if (newName.isNotEmpty) {
                  await updateData(newName, newAddress, newBlok, newNoRumah);
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Data kosong')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
