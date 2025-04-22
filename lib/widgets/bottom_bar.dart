import 'package:flutter/material.dart';
import 'package:si_warga/pages/homepage.dart';
import 'package:si_warga/pages/admin_tagihan_warga.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> pages = [
    Homepage(),
    AdminTagihanWarga(),
    Text('Rekap'),
    Text('Laporan'),
    Text('Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16), // Padding dari tepi layar
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFB4CCAC), // supaya ikut container
        // elevation: 0, // hilangkan bayangan bawaannya
        selectedItemColor: const Color(0xFF184E0E),
        unselectedItemColor: const Color(0xFF749C6C),
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Tagihan'),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_quote_outlined),
            label: 'Rekap',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart_outlined),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
    // return Scaffold(
    //   body: pages[_selectedIndex],
    //   bottomNavigationBar: BottomNavigationBar(
    //     backgroundColor: Color(0xFFB4CCAC), // supaya ikut container
    //     //     // elevation: 0, // hilangkan bayangan bawaannya
    //     selectedItemColor: const Color(0xFF184E0E),
    //     unselectedItemColor: const Color(0xFF749C6C),
    //     currentIndex: _selectedIndex,
    //     selectedFontSize: 12,
    //     unselectedFontSize: 12,
    //     selectedIconTheme: const IconThemeData(size: 24),
    //     unselectedIconTheme: const IconThemeData(size: 24),
    //     onTap: _onTap,
    //     items: [
    //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    //       BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Tagihan'),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.request_quote_outlined),
    //         label: 'Rekap',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.insert_chart_outlined),
    //         label: 'Laporan',
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person_2_rounded),
    //         label: 'Profil',
    //       ),
    //     ],
    //   ),
    // );
  }
}
