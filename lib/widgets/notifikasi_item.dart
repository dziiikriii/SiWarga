import 'package:flutter/material.dart';

class NotifikasiItem extends StatelessWidget {
  const NotifikasiItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tenggat Tagihan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('20 Mei 2025'),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Segera bayar tagihan Iuran Bulan Mei sebesar Rp 100.000 sebelum 31 Mei 2025.',
          ),
        ],
      ),
    );
  }
}
