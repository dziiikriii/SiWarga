import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/tambah_tagihan.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/checklist_tagihan_item.dart';
import 'package:si_warga/widgets/lunas_bar.dart';
import 'package:si_warga/widgets/year_bar.dart';

class AdminTagihanWarga extends StatefulWidget {
  const AdminTagihanWarga({super.key});

  @override
  State<AdminTagihanWarga> createState() => _AdminTagihanWargaState();
}

class _AdminTagihanWargaState extends State<AdminTagihanWarga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            YearBar(),
            LunasBar(leftText: 'Iuran Bulanan', rightText: ('Iuran Lainnya')),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('tagihan')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return CircularProgressIndicator();
                      final tagihanList = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: tagihanList.length,
                        itemBuilder: (context, index) {
                          final data = tagihanList[index];
                          return ChecklistTagihanItem(
                            title: data['nama'],
                            value: data['jumlah'],
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

            // FullWidthButton(
            //   text: 'Edit Tagihan',
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const LoginPage()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // aksi saat ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahTagihan()),
          );
        },
        backgroundColor: Color(0xFF37672F),

        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
