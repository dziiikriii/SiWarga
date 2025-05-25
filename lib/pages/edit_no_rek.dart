import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class EditNoRek extends StatefulWidget {
  final String docId;
  const EditNoRek({super.key, required this.docId});

  @override
  State<EditNoRek> createState() => _EditNoRekState();
}

class _EditNoRekState extends State<EditNoRek> {
  final namaBankController = TextEditingController();
  final noRekController = TextEditingController();
  final namaPemilikController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('nomor_rekening')
            .doc(widget.docId)
            .get();

    final data = doc.data();
    if (data != null) {
      namaBankController.text = data['nama_bank'] ?? '';
      noRekController.text = data['no_rek'] ?? '';
      namaPemilikController.text = data['nama_pemilik'] ?? '';
    }

    setState(() {
      isLoading = false;
    });
  }

  void updateData() async {
    await FirebaseFirestore.instance
        .collection('nomor_rekening')
        .doc(widget.docId)
        .update({
          'nama_bank': namaBankController.text,
          'no_rek': noRekController.text,
          'nama_pemilik': namaPemilikController.text,
        });

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Berhasil menyimpan perubahan')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Edit Nomor Rekening'),
      body: Container(
        padding: EdgeInsets.all(20),
        child:
            isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
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
                      controller: namaPemilikController,
                    ),
                    FullWidthButton(text: 'Simpan', onPressed: updateData),
                  ],
                ),
      ),
    );
  }
}
