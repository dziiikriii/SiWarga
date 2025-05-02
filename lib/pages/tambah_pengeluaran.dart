import 'package:flutter/material.dart';
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
            DefaultInputDate(title: 'Tanggal Pengeluaran'),
            SizedBox(height: 20),
            FullWidthButton(text: 'Simpan', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
