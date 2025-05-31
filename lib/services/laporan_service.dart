import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanService {
  static Future<void> updateLaporanKeuanganOtomatis(DateTime tanggal) async {
    final bulanTeks = DateFormat('MMMM').format(tanggal);
    final tahun = tanggal.year.toString();
    final laporanId = '$tahun-$bulanTeks';

    // 1. Dapatkan tanggal terakhir bulan ini
    final lastDayOfMonth = DateTime(tanggal.year, tanggal.month + 1, 0);
    final formattedLastDay = DateFormat('dd-MM-yyyy').format(lastDayOfMonth);

    int total = 0;

    // 2. Dapatkan semua user
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // 3. Untuk setiap user, cek tagihan
    for (final userDoc in usersSnapshot.docs) {
      final uid = userDoc.id;
      final tagihanSnapshot =
          await FirebaseFirestore.instance
              .collection('tagihan_user')
              .doc(uid)
              .collection('items')
              .where('status', isEqualTo: 'lunas')
              .where(
                'tenggat',
                isEqualTo: formattedLastDay,
              ) // Format: dd-MM-yyyy
              .get();

      // 4. Hitung total
      total += tagihanSnapshot.docs.fold(0, (sum, doc) {
        final data = doc.data();
        final jumlah = data['jumlah'] ?? 0;
        return sum + (jumlah is int ? jumlah : (jumlah as num).toInt());
      });
    }

    print('Total iuran warga bulan $bulanTeks $tahun: $total');

    // 5. Update dokumen laporan keuangan
    final laporanRef = FirebaseFirestore.instance
        .collection('laporan_keuangan')
        .doc(laporanId);

    await laporanRef.set({
      'total': total,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
