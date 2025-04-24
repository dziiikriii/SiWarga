import 'package:flutter/material.dart';
import 'package:si_warga/widgets/checklist_rekap.dart';
import 'package:si_warga/widgets/logo_warga.dart';

class RekapPerWarga extends StatelessWidget {
  final List<bool> kondisiChecklist;
  final String kodeWarga;

  const RekapPerWarga({
    super.key,
    required this.kondisiChecklist,
    required this.kodeWarga,
  });

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
          ...kondisiChecklist.map(
            (condition) => ChecklistRekap(condition: condition),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
