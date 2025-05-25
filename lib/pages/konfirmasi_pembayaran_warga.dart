import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';

class KonfirmasiPembayaranWarga extends StatefulWidget {
  const KonfirmasiPembayaranWarga({super.key});

  @override
  State<KonfirmasiPembayaranWarga> createState() =>
      _KonfirmasiPembayaranWargaState();
}

class _KonfirmasiPembayaranWargaState extends State<KonfirmasiPembayaranWarga> {
  List<DocumentSnapshot> pendingTagihan = [];

  @override
  void initState() {
    super.initState();
    fetchPendingTagihan();
  }

  Future<void> fetchPendingTagihan() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collectionGroup('items')
            .where('status', isEqualTo: 'menunggu_konfirmasi')
            .get();

    setState(() {
      pendingTagihan = snapshot.docs;
    });
  }

  void showBuktiPopup(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: Image.network(imageUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Konfirmasi Pembayaran Warga'),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: pendingTagihan.length,
        itemBuilder: (context, index) {
          final tagihan = pendingTagihan[index];
          final data = tagihan.data() as Map<String, dynamic>;
          final pathSegments = tagihan.reference.path.split('/');
          final userId = pathSegments.length >= 2 ? pathSegments[1] : null;

          if (userId == null) {
            return Text('Gagal mengambil user ID');
          }

          final tanggalBayar = (data['tanggal_bayar'] as Timestamp?)?.toDate();
          final buktiUrl = data['bukti_url'] ?? '';
          final namaTagihan = data['nama'] ?? 'Tidak ada nama';

          // debugPrint('Reference path: ${tagihan.reference.path}');

          return FutureBuilder<DocumentSnapshot>(
            future:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
            builder: (context, snapshot) {
              // debugPrint('Future Builder rebuilding for $userId');
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data?.data() == null) {
                return Text('Gagal memuat data pengguna');
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final namaWarga =
                  userData['name']?.toString() ?? 'Tidak ada nama';
              // final alamat = userData['address']?.toString() ?? '-';
              final blok = userData['blok']?.toString() ?? '-';
              final noRumah = userData['no_rumah']?.toString() ?? '-';
              final metodePembayaran =
                  data['metode_pembayaran']?.toString() ?? '-';

              // debugPrint('Nama warga: $namaWarga | Alamat: $alamat');

              debugPrint('User data: ${snapshot.data!.data()}');
              // debugPrint('Nama warga: $namaWarga, Alamat: $alamat');

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaTagihan,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        // color: Color(0xFF184E0E),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person_2_rounded, color: Color(0xFF777777)),
                        SizedBox(width: 10),
                        Text(namaWarga, style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.home, color: Color(0xFF777777)),
                        SizedBox(width: 10),
                        Text(
                          'Blok $blok No. $noRumah',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.wallet_rounded, color: Color(0xFF777777)),
                        SizedBox(width: 10),
                        Text(metodePembayaran, style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (tanggalBayar != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF777777),
                          ),
                          SizedBox(width: 10),
                          Text(
                            DateFormat('dd MMMM yyyy').format(tanggalBayar),
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        // Tombol Tolak
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Color(0xFFFF0000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await tagihan.reference.update({
                                  'status': 'belum bayar',
                                });
                                fetchPendingTagihan();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Berhasil menolak tagihan'),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Tolak',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Tombol Bukti
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Color(0xFFF4E324),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (buktiUrl.isNotEmpty) {
                                  showBuktiPopup(buktiUrl);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Tidak ada bukti pembayaran',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Bukti',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        // Tombol Setujui
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Color(0xFF184E0E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await tagihan.reference.update({
                                  'status': 'lunas',
                                });
                                fetchPendingTagihan();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Berhasil menyetujui tagihan',
                                    ),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Setujui',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
