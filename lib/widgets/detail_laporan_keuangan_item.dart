import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/edit_laporan_keuangan.dart';

class DetailLaporanKeuanganItem extends StatelessWidget {
  final String docId;
  final String tipe;
  final String nama;
  final int jumlah;
  final DateTime tanggal;
  final String keterangan;
  const DetailLaporanKeuanganItem({
    super.key,
    required this.nama,
    required this.jumlah,
    required this.tanggal,
    required this.keterangan,
    required this.docId,
    required this.tipe,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);
    final formattedJumlah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(jumlah);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                nama,
                style: TextStyle(
                  color: Color(0xFF184E0E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              children: [
                InkWell(
                  child: Icon(Icons.edit_rounded, color: Colors.orange),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => EditLaporanKeuangan(
                              docId: docId,
                              nama: nama,
                              jumlah: jumlah,
                              keterangan: keterangan,
                              tanggal: tanggal,
                              tipe: tipe,
                            ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: Text('Konfirmasi'),
                            content: Text(
                              'Apakah Anda yakin ingin menghapus data ini?',
                            ),
                            actions: [
                              TextButton(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Hapus Data',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                              ),
                            ],
                          ),
                    );

                    if (confirm == true) {
                      debugPrint('Tanggal item: $tanggal');
                      final bulan = DateFormat(
                        'yyyy-MMMM',
                        'en_US',
                      ).format(tanggal);
                      await FirebaseFirestore.instance
                          .collection('laporan_keuangan')
                          .doc(bulan)
                          .collection(tipe)
                          .doc(docId)
                          .delete();
                      debugPrint(
                        'Delete path: laporan_keuangan/$bulan/$tipe/$docId',
                      );

                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Data berhasil dihapus'),
                          backgroundColor: Color(0xFF184E0E),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: Color.fromARGB(255, 255, 42, 42),
                  ),
                ),
                SizedBox(width: 9),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Tanggal'), Text(formattedDate)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Jumlah'), Text(formattedJumlah)],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Keterangan'), Text(keterangan)],
          ),
        ),
        Divider(),
      ],
    );
  }
}
