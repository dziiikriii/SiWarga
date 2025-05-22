import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/blok_bar_item.dart';

class BlokBar extends StatefulWidget {
  final ValueChanged<String>? onBlokSelected;

  const BlokBar({super.key, this.onBlokSelected});

  @override
  State<BlokBar> createState() => _BlokBarState();
}

class _BlokBarState extends State<BlokBar> {
  int selectedIndex = 0;

  List<Map<String, String>> blokList = [
    {'label': 'Blok A', 'value': 'A', 'warga': ''},
    {'label': 'Blok B', 'value': 'B', 'warga': ''},
    {'label': 'Blok C', 'value': 'C', 'warga': ''},
    {'label': 'Blok D', 'value': 'D', 'warga': ''},
    {'label': 'Blok E', 'value': 'E', 'warga': ''},
    {'label': 'Blok F', 'value': 'F', 'warga': ''},
  ];

  @override
  void initState() {
    super.initState();
    fetchJumlahWargaPerBlok();
  }

  void fetchJumlahWargaPerBlok() async {
    for (int i = 0; i < blokList.length; i++) {
      String blokValue = blokList[i]['value'] ?? '';
      int count = await getJumlahWarga(blokValue);

      if (!mounted) return;

      setState(() {
        blokList[i]['warga'] = '$count Warga';
      });
    }
  }

  Future<int> getJumlahWarga(String blok) async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'warga')
            .where('blok', isEqualTo: blok)
            .get();

    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: blokList.length,
        itemBuilder: (context, index) {
          final item = blokList[index];

          final String label = item['label'] ?? '';
          final String value = item['value'] ?? '';
          final String warga = item['warga'] ?? '';

          return BlokBarItem(
            blok: label,
            warga: warga,
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() => selectedIndex = index);
              // if (widget.onBlokSelected != null) {
              //   widget.onBlokSelected!(item['value']!);
              // }
              widget.onBlokSelected?.call(value);
            },
          );
        },
      ),
    );
  }
}
