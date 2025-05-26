import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:si_warga/services/supabase_service.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';
import 'package:path/path.dart' as path;

class EditAkunAdmin extends StatefulWidget {
  const EditAkunAdmin({super.key});

  @override
  State<EditAkunAdmin> createState() => _EditAkunAdminState();
}

class _EditAkunAdminState extends State<EditAkunAdmin> {
  String nama = '';
  final TextEditingController _nameController = TextEditingController();

  File? _fotoProfil;

  @override
  void initState() {
    super.initState();
    fetchNamaUser();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _fotoProfil = File(picked.path);
      });
    }
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

            _nameController.text = nama;
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

  Future<void> updateNama(String newName) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      String? imageUrl;

      if (_fotoProfil != null) {
        final fileName = '$uid.jpg';
        imageUrl = await SupabaseService.uploadImage(
          _fotoProfil!.path,
          fileName,
        );
      }

      if (uid != null) {
        final updateData = {'name': newName};

        if (imageUrl != null) {
          updateData['photo_url'] = imageUrl;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update(updateData);

        if (!mounted) return;

        setState(() {
          nama = capitalizeEachWord(newName);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Data berhasil diperbarui')));

        Navigator.pop(context, {
          'name': newName,
          'photo_url':
              imageUrl != null
                  ? '$imageUrl?t=${DateTime.now().millisecondsSinceEpoch}'
                  : null,
        });
      }
    } catch (e) {
      debugPrint('Gagal memperbarui nama: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui data')));
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
            DefaultInput(hint: '', label: 'Nama', controller: _nameController),
            SizedBox(height: 20),
            Text(
              'Upload Foto Profil',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 10),
            TextButton(
              style: TextButton.styleFrom(
                side: BorderSide(color: Color(0xFF777777)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _pickImage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_upload_outlined, color: Color(0xFF777777)),
                  Text(
                    'Tambahkan File',
                    style: TextStyle(color: Color(0xFF777777)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_fotoProfil != null) Image.file(_fotoProfil!, height: 150),
            SizedBox(height: 10),
            Text(path.basename(_fotoProfil?.path ?? '')),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan Perubahan',
              onPressed: () async {
                // final newName = await showDialog<String>(
                //   context: context,
                //   builder: (context) {
                //     TextEditingController nameController =
                //         TextEditingController(text: nama);
                //     return AlertDialog(
                //       title: Text('Edit Nama'),
                //       content: TextField(controller: nameController),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context),
                //           child: Text('Batal'),
                //         ),
                //         TextButton(
                //           onPressed: () {
                //             Navigator.pop(context, nameController.text.trim());
                //           },
                //           child: Text('Simpan'),
                //         ),
                //       ],
                //     );
                //   },
                // );
                // if (newName != null && newName.isNotEmpty) {
                //   await updateNama(newName);
                // }

                final newName = _nameController.text.trim();
                if (newName.isNotEmpty) {
                  await updateNama(newName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Nama tidak boleh kosong')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
