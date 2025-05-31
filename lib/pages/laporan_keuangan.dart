import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:si_warga/pages/detail_laporan_keuangan.dart';
import 'package:si_warga/pages/tambah_pemasukan.dart';
import 'package:si_warga/pages/tambah_pengeluaran.dart';
import 'package:si_warga/services/laporan_service.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/full_width_button.dart';
import 'package:si_warga/widgets/header_laporan_keuangan.dart';
import 'package:si_warga/widgets/pengeluaran_pemasukan_item.dart';
import 'package:si_warga/widgets/year_bar.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
    // _updateAndFetchLaporan();
    LaporanService.updateLaporanKeuanganOtomatis(selectedDate);
    laporanFuture = fetchLaporan(selectedDate);
  }

  // Future<void> _updateAndFetchLaporan() async {
  //   await LaporanService.updateLaporanKeuanganOtomatis(selectedDate);
  //   setState(() {
  //     laporanFuture = fetchLaporan(selectedDate);
  //   });
  // }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          role = doc.data()?['role'];
        });
      }
    }
  }

  Future<Map<String, dynamic>> fetchLaporan(DateTime date) async {
    final tahunBulan = '${date.year}-${DateFormat('MMMM').format(date)}';
    final docRef = FirebaseFirestore.instance
        .collection('laporan_keuangan')
        .doc(tahunBulan);
    // final docRefData = await docRef.get();

    final docSnapshot = await docRef.get();
    final totalIuran =
        docSnapshot.exists ? (docSnapshot.data()?['total'] ?? 0) : 0;

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

    int totalPemasukan = 0;
    int totalPemasukanLainnya = 0;
    int totalPengeluaran = 0;

    final pemasukanSnapshot = await docRef.collection('pemasukan').get();
    final pengeluaranSnapshot = await docRef.collection('pengeluaran').get();
    // final pemasukanLainnya

    totalPemasukanLainnya = docSnapshot.data()?['total'];
    final pemasukanList =
        pemasukanSnapshot.docs.map((doc) {
          final data = doc.data();
          totalPemasukan += (data['jumlah'] as num).toInt();
          debugPrint('totalPemasukanLainnya = $totalPemasukanLainnya');
          // totalPemasukan =
          //     totalPemasukan +
          //     (data['jumlah'] as num).toInt() +
          //     totalPemasukanLainnya;
          return {
            'nama': data['nama'],
            'jumlah': data['jumlah'],
            'tanggal': data['tanggal'],
            'keterangan': data['keterangan'],
          };
        }).toList();

    totalPemasukan += totalPemasukanLainnya;

    final pengeluaranList =
        pengeluaranSnapshot.docs.map((doc) {
          final data = doc.data();
          totalPengeluaran += (data['jumlah'] as num).toInt();
          return {
            'nama': data['nama'],
            'jumlah': data['jumlah'],
            'tanggal': data['tanggal'],
            'keterangan': data['keterangan'],
          };
        }).toList();

    final saldoAkhir = saldoAwal + totalPemasukan - totalPengeluaran;

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
      'totalIuran': totalIuran,
    };
  }

  Future<void> generateLaporanPDF({
    required DateTime selectedDate,
    required int saldoAwal,
    required int totalPemasukan,
    required int totalPengeluaran,
    required int saldoAkhir,
    required List pemasukan,
    required List pengeluaran,
  }) async {
    final pdf = pw.Document();
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormat = DateFormat('d MMM yyyy', 'id_ID');
    final bulanTahun = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);
    final tanggalCetak = DateFormat(
      'd MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());
    final jamCetak = DateFormat('HH:mm').format(DateTime.now());

    final headerStyle = pw.TextStyle(
      fontSize: 14,
      fontWeight: pw.FontWeight.bold,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
    );
    final bodyStyle = pw.TextStyle(fontSize: 10);

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build:
            (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Judul
                pw.Center(
                  child: pw.Text(
                    'LAPORAN KEUANGAN RT 01 / RW 01\nBULAN ${bulanTahun.toUpperCase()}',
                    style: headerStyle,
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 24),

                // Saldo Awal
                pw.Text('SALDO AWAL', style: subHeaderStyle),
                pw.Divider(),
                pw.Text(
                  'Saldo Awal: ${formatter.format(saldoAwal)}',
                  style: bodyStyle,
                ),
                pw.SizedBox(height: 16),

                // Pemasukan
                pw.Text('PEMASUKAN', style: subHeaderStyle),
                pw.Divider(),
                pemasukan.isEmpty
                    ? pw.Text('Tidak ada pemasukan.', style: bodyStyle)
                    : pw.Table.fromTextArray(
                      headers: [
                        'No',
                        'Tanggal',
                        'Nama',
                        'Jumlah (Rp)',
                        'Keterangan',
                      ],
                      data:
                          pemasukan.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final item = entry.value;
                            final tanggal =
                                item['tanggal'] != null
                                    ? (() {
                                      final rawTanggal = item['tanggal'];
                                      if (rawTanggal is Timestamp) {
                                        return dateFormat.format(
                                          rawTanggal.toDate(),
                                        );
                                      } else if (rawTanggal is DateTime) {
                                        return dateFormat.format(rawTanggal);
                                      } else if (rawTanggal is String) {
                                        return dateFormat.format(
                                          DateTime.parse(rawTanggal),
                                        );
                                      } else {
                                        return '-';
                                      }
                                    })()
                                    : '-';
                            final nama = item['nama'] ?? '-';
                            final jumlah = formatter.format(item['jumlah']);
                            final keterangan =
                                (item['keterangan'] != null &&
                                        item['keterangan']
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                    ? item['keterangan'].toString()
                                    : 'Tidak ada keterangan';
                            return ['$idx', tanggal, nama, jumlah, keterangan];
                          }).toList(),
                      cellStyle: bodyStyle,
                      headerStyle: subHeaderStyle,
                      headerDecoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Total Pemasukan: ${formatter.format(totalPemasukan)}',
                  style: bodyStyle,
                ),
                pw.SizedBox(height: 16),

                // Pengeluaran
                pw.Text('PENGELUARAN', style: subHeaderStyle),
                pw.Divider(),
                pengeluaran.isEmpty
                    ? pw.Text('Tidak ada pengeluaran.', style: bodyStyle)
                    : pw.Table.fromTextArray(
                      headers: [
                        'No',
                        'Tanggal',
                        'Nama',
                        'Jumlah (Rp)',
                        'Keterangan',
                      ],
                      data:
                          pengeluaran.asMap().entries.map((entry) {
                            final idx = entry.key + 1;
                            final item = entry.value;

                            // Tanggal
                            final tanggal =
                                item['tanggal'] != null
                                    ? (() {
                                      final rawTanggal = item['tanggal'];
                                      if (rawTanggal is Timestamp) {
                                        return dateFormat.format(
                                          rawTanggal.toDate(),
                                        );
                                      } else if (rawTanggal is DateTime) {
                                        return dateFormat.format(rawTanggal);
                                      } else if (rawTanggal is String) {
                                        return dateFormat.format(
                                          DateTime.parse(rawTanggal),
                                        );
                                      } else {
                                        return '-';
                                      }
                                    })()
                                    : '-';

                            // Nama
                            final nama = item['nama'] ?? '-';

                            // Jumlah
                            final jumlah = formatter.format(item['jumlah']);

                            // Keterangan
                            final keterangan =
                                (item['keterangan'] != null &&
                                        item['keterangan']
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                    ? item['keterangan'].toString()
                                    : 'Tidak ada keterangan';

                            return ['$idx', tanggal, nama, jumlah, keterangan];
                          }).toList(),

                      cellStyle: bodyStyle,
                      headerStyle: subHeaderStyle,
                      headerDecoration: pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      cellAlignment: pw.Alignment.centerLeft,
                    ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Total Pengeluaran: ${formatter.format(totalPengeluaran)}',
                  style: bodyStyle,
                ),
                pw.SizedBox(height: 16),

                // Saldo Akhir
                pw.Text('SALDO AKHIR', style: subHeaderStyle),
                pw.Divider(),
                pw.Text(
                  'Saldo Akhir: ${formatter.format(saldoAkhir)}',
                  style: bodyStyle,
                ),
                pw.SizedBox(height: 24),

                // Catatan waktu
                pw.Text(
                  'Dokumen ini dibuat pada $tanggalCetak pukul $jamCetak WIB',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Berhasil download laporan sebagai PDF'),
        backgroundColor: Color(0xFF184E0E),
      ),
    );
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
                    LaporanService.updateLaporanKeuanganOtomatis(selectedDate);
                  });
                },
              ),

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
                      // final totalIuran = data['totalIuran'] ?? 0;
                      final totalIuran =
                          (data['totalIuran'] as num?)?.toInt() ?? 0;

                      return Column(
                        children: [
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
                                    arrow: false,
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Saldo Awal',
                                    value: data['saldoAwal'],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      role == 'admin'
                                          ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => DetailLaporanKeuangan(
                                                    selectedDate: selectedDate,
                                                  ),
                                            ),
                                          )
                                          : null;
                                    },
                                    child: HeaderLaporanKeuangan(
                                      title: 'Pemasukan',
                                      arrow: role == 'admin' ? true : false,
                                    ),
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Total Iuran Warga',
                                    value: totalIuran,
                                    fontWeight: FontWeight.bold,
                                    // color:
                                    //     Colors
                                    //         .green, // Warna khusus untuk iuran
                                  ),
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
                                  InkWell(
                                    onTap: () {
                                      role == 'admin'
                                          ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => DetailLaporanKeuangan(
                                                    selectedDate: selectedDate,
                                                  ),
                                            ),
                                          )
                                          : null;
                                    },
                                    child: HeaderLaporanKeuangan(
                                      title: 'Pengeluaran',
                                      arrow: role == 'admin' ? true : false,
                                    ),
                                  ),
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
                                    arrow: false,
                                  ),
                                  PengeluaranPemasukanItem(
                                    name: 'Saldo Akhir',
                                    value: data['saldoAkhir'],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          FullWidthButton(
                            icon: Icon(Icons.picture_as_pdf),
                            text: 'Download Laporan Sebagai PDF',
                            onPressed: () async {
                              final data = await laporanFuture;

                              await generateLaporanPDF(
                                selectedDate: selectedDate,
                                saldoAwal: data['saldoAwal'],
                                totalPemasukan: data['totalPemasukan'],
                                totalPengeluaran: data['totalPengeluaran'],
                                saldoAkhir: data['saldoAkhir'],
                                pemasukan: data['pemasukan'],
                                pengeluaran: data['pengeluaran'],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              role == 'admin' ? SizedBox(height: 60) : SizedBox(height: 1),
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
