import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/edit_no_rek.dart';

class DaftarNoRekItem extends StatelessWidget {
  final String id;
  final String namaBank;
  final String noRek;
  final String namaPemilik;
  const DaftarNoRekItem({
    super.key,
    required this.id,
    required this.namaBank,
    required this.noRek,
    required this.namaPemilik,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(namaBank), Text(noRek)],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(namaPemilik),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditNoRek(docId: id)),
                      );
                    },
                    child: Icon(Icons.edit_rounded, color: Colors.orange),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      final confirmDelete = await showDialog<bool>(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Konfirmasi Hapus Nomor Rekening'),
                              content: Text(
                                'Apakah Anda yakin ingin menghapus nomor rekening?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(color: Color(0xFF777777)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: Text(
                                    'Hapus',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 42, 42),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                      if (confirmDelete == true) {
                        await FirebaseFirestore.instance
                            .collection('nomor_rekening')
                            .doc(id)
                            .delete();
                      }
                    },
                    child: Icon(Icons.delete_rounded, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(),
        ],
      ),
    );
  }
}
