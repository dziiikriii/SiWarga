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

  String capitalizeEachWord(String text) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  Future<void> fetchNamaUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final docSnapshot =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (docSnapshot.exists) {
          setState(() {
            namaUser =
                (docSnapshot.data()?['name'] ?? 'Admin').split(' ').first;
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
      'Halo, ${capitalizeEachWord(namaUser)}!',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF184E0E),
        fontSize: 35,
      ),
    );
  }
}
