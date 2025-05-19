import 'package:flutter/material.dart';
import 'package:si_warga/widgets/checklist_rekap.dart';
import 'package:si_warga/widgets/logo_warga.dart';

class RekapPerWarga extends StatelessWidget {
  final List<bool> kondisiChecklist;
  final String kodeWarga; // Misalnya: "Adi-08" → ambil namaWarga: Adi
  final String namaWarga;
  final String userId;

  const RekapPerWarga({
    super.key,
    required this.kondisiChecklist,
    required this.kodeWarga,
    required this.namaWarga, required this.userId,
  });

  final List<String> bulanList = const [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: LogoWarga(kode: kodeWarga),
          ),
          ...List.generate(12, (index) {
            return ChecklistRekap(
              initialCondition: kondisiChecklist[index],
              namaWarga: namaWarga,
              namaBulan: bulanList[index],
              userId: userId,
              onConfirmedChange: (newValue) {
                // Tambahkan log atau update ke database jika perlu
                debugPrint(
                  'Checklist bulan ${bulanList[index]} untuk $namaWarga diubah ke: $newValue',
                );
              },
            );
          }),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
