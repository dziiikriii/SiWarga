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
  String? selectedValue = 'Iuran Bulanan';
  final List<String> options = ['Iuran Bulanan', 'Iuran Insidental'];
  List<String> headerTitles = [];

  @override
  void initState() {
    super.initState();
    updateHeaderTitles();
  }

  Stream<List<bool>> getStatusIuranWargaStream({
    required String userId,
    required int tahun,
    required String tipe,
    List<String>? customLabels,
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

    final labelList =
        tipe == 'Iuran Bulanan' ? bulanList : (customLabels ?? []);

    return FirebaseFirestore.instance
        .collection('tagihan_user')
        .doc(userId)
        .collection('items')
        .where('tipe', isEqualTo: tipe == 'Iuran Bulanan' ? 'Iuran Bulanan' : 'Iuran Lainnya')
        .where('status', isEqualTo: 'lunas')
        .snapshots()
        .map((snapshot) {
          final List<bool> checklist = List.filled(labelList.length, false);

          for (var doc in snapshot.docs) {
            debugPrint('Doc ditemukan: ${doc.data()}');
            final nama = doc['nama']?.toString() ?? '';
            // final tanggal = doc['tanggal_bayar'];
            final tanggal = doc['tenggat']?.toString();

            if (tanggal != null && tanggal.isNotEmpty) {
              try {
                debugPrint('Tanggal dari ${doc.id}: $tanggal');
                final date = DateTime.parse(
                  tanggal.split('-').reversed.join('-'),
                );
                if (date.year == tahun) {
                  for (int i = 0; i < labelList.length; i++) {
                    final label = labelList[i];
                    if (nama.contains(label)) {
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
          debugPrint('Label digunakan untuk $userId: $labelList');
          return checklist;
        });
  }

  Future<List<String>> fetchNamaIuranInsidental(int tahun) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collectionGroup('items')
            .where('tipe', isEqualTo: 'Iuran Lainnya')
            .orderBy('status')
            // .where('status', isEqualTo: 'lunas')
            .get();

    final List<String> namaList = [];

    for (var doc in snapshot.docs) {
      final nama = doc['nama']?.toString() ?? '';
      final tanggal = doc['tenggat']?.toString();

      if (tanggal != null && tanggal.isNotEmpty) {
        try {
          final date = DateTime.parse(tanggal.split('-').reversed.join('-'));
          if (date.year == tahun) {
            if (!namaList.contains(nama)) {
              namaList.add(nama);
            }
          }
        } catch (_) {}
      }
    }

    return namaList;
  }

  Future<void> updateHeaderTitles() async {
    debugPrint('updateHeaderTitles() dipanggil dengan: $selectedValue');
    if (selectedValue == 'Iuran Insidental') {
      final namaIuran = await fetchNamaIuranInsidental(selectedDate.year);
      debugPrint('Header insidental: $namaIuran');
      setState(() {
        headerTitles = namaIuran;
      });
    } else {
      setState(() {
        headerTitles = [];
      });
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedValue,
                    items:
                        options.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (newValue) async {
                      setState(() {
                        selectedValue = newValue!;
                        headerTitles = [];
                      });
                      await updateHeaderTitles();
                    },
                  ),
                ),
                SizedBox(width: 10),
                BarTahun(
                  selectedDate: selectedDate,
                  onDateChanged: (newDate) async {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            BlokBar(
              onBlokSelected: (blok) {
                setState(() {
                  selectedBlok = blok;
                });
              },
            ),
            Column(
              children: [
                if (selectedValue == 'Iuran Insidental' && headerTitles.isEmpty)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BulanRekapBar(
                        labels:
                            headerTitles.isEmpty
                                ? [
                                  'Jan',
                                  'Feb',
                                  'Mar',
                                  'Apr',
                                  'Mei',
                                  'Jun',
                                  'Jul',
                                  'Agu',
                                  'Sep',
                                  'Okt',
                                  'Nov',
                                  'Des',
                                ]
                                : headerTitles,
                      ),

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
                                        return StreamBuilder<List<bool>>(
                                          key: ValueKey(
                                            '${userId}_${tahun}_$selectedValue',
                                          ),
                                          stream: getStatusIuranWargaStream(
                                            userId: userId,
                                            tahun: tahun,
                                            tipe: selectedValue!,
                                            customLabels:
                                                selectedValue == 'Iuran Bulanan'
                                                    ? null
                                                    : headerTitles,
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
                                              isInsidental:
                                                  selectedValue ==
                                                  'Iuran Insidental',
                                              judulInsidental: headerTitles,
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
