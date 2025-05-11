import 'package:flutter/material.dart';

class InfoSaldoHome extends StatelessWidget {
  const InfoSaldoHome({super.key});

  @override
  Widget build(BuildContext context) {
    
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
