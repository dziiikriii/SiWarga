import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GrafikKeuangan extends StatefulWidget {
  const GrafikKeuangan({super.key});

  @override
  State<GrafikKeuangan> createState() => _GrafikKeuanganState();
}

class _GrafikKeuanganState extends State<GrafikKeuangan> {
  List<BarChartGroupData> barData = [];
  List<String> monthLabels = [];
  double maxY = 10;

  @override
  void initState() {
    super.initState();
    fetchKeuanganData();
  }

  String _formatNumberIndonesia(int number) {
    // Format angka dengan pemisah ribuan titik
    final str = number.toString();
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return str.replaceAllMapped(reg, (match) => '.');
  }

  double findMaxY() {
    double maxY = 0;
    for (var group in barData) {
      for (var rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    return maxY;
  }

  double calculateInterval(double maxY) {
    // Kita target maksimal 10 label
    double interval = maxY / 10;

    // Bulatkan interval ke angka "enak", misal kelipatan 1, 2, 5, 10, 50, 100, dll
    final List<double> steps = [1, 2, 5];
    double magnitude =
        pow(10, interval.floor().toString().length - 1).toDouble();

    for (var step in steps) {
      double tempInterval = step * magnitude;
      if (interval <= tempInterval) {
        return tempInterval;
      }
    }
    return interval;
  }

  Future<void> fetchKeuanganData() async {
    final firestore = FirebaseFirestore.instance;
    final laporanSnapshot =
        await firestore.collection('laporan_keuangan').get();

    final monthMap = {
      'january': 1,
      'february': 2,
      'march': 3,
      'april': 4,
      'may': 5,
      'june': 6,
      'july': 7,
      'august': 8,
      'september': 9,
      'october': 10,
      'november': 11,
      'december': 12,
    };

    final List<Map<String, dynamic>> dataList = [];

    for (var doc in laporanSnapshot.docs) {
      final id = doc.id.toLowerCase(); // contoh: 2025-may
      final parts = id.split('-');
      if (parts.length != 2) continue;

      final monthName = parts[1];
      final urutanBulan = monthMap[monthName] ?? 0;

      // Ambil referensi dokumen bulan
      final docRef = firestore.collection('laporan_keuangan').doc(doc.id);

      // Ambil total pemasukan
      final pemasukanSnapshot = await docRef.collection('pemasukan').get();
      double totalPemasukan = pemasukanSnapshot.docs.fold(
        0.0,
        (sum, d) => sum + (d.data()['jumlah'] ?? 0).toDouble(),
      );

      // Ambil total pengeluaran
      final pengeluaranSnapshot = await docRef.collection('pengeluaran').get();
      double totalPengeluaran = pengeluaranSnapshot.docs.fold(
        0.0,
        (sum, d) => sum + (d.data()['jumlah'] ?? 0).toDouble(),
      );

      debugPrint(
        'Bulan: $monthName, Pemasukan: $totalPemasukan, Pengeluaran: $totalPengeluaran',
      );

      dataList.add({
        'bulan': monthName[0].toUpperCase() + monthName.substring(1),
        'urutan': urutanBulan,
        'pemasukan': totalPemasukan,
        'pengeluaran': totalPengeluaran,
      });
    }

    // Urutkan berdasarkan bulan
    dataList.sort((a, b) => a['urutan'].compareTo(b['urutan']));

    // Isi bar chart data
    List<BarChartGroupData> newBarData = [];
    List<String> newMonthLabels = [];

    for (int i = 0; i < dataList.length; i++) {
      final data = dataList[i];

      newMonthLabels.add(data['bulan'].substring(0, 3)); // e.g. May -> "May"

      newBarData.add(
        BarChartGroupData(
          x: i,
          barsSpace: 6,
          barRods: [
            BarChartRodData(
              toY: data['pemasukan'],
              color: Colors.green,
              width: 6,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: data['pengeluaran'],
              color: Colors.red,
              width: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    // Hitung maxY dan beri padding
    double tempMaxY = 0;
    for (var data in dataList) {
      double pemasukan = data['pemasukan'] as double;
      double pengeluaran = data['pengeluaran'] as double;
      double currentMax = pemasukan > pengeluaran ? pemasukan : pengeluaran;
      if (currentMax > tempMaxY) tempMaxY = currentMax;
    }
    tempMaxY *= 1.2;
    if (tempMaxY == 0) tempMaxY = 10;

    setState(() {
      barData = newBarData;
      monthLabels = newMonthLabels;
      maxY = tempMaxY;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (barData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    double maxY = findMaxY();
    double interval = calculateInterval(maxY);

    double barGroupWidth = 60;
    double chartWidth = barData.length * barGroupWidth;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
      child: SizedBox(
        height: 320,
        width: chartWidth,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            child: BarChart(
              BarChartData(
                maxY: interval * 6,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < monthLabels.length) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              monthLabels[index],
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 70,
                      interval: interval,
                      getTitlesWidget: (value, meta) {
                        String formatted = _formatNumberIndonesia(
                          value.toInt(),
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            formatted,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Tambahkan topTitles dengan reservedSize
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20, // <-- Ini memberi ruang di atas
                      getTitlesWidget: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                // Tambahkan margin atas
                // alignmentChartInside: false, // Ini sangat penting
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                groupsSpace: 20,
                barGroups: barData,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade200,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? 'Pemasukan' : 'Pengeluaran';
                      return BarTooltipItem(
                        '$label: ${rod.toY.toStringAsFixed(0)}',
                        const TextStyle(fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
