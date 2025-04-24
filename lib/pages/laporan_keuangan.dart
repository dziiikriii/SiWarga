import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/header_laporan_keuangan.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_button.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_item.dart';
import 'package:si_warga/widgets/year_bar.dart';

class LaporanKeuangan extends StatelessWidget {
  const LaporanKeuangan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Laporan Keuangan'),
      body: Column(
        children: [
          YearBar(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    HeaderLaporanKeuangan(title: 'Saldo Kas Awal'),
                    PengeluaranPemasukanItem(
                      name: 'Total Saldo Awal Maret 2025',
                      value: 25000000,
                    ),
                    HeaderLaporanKeuangan(title: 'Pemasukan dan Pengeluaran'),
                    PengeluaranPemasukanButton(text: 'Pemasukan'),
                    PengeluaranPemasukanItem(
                      name: 'Iuran Warga',
                      value: 5000000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Sumbangan Warga',
                      value: 2500000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Total Pemasukan',
                      value: 7500000,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF184E0E),
                    ),
                    PengeluaranPemasukanButton(text: 'Pengeluaran'),
                    PengeluaranPemasukanItem(
                      name: 'Gaji Pokok Satpam RT',
                      value: 5000000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Acara Buka Bersama',
                      value: 2500000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Pembelian Semen',
                      value: 1500000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Pembelian Pasir',
                      value: 2000000,
                    ),
                    PengeluaranPemasukanItem(
                      name: 'Total Pengeluaran',
                      value: 11000000,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF184E0E),
                    ),
                    HeaderLaporanKeuangan(title: 'Saldo Kas Akhir'),
                    PengeluaranPemasukanItem(
                      name: 'Total Saldo Akhir Maret 2025',
                      value: 21500000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
