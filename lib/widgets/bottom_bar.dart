import 'package:flutter/material.dart';
import 'package:si_warga/pages/admin_profile.dart';
import 'package:si_warga/pages/admin_rekap_iuran.dart';
import 'package:si_warga/pages/homepage.dart';
import 'package:si_warga/pages/admin_tagihan_warga.dart';
import 'package:si_warga/pages/homepage_warga.dart';
import 'package:si_warga/pages/laporan_keuangan.dart';
import 'package:si_warga/pages/riwayat_pembayaran_warga.dart';
import 'package:si_warga/pages/warga_profile.dart';
import 'package:si_warga/pages/warga_tagihan_warga.dart';

class BottomBar extends StatefulWidget {
  final String role;
  const BottomBar({super.key, required this.role});

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

  List<Widget> wargaPages = [
    HomepageWarga(),
    WargaTagihanWarga(),
    RiwayatPembayaranWarga(),
    LaporanKeuangan(),
    WargaProfile(),
  ];

  List<Widget> adminPages = [
    Homepage(),
    AdminTagihanWarga(),
    AdminRekapIuran(),
    LaporanKeuangan(),
    AdminProfile(),
  ];

  List<BottomNavigationBarItem> wargaBottomNavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Tagihan'),
    BottomNavigationBarItem(
      icon: Icon(Icons.work_history_rounded),
      label: 'Riwayat',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.insert_chart_outlined),
      label: 'Laporan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_2_rounded),
      label: 'Profil',
    ),
  ];

  List<BottomNavigationBarItem> adminBottomNavItems = [
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
  ];

  @override
  Widget build(BuildContext context) {
    final pages = widget.role == 'admin' ? adminPages : wargaPages;
    final bottomNavItems =
        widget.role == 'admin' ? adminBottomNavItems : wargaBottomNavItems;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFB4CCAC),
        selectedItemColor: const Color(0xFF184E0E),
        unselectedItemColor: const Color(0xFF749C6C),
        currentIndex: _selectedIndex,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: const IconThemeData(size: 24),
        unselectedIconTheme: const IconThemeData(size: 24),
        onTap: _onTap,
        items: bottomNavItems,
      ),
    );
  }
}
