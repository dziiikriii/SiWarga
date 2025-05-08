import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_date.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class TambahPemasukan extends StatefulWidget {
  const TambahPemasukan({super.key});

  @override
  State<TambahPemasukan> createState() => _TambahPemasukanState();
}

class _TambahPemasukanState extends State<TambahPemasukan> {
  final namaPemasukanController = TextEditingController();
  final jumlahPemasukanController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tambah Pemasukan'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DefaultInput(
              hint: 'Nama Pemasukan',
              label: 'Nama Pemasukan',
              controller: namaPemasukanController,
            ),
            DefaultInput(
              hint: 'Jumlah Pemasukan',
              label: 'Jumlah Pemasukan',
              controller: jumlahPemasukanController,
              keyboardType: TextInputType.number,
            ),
            DefaultInputDate(title: 'Tanggal Pemasukan', dateController: dateController,),
            SizedBox(height: 20),
            FullWidthButton(text: 'Simpan', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
