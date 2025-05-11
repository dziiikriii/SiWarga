import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/pages/metode_pembayaran.dart';

class BayarTagihanBar extends StatelessWidget {
  final int total;
  final int jumlahDipilih;
  final VoidCallback onBayar;
  final VoidCallback? onCheckAll;
  final bool isAllChecked;
  final ValueChanged<bool?>? onAllCheckedChanged;
  final List<QueryDocumentSnapshot> selectedTagihan;

  const BayarTagihanBar({
    super.key,
    required this.total,
    required this.jumlahDipilih,
    required this.onBayar,
    this.onCheckAll,
    required this.isAllChecked,
    required this.onAllCheckedChanged,
    required this.selectedTagihan,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(value: isAllChecked, onChanged: onAllCheckedChanged),
            const SizedBox(width: 8),
            const Text(
              'Bayar Semua',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total :',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  formatter.format(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () async {
                if (jumlahDipilih > 0) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => MetodePembayaran(
                            selectedTagihan:
                                selectedTagihan, // ganti sesuai variabel aslinya
                          ),
                    ),
                  );

                  // Jika halaman pembayaran mengembalikan 'success', lakukan refresh
                  if (result == 'success') {
                    onBayar(); // fungsi ini nanti akan memanggil ulang _fetchTagihan
                  }
                }
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Bayar ($jumlahDipilih)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
