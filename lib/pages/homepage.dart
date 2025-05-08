import 'package:flutter/material.dart';
import 'package:si_warga/pages/kelola_warga.dart';
import 'package:si_warga/widgets/halo_user.dart';
import 'package:si_warga/widgets/info_saldo_home.dart';
import 'package:si_warga/widgets/year_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  colors: [Color.fromARGB(195, 24, 78, 14), Color(0xFFECFCEC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'lib/assets/logo_only.png',
                                width: 70,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'SIWARGA',
                                style: TextStyle(
                                  fontFamily: 'THICCCBOI',
                                  color: Color(0xFF184E0E),
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 35,
                                color: Color(0xFF184E0E),
                              ),
                              Icon(
                                Icons.settings_outlined,
                                size: 35,
                                color: Color(0xFF184E0E),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      HaloUser(),
                      SizedBox(height: 6),
                      Text(
                        'Perumahan Bukit Hijau Permata Hijau',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KelolaWarga(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFF184E0E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Kelola Warga',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_rounded, size: 25),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      InfoSaldoHome(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: YearBar(),
            ),
            SizedBox(height: 20),
            Center(child: Image.asset('lib/assets/graph.png')),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Klik gambar untuk cek detail',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ),
            // BottomBar(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
