import 'package:flutter/material.dart';
import 'package:si_warga/widgets/grafik_keuangan.dart';
import 'package:si_warga/widgets/halo_user.dart';
import 'package:si_warga/widgets/info_saldo_home.dart';

class HomepageWarga extends StatelessWidget {
  const HomepageWarga({super.key});

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
                          Icon(
                            Icons.notifications_none,
                            size: 35,
                            color: Color(0xFF184E0E),
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
              // child: YearBar(),
            ),
            GrafikKeuangan(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
