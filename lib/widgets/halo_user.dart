import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HaloUser extends StatefulWidget {
  const HaloUser({super.key});

  @override
  State<HaloUser> createState() => _HaloUserState();
}

class _HaloUserState extends State<HaloUser> {
  String namaUser = '';

  @override
  void initState() {
    super.initState();
    fetchNamaUser();
  }

  Future<void> fetchNamaUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final docSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (docSnapshot.exists) {
          setState(() {
            namaUser = docSnapshot.data()?['name'] ?? 'Admin';
          });
        }
      }
    } catch (e) {
      debugPrint('Error mengambil nama user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Halo, $namaUser!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF184E0E),
        fontSize: 35,
      ),
    );
  }
}
