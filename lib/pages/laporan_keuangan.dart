import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/tambah_pemasukan.dart';
import 'package:si_warga/pages/tambah_pengeluaran.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/header_laporan_keuangan.dart';
// import 'package:si_warga/widgets/pengeluaran_pemasukan_button.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_item.dart';
import 'package:si_warga/widgets/year_bar.dart';

class LaporanKeuangan extends StatefulWidget {
  const LaporanKeuangan({super.key});

  @override
  State<LaporanKeuangan> createState() => _LaporanKeuanganState();
}

class _LaporanKeuanganState extends State<LaporanKeuangan> {
  String? role;
  DateTime selectedDate = DateTime.now();
  late Future<Map<String, dynamic>> laporanFuture;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
    laporanFuture = fetchLaporan(selectedDate);
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

  Future<Map<String, dynamic>> fetchLaporan(DateTime date) async {
    // final now = DateTime.now();
    final tahunBulan = '${date.year}-${DateFormat('MMMM').format(date)}';
    final docRef = FirebaseFirestore.instance
        .collection('laporan_keuangan')
        .doc(tahunBulan);

    int saldoAwal = 0;

    final previousMonth = DateTime(date.year, date.month - 1);
    final prevTahunBulan =
        '${previousMonth.year}-${DateFormat('MMMM').format(previousMonth)}';
    final prevDocSnapshot =
        await FirebaseFirestore.instance
            .collection('laporan_keuangan')
            .doc(prevTahunBulan)
            .get();
    if (prevDocSnapshot.exists &&
        prevDocSnapshot.data()!.containsKey('saldoAkhir')) {
      saldoAwal = (prevDocSnapshot.data()!['saldoAkhir'] as num).toInt();
    }

    // Ambil data pemasukan dan pengeluaran
    int totalPemasukan = 0;
    int totalPengeluaran = 0;

    final pemasukanSnapshot = await docRef.collection('pemasukan').get();
    final pengeluaranSnapshot = await docRef.collection('pengeluaran').get();

    final pemasukanList =
        pemasukanSnapshot.docs.map((doc) {
          final data = doc.data();
          totalPemasukan += (data['jumlah'] as num).toInt();
          return {'nama': data['nama'], 'jumlah': data['jumlah']};
        }).toList();

    final pengeluaranList =
        pengeluaranSnapshot.docs.map((doc) {
          final data = doc.data();
          totalPengeluaran += (data['jumlah'] as num).toInt();
          return {'nama': data['nama'], 'jumlah': data['jumlah']};
        }).toList();

    final saldoAkhir = saldoAwal + totalPemasukan - totalPengeluaran;

    // Simpan saldoAwal dan saldoAkhir ke dokumen bulan ini
    await docRef.set({
      'saldoAwal': saldoAwal,
      'saldoAkhir': saldoAkhir,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return {
      'saldoAwal': saldoAwal,
      'pemasukan': pemasukanList,
      'totalPemasukan': totalPemasukan,
      'pengeluaran': pengeluaranList,
      'totalPengeluaran': totalPengeluaran,
      'saldoAkhir': saldoAkhir,
    };
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
              YearBar(
                selectedDate: selectedDate,
                onDateChanged: (newDate) {
                  setState(() {
                    selectedDate = newDate;
                    laporanFuture = fetchLaporan(selectedDate);
                  });
                },
              ),

              // SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: laporanFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.hasError) {
                        return Text('Gagal memuat laporan');
                      }

                      final data = snapshot.data!;
                      final pemasukan = data['pemasukan'] as List;
                      final pengeluaran = data['pengeluaran'] as List;

                      return Column(
                        children: [
                          // YearBar(),
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
                                  HeaderLaporanKeuangan(
                                    title: 'Saldo Kas Awal',
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Saldo Awal',
                                    value: data['saldoAwal'],
                                  ),
                                  HeaderLaporanKeuangan(title: 'Pemasukan'),
                                  ...pemasukan.map(
                                    (item) => PengeluaranPemasukanItem(
                                      name: item['nama'],
                                      value: item['jumlah'],
                                    ),
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Total Pemasukan',
                                    value: data['totalPemasukan'],
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF184E0E),
                                  ),
                                  HeaderLaporanKeuangan(title: 'Pengeluaran'),
                                  ...pengeluaran.map(
                                    (item) => PengeluaranPemasukanItem(
                                      name: item['nama'],
                                      value: item['jumlah'],
                                    ),
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Total Pengeluaran',
                                    value: data['totalPengeluaran'],
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF184E0E),
                                  ),
                                  HeaderLaporanKeuangan(
                                    title: 'Saldo Kas Akhir',
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Saldo Akhir',
                                    value: data['saldoAkhir'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
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
                onSelected: (value) async {
                  if (value == 1) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TambahPemasukan()),
                    );
                    setState(() {
                      laporanFuture = fetchLaporan(selectedDate);
                    });
                  } else if (value == 2) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TambahPengeluaran()),
                    );
                    setState(() {
                      laporanFuture = fetchLaporan(selectedDate);
                    });
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
