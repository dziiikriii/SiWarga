import 'package:flutter/material.dart';
import 'package:si_warga/pages/tambah_tagihan.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/checklist_tagihan_item.dart';
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
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            YearBar(),
            LunasBar(leftText: 'Iuran Bulanan', rightText: ('Iuran Lainnya')),
            SizedBox(height: 20),
            Expanded(
              child: Container(
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
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ChecklistTagihanItem(
                        title: 'Bulan ke-${index + 1}',
                        value: (index + 1) * 10000,
                      );
                    },
                  ),
                ),
              ),
            ),

            // FullWidthButton(
            //   text: 'Edit Tagihan',
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const LoginPage()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // aksi saat ditekan
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TambahTagihan()),
          );
        },
        backgroundColor: Color(0xFF37672F),

        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
