import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistRekap extends StatefulWidget {
  final bool initialCondition;
  final String namaWarga;
  final String namaBulan;
  final String userId;
  final bool isInsidental;
  final Function(bool newValue) onConfirmedChange;

  const ChecklistRekap({
    super.key,
    required this.initialCondition,
    required this.namaWarga,
    required this.namaBulan,
    required this.userId,
    required this.onConfirmedChange,
    required this.isInsidental,
  });

  @override
  State<ChecklistRekap> createState() => _ChecklistRekapState();
}

class _ChecklistRekapState extends State<ChecklistRekap> {
  late bool condition;
  String? role;

  @override
  void initState() {
    super.initState();
    condition = widget.initialCondition;
  }

  Future<void> fetchUserRole() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          role = doc.data()?['role'];
        });
      }
    }
  }

  Future<void> _toggleConditionWithConfirmation() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("Konfirmasi"),
            content: Text(
              "Apakah Anda yakin ingin mengubah status iuran bulan ${widget.namaBulan} untuk ${widget.namaWarga}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text("Ya"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      setState(() {
        condition = !condition;
      });

      // Panggil callback
      widget.onConfirmedChange(condition);

      // Update ke Firebase
      await _updateFirestore(condition);
    }
  }

  Future<void> _updateFirestore(bool isLunas) async {
    // final tahun = DateTime.now().year;
    // final namaTagihan = "Iuran ${widget.namaBulan}";
    final namaTagihan =
        widget.isInsidental ? widget.namaBulan : "Iuran ${widget.namaBulan}";

    try {
      final userTagihanRef = FirebaseFirestore.instance
          .collection('tagihan_user')
          .doc(widget.userId)
          .collection('items');

      final query =
          await userTagihanRef
              .where('nama', isEqualTo: namaTagihan)
              .limit(1)
              .get();

      final now = DateTime.now();

      if (query.docs.isNotEmpty) {
        final docId = query.docs.first.id;
        await userTagihanRef.doc(docId).update({
          'status': isLunas ? 'lunas' : 'belum bayar',
          'tanggal_bayar': isLunas ? Timestamp.fromDate(now) : null,
          'metode_pembayaran': isLunas ? 'Cash' : null,
        });
      } else {
        // Jika tidak ditemukan, bisa buat log atau tampilkan pesan
        debugPrint('Tagihan tidak ditemukan untuk update: $namaTagihan');
      }
    } catch (e) {
      debugPrint('Gagal update status tagihan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return condition
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: InkWell(
            onTap: role == 'admin' ? _toggleConditionWithConfirmation : null,
            child: Icon(
              Icons.check_circle_rounded,
              color: Color.fromARGB(255, 113, 213, 73),
              size: 30,
            ),
          ),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.6),
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 217, 42, 42),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: role == 'admin' ? _toggleConditionWithConfirmation : null,
              child: Icon(Icons.close_rounded, color: Colors.white, size: 25),
            ),
          ),
        );
  }
}
