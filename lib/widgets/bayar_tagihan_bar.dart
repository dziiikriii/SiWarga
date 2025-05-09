import 'package:flutter/material.dart';

class BayarTagihanBar extends StatelessWidget {
  final int total;
  final int jumlahDipilih;
  final VoidCallback onBayar;
  final VoidCallback? onCheckAll;
  final bool isAllChecked;
  final ValueChanged<bool?>? onAllCheckedChanged;

  const BayarTagihanBar({
    super.key,
    required this.total,
    required this.jumlahDipilih,
    required this.onBayar,
    this.onCheckAll,
    required this.isAllChecked,
    required this.onAllCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
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
              children: [
                const Text(
                  'Total :',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Rp $total',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: jumlahDipilih > 0 ? onBayar : null,
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
