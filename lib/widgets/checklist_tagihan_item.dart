import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/edit_tagihan.dart';

class ChecklistTagihanItem extends StatefulWidget {
  final String title;
  final int value;
  final String tagihanId;
  final Map<String, dynamic> tagihanData;
  // final String tenggat;
  const ChecklistTagihanItem({
    super.key,
    required this.title,
    required this.value,
    required this.tagihanId,
    required this.tagihanData,
    // required this.tenggat,
  });

  @override
  State<ChecklistTagihanItem> createState() => _ChecklistTagihanItemState();
}

Future<void> hapusTagihan(String tagihanId) async {
  final firestore = FirebaseFirestore.instance;

  await firestore.collection('tagihan').doc(tagihanId).delete();

  final wargaSnapshot =
      await firestore
          .collection('users')
          .where('role', isEqualTo: 'warga')
          .get();

  for (var doc in wargaSnapshot.docs) {
    await firestore
        .collection('tagihan_user')
        .doc(doc.id)
        .collection('items')
        .doc(tagihanId)
        .delete();
  }
}

class _ChecklistTagihanItemState extends State<ChecklistTagihanItem> {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // late final String formattedTenggat;

  // @override
  // void initState() {
  //   super.initState();
  //   formattedTenggat = _formatTenggat(widget.tenggat);
  // }

  // String _formatTenggat(dynamic tenggat) {
  //   try {
  //     if (tenggat is Timestamp) {
  //       return DateFormat('dd MMM yyyy').format(tenggat.toDate());
  //     } else if (tenggat is String) {
  //       final parsedDate = DateTime.parse(tenggat);
  //       return DateFormat('dd MMM yyyy').format(parsedDate);
  //     } else if (tenggat is DateTime) {
  //       return DateFormat('dd MMM yyyy').format(tenggat);
  //     } else {
  //       return '-';
  //     }
  //   } catch (e) {
  //     return '-';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              softWrap: true,
            ),
          ),
          // SizedBox(width: 20),
          Row(
            children: [
              Text(
                // widget.value.toString(),
                formatter.format(widget.value),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EditTagihan(
                            tagihanId: widget.tagihanId,
                            tagihanData: widget.tagihanData,
                          ),
                    ),
                  );
                },
                child: Icon(Icons.edit_rounded, color: Colors.orange, size: 28),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () async {
                  // await hapusTagihan(widget.tagihanId);
                  final confirmDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Konfirmasi Hapus Tagihan'),
                          content: Text(
                            'Apakah Anda yakin ingin menghapus tagihan?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text(
                                'Batal',
                                style: TextStyle(color: Color(0xFF777777)),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // hapusTagihan(widget.tagihanId);
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
                    await hapusTagihan(widget.tagihanId);
                  }
                },
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
