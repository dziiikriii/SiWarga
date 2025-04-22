import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/riwayat_pembayaran_item.dart';

class RiwayatPembayaranWarga extends StatelessWidget {
  const RiwayatPembayaranWarga({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Riwayat Pembayaran'),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white ,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RiwayatPembayaranItem(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
