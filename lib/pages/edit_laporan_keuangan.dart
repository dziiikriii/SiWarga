import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_date.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class EditLaporanKeuangan extends StatefulWidget {
  final String docId;
  final String nama;
  final int jumlah;
  final String keterangan;
  final DateTime tanggal;
  final String tipe;
  const EditLaporanKeuangan({
    super.key,
    required this.docId,
    required this.nama,
    required this.jumlah,
    required this.keterangan,
    required this.tanggal,
    required this.tipe,
  });

  @override
  State<EditLaporanKeuangan> createState() => _EditLaporanKeuanganState();
}

class _EditLaporanKeuanganState extends State<EditLaporanKeuangan> {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController();
  final dateController = TextEditingController();
  final keteranganController = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaController.text = widget.nama;
    jumlahController.text = widget.jumlah.toString();
    keteranganController.text = widget.keterangan;
    dateController.text = DateFormat('dd-MM-yyyy').format(widget.tanggal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tambah Pemasukan'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultInput(
              hint: 'Nama',
              label: 'Nama',
              controller: namaController,
            ),
            DefaultInput(
              hint: 'Jumlah',
              label: 'Jumlah',
              controller: jumlahController,
              keyboardType: TextInputType.number,
            ),
            DefaultInput(
              hint: 'Keterangan',
              label: 'Keterangan',
              controller: keteranganController,
            ),
            DefaultInputDate(title: 'Tanggal', dateController: dateController),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan',
              onPressed: () async {
                try {
                  // Parse tanggal dari input user
                  final parsedDate = DateFormat(
                    'dd-MM-yyyy',
                  ).parse(dateController.text);

                  // Format bulan sesuai struktur koleksi Firestore
                  final bulan =
                      '${parsedDate.year}-${DateFormat('MMMM').format(parsedDate)}';

                  final docRef = FirebaseFirestore.instance
                      .collection('laporan_keuangan')
                      .doc(bulan)
                      .collection(widget.tipe)
                      .doc(widget.docId);

                  await docRef.update({
                    'nama': namaController.text,
                    'jumlah': int.tryParse(jumlahController.text) ?? 0,
                    'keterangan': keteranganController.text,
                    'tanggal': parsedDate,
                  });

                  if (!context.mounted) return;
                  Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Format tanggal tidak valid')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
