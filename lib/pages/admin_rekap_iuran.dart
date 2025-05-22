import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/bar_tahun.dart';
import 'package:si_warga/widgets/blok_bar.dart';
import 'package:si_warga/widgets/bulan_rekap_bar.dart';
import 'package:si_warga/widgets/rekap_per_warga.dart';

class AdminRekapIuran extends StatefulWidget {
  const AdminRekapIuran({super.key});

  @override
  State<AdminRekapIuran> createState() => _AdminRekapIuranState();
}

class _AdminRekapIuranState extends State<AdminRekapIuran> {
  DateTime selectedDate = DateTime.now();
  String selectedBlok = 'A';

  Stream<List<bool>> getStatusIuranWargaStream({
    required String userId,
    required int tahun,
  }) {
    final bulanList = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return FirebaseFirestore.instance
        .collection('tagihan_user')
        .doc(userId)
        .collection('items')
        .where('tipe', isEqualTo: 'Iuran Bulanan')
        .where('status', isEqualTo: 'lunas')
        .snapshots()
        .map((snapshot) {
          final List<bool> checklist = List.filled(12, false);

          for (var doc in snapshot.docs) {
            final nama = doc['nama']?.toString() ?? '';
            // final tanggal = doc['tanggal_bayar'];
            final tanggal = doc['tenggat']?.toString();

            if (tanggal != null && tanggal.isNotEmpty) {
              try {
                final date = DateTime.parse(
                  tanggal.split('-').reversed.join('-'),
                );
                if (date.year == tahun) {
                  for (int i = 0; i < 12; i++) {
                    final namaBulan = bulanList[i];
                    if (nama.contains(namaBulan)) {
                      checklist[i] = true;
                    }
                  }
                }
              } catch (e) {
                debugPrint('Format tenggat tidak valid: $tanggal');
              }
            }
          }

          debugPrint('Checklist untuk $userId : $checklist');
          return checklist;
        });
  }

  @override
  Widget build(BuildContext context) {
    final tahun = selectedDate.year;

    return Scaffold(
      appBar: AppBarDefault(title: 'Rekap Iuran Warga'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 10),
            BarTahun(
              selectedDate: selectedDate,
              onDateChanged: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
            SizedBox(height: 10),
            BlokBar(
              onBlokSelected: (blok) {
                setState(() {
                  selectedBlok = blok;
                });
              },
            ), // Optional: jika ingin filter berdasarkan blok
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BulanRekapBar(),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .where('role', isEqualTo: 'warga')
                                      .where('blok', isEqualTo: selectedBlok)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final docs = snapshot.data!.docs;

                                return Column(
                                  children:
                                      docs.map((doc) {
                                        // final kodeWarga = doc['role'] ?? '??';
                                        final userId = doc.id;
                                        final namaWarga = doc['name'] ?? '';
                                        final noRumah = doc['no_rumah'] ?? '';
                                        // final displayKode = '$kodeWarga - ${namaWarga.substring(0, 3)}';
                                        final displayKode =
                                            '${namaWarga.substring(0, 3)}-$noRumah';

                                        // Dummy checklist, bisa diganti pakai tagihan firebase
                                        // final kondisiChecklist = List.generate(
                                        //   12,
                                        //   (i) => false,
                                        // );

                                        return StreamBuilder<List<bool>>(
                                          key: ValueKey('${userId}_$tahun'),
                                          stream: getStatusIuranWargaStream(
                                            userId: userId,
                                            tahun: tahun,
                                          ),
                                          builder: (context, snapshot) {
                                            debugPrint(
                                              'Membangun rekap untuk $userId',
                                            );
                                            if (!snapshot.hasData) {
                                              return const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 8,
                                                ),
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }

                                            final kondisiChecklist =
                                                snapshot.data!;

                                            return RekapPerWarga(
                                              kodeWarga: displayKode,
                                              kondisiChecklist:
                                                  kondisiChecklist,
                                              namaWarga: namaWarga,
                                              userId: userId,
                                            );
                                          },
                                        );
                                      }).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
