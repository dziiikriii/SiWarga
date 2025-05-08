import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/edit_tagihan.dart';

class ChecklistTagihanItem extends StatefulWidget {
  final String title;
  final int value;
  final String tagihanId;
  final Map<String, dynamic> tagihanData;
  const ChecklistTagihanItem({
    super.key,
    required this.title,
    required this.value,
    required this.tagihanId, required this.tagihanData,
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Row(
            children: [
              Text(
                widget.value.toString(),
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
                  await hapusTagihan(widget.tagihanId);
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
