import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/tambah_no_rek.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/daftar_no_rek_item.dart';

class DaftarNoRek extends StatelessWidget {
  const DaftarNoRek({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Daftar Nomor Rekening'),
      // body: Container(
      //   margin: EdgeInsets.all(20),
      //   padding: EdgeInsets.all(10),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(15)
      //   ),
      //   child: Column(
      //     children: [
      //       DaftarNoRekItem(),
      //       DaftarNoRekItem(),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => TambahNoRek()),
      //     );
      //   },
      //   backgroundColor: Color(0xFF37672F),
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      //   child: Icon(Icons.add, color: Colors.white),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('nomor_rekening').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Belum ada data rekening'));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return DaftarNoRekItem(
                id: item.id,
                namaBank: item['nama_bank'],
                noRek: item['no_rek'],
                namaPemilik: item['nama_pemilik'],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahNoRek()),
          );
        },
        backgroundColor: Color(0xFF37672F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
