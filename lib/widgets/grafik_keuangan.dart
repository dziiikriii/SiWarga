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

  @override
  void initState() {
    super.initState();
    fetchKeuanganData();
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

    final dataList =
        laporanSnapshot.docs
            .map((doc) {
              final id = doc.id.toLowerCase(); // contoh: 2025-march
              final parts = id.split('-');
              if (parts.length != 2) return null;

              final month = parts[1];
              final urutanBulan = monthMap[month] ?? 0;

              final saldoAwal = (doc.data()['saldoAwal'] ?? 0).toDouble();
              final saldoAkhir = (doc.data()['saldoAkhir'] ?? 0).toDouble();

              double pemasukan = 0;
              double pengeluaran = 0;

              if (saldoAkhir > saldoAwal) {
                pemasukan = saldoAkhir - saldoAwal;
              } else if (saldoAkhir < saldoAwal) {
                pengeluaran = saldoAwal - saldoAkhir;
              }

              return {
                'bulan': month[0].toUpperCase() + month.substring(1),
                'urutan': urutanBulan,
                'pemasukan': pemasukan,
                'pengeluaran': pengeluaran,
              };
            })
            .whereType<Map<String, dynamic>>()
            .toList();

    dataList.sort((a, b) => a['urutan'].compareTo(b['urutan']));

    barData =
        dataList.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;

          monthLabels.add(data['bulan'].substring(0, 3)); // contoh: Jan

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data['pemasukan'],
                color: Colors.green,
                width: 8,
              ),
              BarChartRodData(
                toY: data['pengeluaran'],
                color: Colors.red,
                width: 8,
              ),
            ],
          );
        }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (barData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    return Text(
                      index >= 0 && index < monthLabels.length
                          ? monthLabels[index]
                          : '',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: barData,
            gridData: FlGridData(show: true),
            borderData: FlBorderData(show: false),
            groupsSpace: 15,
            barTouchData: BarTouchData(enabled: true),
          ),
        ),
      ),
    );
  }
}
