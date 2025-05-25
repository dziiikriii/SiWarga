import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/detail_laporan_keuangan_item.dart';
import 'package:si_warga/widgets/header_laporan_keuangan.dart';

class DetailLaporanKeuangan extends StatefulWidget {
  final DateTime selectedDate;
  const DetailLaporanKeuangan({super.key, required this.selectedDate});

  @override
  State<DetailLaporanKeuangan> createState() => _DetailLaporanKeuanganState();
}

class _DetailLaporanKeuanganState extends State<DetailLaporanKeuangan> {
  late String bulan;

  @override
  void initState() {
    super.initState();
    bulan =
        '${widget.selectedDate.year}-${DateFormat('MMMM').format(widget.selectedDate)}';
  }

  Stream<List<Map<String, dynamic>>> getDataByBulan(String tipe) {
    return FirebaseFirestore.instance
        .collection('laporan_keuangan')
        .doc(bulan)
        .collection(tipe)
        .orderBy('tanggal', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) {
                final data = doc.data();
                return {'docId': doc.id, ...data};
              }).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Detail Laporan Keuangan'),
      body: Container(
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderLaporanKeuangan(title: 'Detail Pemasukan', arrow: false),
                // DetailLaporanKeuanganItem(),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getDataByBulan('pemasukan'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Belum ada data pemasukan'),
                      );
                    }

                    final data = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return DetailLaporanKeuanganItem(
                          docId:
                              snapshot.data![index]['docId'] ??
                              snapshot.data![index]['id'] ??
                              '',
                          tipe: 'pemasukan',
                          nama: item['nama'] ?? 'Pemasukan',
                          jumlah: item['jumlah'] ?? 0,
                          keterangan:
                              item['keterangan'] ?? 'Tidak ada keterangan',
                          tanggal:
                              item['tanggal'] is Timestamp
                                  ? (item['tanggal'] as Timestamp).toDate()
                                  : DateTime.parse(item['tanggal']),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                HeaderLaporanKeuangan(
                  title: 'Detail Pengeluaran',
                  arrow: false,
                ),
                // DetailLaporanKeuanganItem(),
                StreamBuilder<List<Map<String, dynamic>>>(
                  stream: getDataByBulan('pengeluaran'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("Belum ada data pengeluaran."),
                      );
                    }

                    final data = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return DetailLaporanKeuanganItem(
                          docId:
                              snapshot.data![index]['docId'] ??
                              snapshot.data![index]['id'] ??
                              '',
                          tipe: 'pengeluaran',
                          nama: item['nama'] ?? 'Pengeluaran',
                          jumlah: item['jumlah'] ?? 0,
                          keterangan:
                              item['keterangan'] ?? 'Tidak ada keterangan',
                          tanggal:
                              item['tanggal'] is Timestamp
                                  ? (item['tanggal'] as Timestamp).toDate()
                                  : DateTime.parse(item['tanggal']),

                          // keterangan: item['keterangan'] ?? '-',
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
