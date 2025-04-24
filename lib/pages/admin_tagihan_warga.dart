import 'package:flutter/material.dart';
import 'package:si_warga/pages/login_page.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/checklist_tagihan_item.dart';
import 'package:si_warga/widgets/full_width_button.dart';
import 'package:si_warga/widgets/lunas_bar.dart';
import 'package:si_warga/widgets/year_bar.dart';

class AdminTagihanWarga extends StatefulWidget {
  const AdminTagihanWarga({super.key});

  @override
  State<AdminTagihanWarga> createState() => _AdminTagihanWargaState();
}

class _AdminTagihanWargaState extends State<AdminTagihanWarga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 20),
            YearBar(),
            LunasBar(leftText: 'Iuran Bulanan', rightText: ('Iuran Lainnya')),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 10,
                  bottom: 10,
                  right: 20,
                ),
                // child: ListView(children: [ ChecklistTagihanItem()]),
                child: Column(
                  children: [
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                    ChecklistTagihanItem(),
                  ],
                ),
              ),
            ),
            FullWidthButton(
              text: 'Edit Tagihan',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
