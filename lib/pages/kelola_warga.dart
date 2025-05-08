import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/kelola_warga_item.dart';

class KelolaWarga extends StatefulWidget {
  const KelolaWarga({super.key});

  @override
  State<KelolaWarga> createState() => _KelolaWargaState();
}

class _KelolaWargaState extends State<KelolaWarga> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Kelola Warga'),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _firestore
                .collection('users')
                .where('role', isNull: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada pendaftaran baru'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final data = users[index];
              return KelolaWargaItem(
                nama: data['name'] ?? '',
                email: data['email'] ?? '',
                uid: data.id,
              );
            },
          );
        },
      ),
    );
  }
}
