import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_date.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class TambahPengeluaran extends StatefulWidget {
  const TambahPengeluaran({super.key});

  @override
  State<TambahPengeluaran> createState() => _TambahPengeluaranState();
}

class _TambahPengeluaranState extends State<TambahPengeluaran> {
  final namaPengeluaranController = TextEditingController();
  final jumlahPengeluaranController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tambah Pengeluaran'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultInput(
              hint: 'Nama Pengeluaran',
              label: 'Nama Pengeluaran',
              controller: namaPengeluaranController,
            ),
            DefaultInput(
              hint: 'Jumlah Pengeluaran',
              label: 'Jumlah Pengeluaran',
              controller: jumlahPengeluaranController,
              keyboardType: TextInputType.number,
            ),
            DefaultInputDate(
              title: 'Tanggal Pengeluaran',
              dateController: dateController,
            ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan',
              onPressed: () async {
                final nama = namaPengeluaranController.text;
                final jumlah =
                    int.tryParse(jumlahPengeluaranController.text) ?? 0;

                DateTime? tanggal;
                try {
                  tanggal = DateFormat('dd-MM-yyyy').parse(dateController.text);
                } catch (e) {
                  debugPrint('Tanggal tidak valid: $e');
                  return;
                }

                if (nama.isEmpty || jumlah == 0) {
                  debugPrint('Form tidak valid');
                  return;
                }

                final tahunBulan = DateFormat('yyyy-MMMM').format(tanggal);

                try {
                  await FirebaseFirestore.instance
                      .collection('laporan_keuangan')
                      .doc(tahunBulan)
                      .set({
                        'createdAt': FieldValue.serverTimestamp(),
                      }, SetOptions(merge: true));

                  await FirebaseFirestore.instance
                      .collection('laporan_keuangan')
                      .doc(tahunBulan)
                      .collection('pengeluaran')
                      .add({
                        'nama': nama,
                        'jumlah': jumlah,
                        'tanggal': tanggal.toIso8601String(),
                        'createdAt': FieldValue.serverTimestamp(),
                      });

                  debugPrint('Data berhasil ditambahkan');
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('Gagal menambahkan data: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
