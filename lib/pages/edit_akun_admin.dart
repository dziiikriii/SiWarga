import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class EditAkunAdmin extends StatefulWidget {
  const EditAkunAdmin({super.key});

  @override
  State<EditAkunAdmin> createState() => _EditAkunAdminState();
}

class _EditAkunAdminState extends State<EditAkunAdmin> {
  String nama = '';
  final TextEditingController _nameController = TextEditingController();

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
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': newName,
        });

        if (!mounted) return;

        setState(() {
          nama = capitalizeEachWord(newName);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Nama berhasil diperbarui')));

        Navigator.pop(context, newName);
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
            DefaultInput(hint: '', label: 'Nama', controller: _nameController),
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
