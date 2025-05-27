import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoSaldoHome extends StatefulWidget {
  const InfoSaldoHome({super.key});

  @override
  State<InfoSaldoHome> createState() => _InfoSaldoHomeState();
}

class _InfoSaldoHomeState extends State<InfoSaldoHome> {
  int saldoKas = 0;
  int jumlahHunian = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // panggil saat widget pertama kali dibangun
  }

  Future<void> fetchData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final currentYear = DateTime.now().year.toString();

      final laporanSnapshot =
          await firestore.collection('laporan_keuangan').get();

      String? latestDocId;
      int latestMonth = 0;
      int saldo = 0;

      for (var doc in laporanSnapshot.docs) {
        final docId = doc.id;
        final parts = docId.split('-');
        if (parts.length == 2 && parts[0] == currentYear) {
          final monthName = parts[1];
          final monthNumber = _convertMonthNameToNumber(
            monthName.toLowerCase(),
          );

          if (monthNumber > latestMonth) {
            latestMonth = monthNumber;
            latestDocId = docId;
          }
        }
      }

      if (latestDocId != null) {
        final latestDoc =
            await firestore
                .collection('laporan_keuangan')
                .doc(latestDocId)
                .get();
        saldo = latestDoc.data()?['saldoAkhir'] ?? 0;
        debugPrint('Mengambil dokumen: $latestDocId');
        debugPrint('Isi data: ${latestDoc.data()}');
      }

      final userSnapshot =
          await firestore
              .collection('users')
              .where('role', isEqualTo: 'warga')
              .get();

      // jumlahHunian = userSnapshot.docs.length;
      // saldoKas = saldo;

      setState(() {
        jumlahHunian = userSnapshot.docs.length;
        saldoKas = saldo;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal mengambil data: $e');
    }
  }

  int _convertMonthNameToNumber(String month) {
    switch (month.toLowerCase()) {
      case 'january':
        return 1;
      case 'february':
        return 2;
      case 'march':
        return 3;
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'june':
        return 6;
      case 'july':
        return 7;
      case 'august':
        return 8;
      case 'september':
        return 9;
      case 'october':
        return 10;
      case 'november':
        return 11;
      case 'december':
        return 12;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFECFCEC),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            offset: Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom Kiri
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_balance_wallet),
                    SizedBox(width: 10),
                    Text(
                      'Saldo Kas RT',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Rp ${saldoKas.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF184E0E),
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            // Divider + Kolom Kanan
            Row(
              children: [
                // Divider
                Container(width: 1, height: 60, color: Color(0xFF777777)),
                SizedBox(width: 20),

                // Kolom Kanan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(width: 10),
                        Text(
                          'Hunian',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$jumlahHunian',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF184E0E),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
