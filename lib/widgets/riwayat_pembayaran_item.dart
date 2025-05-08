import 'package:flutter/material.dart';

class RiwayatPembayaranItem extends StatelessWidget {
  const RiwayatPembayaranItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Iuran Januari 2025',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: Color(0xFF777777)),
                  SizedBox(width: 10),
                  Text(
                    '10-01-2025 04:39:26',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.wallet_rounded, color: Color(0xFF777777)),
                  SizedBox(width: 10),
                  Text(
                    'Via Cash',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Color(0xFF777777),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF777777),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Rp 50.000',
            style: TextStyle(
              color: Color(0xFF184E0E),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
