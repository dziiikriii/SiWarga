import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatPembayaranItem extends StatelessWidget {
  final String nama;
  final String tanggal;
  final String metode;
  final int jumlah;
  final String status;

  const RiwayatPembayaranItem({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.metode,
    required this.jumlah,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final statusColor = status == 'lunas' ? Colors.green : Colors.orange;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  softWrap: true,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF777777),
                    ),
                    SizedBox(width: 10),
                    Text(
                      tanggal,
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
                      metode,
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
                      status,
                      style: TextStyle(
                        fontSize: 16,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            formatter.format(jumlah),
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
