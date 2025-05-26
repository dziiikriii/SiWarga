import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/generate_tagihan_bulanan.dart';
import 'package:si_warga/pages/konfirmasi_pembayaran_warga.dart';
import 'package:si_warga/pages/tambah_tagihan.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/bar_tahun.dart';
import 'package:si_warga/widgets/checklist_tagihan_item.dart';
import 'package:si_warga/widgets/lunas_bar.dart';

class AdminTagihanWarga extends StatefulWidget {
  const AdminTagihanWarga({super.key});

  @override
  State<AdminTagihanWarga> createState() => _AdminTagihanWargaState();
}

class _AdminTagihanWargaState extends State<AdminTagihanWarga> {
  int selectedIndex = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // final startOfYear = DateTime(selectedDate.year, 1, 1);
    // final endOfYear = DateTime(selectedDate.year + 1, 1, 1);
    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            // YearBar(),
            LunasBar(
              leftText: 'Iuran Bulanan',
              rightText: ('Iuran Lainnya'),
              onTabChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            SizedBox(height: 20),
            BarTahun(
              selectedDate: selectedDate,
              onDateChanged: (newDate) {
                setState(() {
                  selectedDate = newDate;
                });
              },
            ),
            // SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 40,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('tagihan')
                            .where(
                              'tipe',
                              isEqualTo:
                                  selectedIndex == 0
                                      ? 'Iuran Bulanan'
                                      : 'Iuran Lainnya',
                            )
                            // .where(
                            //   'tenggat',
                            //   isGreaterThanOrEqualTo: startOfYear,
                            // )
                            // .where('tenggat', isLessThan: endOfYear)
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      final tagihanList = snapshot.data!.docs;

                      final filteredDocs =
                          tagihanList.where((doc) {
                            final tenggatStr = doc['tenggat'];
                            try {
                              final tenggatDate = DateFormat(
                                'dd-MM-yyyy',
                              ).parse(tenggatStr);
                              return tenggatDate.year == selectedDate.year;
                            } catch (e) {
                              return false;
                            }
                          }).toList();

                      return ListView.builder(
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, index) {
                          final data = filteredDocs[index];
                          return ChecklistTagihanItem(
                            title: data['nama'],
                            value: data['jumlah'] ?? 0,
                            tenggat: data['tenggat'],
                            tagihanId: data.id,
                            tagihanData: data.data() as Map<String, dynamic>,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PopupMenuButton<int>(
        onSelected: (value) {
          if (value == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TambahTagihan()),
            );
          } else if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => GenerateTagihanBulanan()),
            );
          } else if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => KonfirmasiPembayaranWarga()),
            );
          }
        },
        itemBuilder:
            (context) => [
              PopupMenuItem(value: 1, child: Text('Tambah Tagihan')),
              PopupMenuItem(value: 2, child: Text('Generate Tagihan')),
              PopupMenuItem(
                value: 3,
                child: Text('Konfirmasi Pembayaran Warga'),
              ),
            ],
        offset: Offset(0, -105), // posisikan di atas FAB
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        icon: FloatingActionButton(
          onPressed: null, // disable klik langsung
          backgroundColor: Color(0xFF37672F),
          child: Icon(Icons.more_vert, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
