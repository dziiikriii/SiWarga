import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/tambah_pemasukan.dart';
import 'package:si_warga/pages/tambah_pengeluaran.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/header_laporan_keuangan.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_button.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_item.dart';
import 'package:si_warga/widgets/year_bar.dart';

class LaporanKeuangan extends StatefulWidget {
  const LaporanKeuangan({super.key});

  @override
  State<LaporanKeuangan> createState() => _LaporanKeuanganState();
}

class _LaporanKeuanganState extends State<LaporanKeuangan> {
  String? role;
  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      setState(() {
        role = doc.data()?['role'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Laporan Keuangan'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              YearBar(),
              SizedBox(height: 20),
              Container(
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
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
                      ),
                      PengeluaranPemasukanItem(
                        name: 'Pembelian Pasir',
                        value: 2000000,
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
            ],
          ),
        ),
      ),
      floatingActionButton:
          role == 'admin'
              ? PopupMenuButton<int>(
                onSelected: (value) {
                  if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TambahPemasukan()),
                    );
                  } else if (value == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TambahPengeluaran()),
                    );
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(value: 1, child: Text('Tambah Pemasukan')),
                      PopupMenuItem(
                        value: 2,
                        child: Text('Tambah Pengeluaran'),
                      ),
                    ],
                offset: Offset(0, -105), // posisikan di atas FAB
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                icon: FloatingActionButton(
                  onPressed: null, // disable klik langsung
                  backgroundColor: Color(0xFF37672F),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              )
              : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
