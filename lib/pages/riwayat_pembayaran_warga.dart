import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/riwayat_pembayaran_item.dart';

class RiwayatPembayaranWarga extends StatefulWidget {
  const RiwayatPembayaranWarga({super.key});

  @override
  State<RiwayatPembayaranWarga> createState() => _RiwayatPembayaranWargaState();
}

class _RiwayatPembayaranWargaState extends State<RiwayatPembayaranWarga> {
  List<QueryDocumentSnapshot> _lunasList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot =
        await FirebaseFirestore.instance
            .collection('tagihan_user')
            .doc(user!.uid)
            .collection('items')
            .where('status', isEqualTo: 'lunas')
            // .orderBy('createdAt', descending: true)
            .get();

    setState(() {
      _lunasList = snapshot.docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Riwayat Pembayaran'),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children:
                              _lunasList.map((doc) {
                                return RiwayatPembayaranItem(
                                  nama: doc['nama'] ?? 'Tanpa Nama',
                                  tanggal: doc['tenggat'] ?? '-',
                                  // metode: doc['metode'] ?? 'Tidak diketahui',
                                  metode: 'Tidak diketahui',
                                  jumlah: (doc['jumlah'] as num).toInt(),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
