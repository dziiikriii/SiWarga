import 'package:flutter/material.dart';
import 'package:si_warga/widgets/blok_bar_item.dart';

class BlokBar extends StatefulWidget {
  const BlokBar({super.key});

  @override
  State<BlokBar> createState() => _BlokBarState();
}

class _BlokBarState extends State<BlokBar> {
  int selectedIndex = 0;

  final List<Map<String, String>> blokList = [
    {'blok': 'Blok A', 'warga': '10 Warga'},
    {'blok': 'Blok B', 'warga': '5 Warga'},
    {'blok': 'Blok C', 'warga': '8 Warga'},
    {'blok': 'Blok D', 'warga': '7 Warga'},
    {'blok': 'Blok E', 'warga': '9 Warga'},
    {'blok': 'Blok F', 'warga': '11 Warga'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: blokList.length,
        itemBuilder: (context, index) {
          final item = blokList[index];
          return BlokBarItem(
            blok: item['blok']!,
            warga: item['warga']!,
            isSelected: selectedIndex == index,
            onTap: () => setState(() => selectedIndex = index),
          );
        },
      ),
    );
  }
}
