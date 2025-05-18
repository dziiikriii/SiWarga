import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/edit_tagihan.dart';

class ChecklistTagihanItem extends StatefulWidget {
  final String title;
  final int value;
  final String tagihanId;
  final Map<String, dynamic> tagihanData;
  final String tenggat;
  const ChecklistTagihanItem({
    super.key,
    required this.title,
    required this.value,
    required this.tagihanId,
    required this.tagihanData,
    required this.tenggat,
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

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    DateTime? tenggatDate = DateFormat(
      'dd-MM-yyyy',
    ).parse(widget.tenggat, true);
    String formattedTenggat = DateFormat(
      'dd MMMM yyyy',
      'id_ID',
    ).format(tenggatDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  softWrap: true,
                ),
              ),
              Row(
                children: [
                  Text(
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
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
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
          SizedBox(height: 4),
          Text(
            'Tenggat: $formattedTenggat',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
