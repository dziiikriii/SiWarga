import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/blok_bar.dart';
import 'package:si_warga/widgets/bulan_rekap_bar.dart';
import 'package:si_warga/widgets/rekap_per_warga.dart';
import 'package:si_warga/widgets/year_bar.dart';

class AdminRekapIuran extends StatelessWidget {
  const AdminRekapIuran({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Rekap Iuran Warga'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YearBar(),
            SizedBox(height: 10),
            BlokBar(),
            SizedBox(height: 10),
            Expanded(
              // 👈 agar bagian bawah bisa scroll
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // 👉 scroll kanan-kiri
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BulanRekapBar(),
                      // const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection:
                              Axis.vertical, // 👉 scroll atas-bawah
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                RekapPerWarga(
                                  kodeWarga: 'A-1',
                                  kondisiChecklist: [
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-2',
                                  kondisiChecklist: [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-3',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-4',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-5',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-6',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-7',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-8',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-9',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                                RekapPerWarga(
                                  kodeWarga: 'A-10',
                                  kondisiChecklist: [
                                    false,
                                    true,
                                    false,
                                    true,
                                    true,
                                    true,
                                    true,
                                    false,
                                    false,
                                    true,
                                    false,
                                    false,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
