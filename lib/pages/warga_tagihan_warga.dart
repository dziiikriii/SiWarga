import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/bayar_tagihan_bar.dart';
// import 'package:si_warga/widgets/checklist_tagihan_item.dart';
import 'package:si_warga/widgets/lunas_bar.dart';
import 'package:si_warga/widgets/year_bar.dart';

class WargaTagihanWarga extends StatefulWidget {
  const WargaTagihanWarga({super.key});

  @override
  State<WargaTagihanWarga> createState() => _WargaTagihanWargaState();
}

class _WargaTagihanWargaState extends State<WargaTagihanWarga> {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;
    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              YearBar(),
              LunasBar(leftText: 'Iuran Bulanan', rightText: ('Iuran Lainnya')),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    right: 20,
                  ),
                  // child: ListView(children: [ ChecklistTagihanItem()]),
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance
                            .collection('tagihan_user')
                            .doc(currentUserId)
                            .collection('items')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Text('Belum ada tagihan.');
                      }

                      final tagihanList = snapshot.data!.docs;

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tagihanList.length,
                        itemBuilder: (context, index) {
                          final tagihan = tagihanList[index];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            title: Text(tagihan['nama'] ?? 'Tanpa Nama'),
                            subtitle: Text(
                              'Jumlah: Rp${tagihan['jumlah']} \nTenggat: ${tagihan['tenggat']}',
                            ),
                            trailing: Text(
                              tagihan['status'],
                              style: TextStyle(
                                color:
                                    tagihan['status'] == 'belum bayar'
                                        ? Colors.red
                                        : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: BayarTagihanBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
