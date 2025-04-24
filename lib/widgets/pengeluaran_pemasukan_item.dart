import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PengeluaranPemasukanItem extends StatelessWidget {
  final String name;
  final int value;
  final FontWeight? fontWeight;
  final Color? color;
  const PengeluaranPemasukanItem({
    super.key,
    required this.name,
    required this.value,
    this.fontWeight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final formatRupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontWeight: fontWeight, color: color)),
          Text(
            formatRupiah.format(value),
            style: TextStyle(fontWeight: fontWeight, color: color),
          ),
        ],
      ),
    );
  }
}
