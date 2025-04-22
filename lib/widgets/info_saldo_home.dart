import 'package:flutter/material.dart';

class InfoSaldoHome extends StatelessWidget {
  const InfoSaldoHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = screenWidth * 0.9;

    return Container(
      width: boxWidth,
      decoration: BoxDecoration(
        color: Color(0xFFECFCEC),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20), // Warna shadow
            offset: Offset(4, 4), // Posisi shadow (horizontal, vertical)
            blurRadius: 8, // Seberapa buram shadow
            spreadRadius: 1, // Seberapa besar shadow menyebar
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
                  'Rp 25.000.000',
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
                      '30',
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
