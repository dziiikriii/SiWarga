import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/bayar_tagihan_bar.dart';
// import 'package:si_warga/widgets/checklist_tagihan_item.dart';
import 'package:si_warga/widgets/lunas_bar.dart';
import 'package:si_warga/widgets/year_bar.dart';

class WargaTagihanWarga extends StatefulWidget {
  const WargaTagihanWarga({super.key});

  @override
  State<WargaTagihanWarga> createState() => _WargaTagihanWargaState();
}

class _WargaTagihanWargaState extends State<WargaTagihanWarga> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              YearBar(),
              LunasBar(leftText: 'Iuran Bulanan', rightText: ('Iuran Lainnya')),
              SizedBox(height: 20),
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
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                      // ChecklistTagihanItem(),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    top: 10,
                    bottom: 10,
                    right: 10,
                  ),
                  child: BayarTagihanBar(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
