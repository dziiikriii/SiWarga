import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/pages/kelola_warga.dart';
import 'package:si_warga/pages/notifikasi.dart';
import 'package:si_warga/services/notification_service.dart';
import 'package:si_warga/widgets/grafik_keuangan.dart';
import 'package:si_warga/widgets/halo_user.dart';
import 'package:si_warga/widgets/info_saldo_home.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Set<String> notifiedPembayaranIds = {};

  @override
  void initState() {
    super.initState();
    // _listenPembayaranBaru();
    // NotificationService.initialize();
    _cekDanPasangListener();
    // saveAdminToken();
  }

  // Future<void> saveAdminToken() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     final fcmToken = await FirebaseMessaging.instance.getToken();
  //     if (fcmToken != null) {
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .update({'fcmToken': fcmToken});
  //     }
  //   }
  // }

  void _listenSemuaPembayaran() {
    FirebaseFirestore.instance.collection('tagihan_user').get().then((
      userDocs,
    ) {
      for (var userDoc in userDocs.docs) {
        FirebaseFirestore.instance
            .collection('tagihan_user')
            .doc(userDoc.id)
            .collection('items')
            .where('status', isEqualTo: 'menunggu_konfirmasi')
            .snapshots()
            .listen((snapshot) {
              for (var change in snapshot.docChanges) {
                final docId = change.doc.id;
                final data = change.doc.data();

                // Pastikan notifikasi hanya untuk yang belum pernah diberi notif
                if ((change.type == DocumentChangeType.added ||
                        change.type == DocumentChangeType.modified) &&
                    !notifiedPembayaranIds.contains(docId)) {
                  final metode = data?['metode_pembayaran'] ?? '';
                  final uid = userDoc.id;

                  NotificationService.showNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                    title: 'Pembayaran Masuk',
                    body:
                        'Pembayaran baru oleh $uid dengan metode $metode perlu dikonfirmasi.',
                  );

                  notifiedPembayaranIds.add(docId); // tandai sudah diberi notif
                }
              }
            });
      }
    });
  }

  void _cekDanPasangListener() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = userDoc.data()?['role'];

    if (role == 'admin') {
      _listenSemuaPembayaran();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  colors: [Color.fromARGB(195, 24, 78, 14), Color(0xFFECFCEC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'lib/assets/logo_only.png',
                                width: 70,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'SIWARGA',
                                style: TextStyle(
                                  fontFamily: 'THICCCBOI',
                                  color: Color(0xFF184E0E),
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Notifikasi(),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.notifications_none,
                              size: 35,
                              color: Color(0xFF184E0E),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      HaloUser(),
                      SizedBox(height: 6),
                      Text(
                        'Perumahan Bukit Hijau Permata Hijau',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KelolaWarga(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF184E0E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Kelola Warga',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_rounded, size: 25),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      InfoSaldoHome(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            GrafikKeuangan(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
