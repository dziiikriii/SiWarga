import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_checkbox.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class GenerateTagihanBulanan extends StatefulWidget {
  const GenerateTagihanBulanan({super.key});

  @override
  State<GenerateTagihanBulanan> createState() => _GenerateTagihanBulananState();
}

class _GenerateTagihanBulananState extends State<GenerateTagihanBulanan> {
  final namaTagihanController = TextEditingController();
  final jumlahTagihanController = TextEditingController();

  final List<String> bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final Map<String, bool> _bulanDipilih = {};

  @override
  void initState() {
    super.initState();
    for (var b in bulan) {
      _bulanDipilih[b] = true;
    }
  }

  // Mengonversi nama bulan ke nomor bulan
  int _bulanKeAngka(String namaBulan) {
    return bulan.indexOf(namaBulan) + 1;
  }

  // Mendapatkan tanggal akhir dari suatu bulan
  String _getTanggalAkhirBulan(String namaBulan, int tahun) {
    final bulanAngka = _bulanKeAngka(namaBulan);
    final lastDate = DateTime(
      tahun,
      bulanAngka + 1,
      0,
    ); // 0 artinya hari terakhir bulan sebelumnya
    return "${lastDate.day.toString().padLeft(2, '0')}-${lastDate.month.toString().padLeft(2, '0')}-${lastDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Generate Tagihan'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Bulan:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            /// Gunakan Expanded agar semua bulan bisa terlihat
            Expanded(
              child: ListView.builder(
                itemCount: bulan.length,
                itemBuilder: (context, index) {
                  final namaBulan = bulan[index];
                  final isChecked = _bulanDipilih[namaBulan] ?? false;
                  return Row(
                    children: [
                      DefaultCheckbox(
                        value: isChecked,
                        onChanged: (newValue) {
                          setState(() {
                            _bulanDipilih[namaBulan] = newValue ?? false;
                          });
                        },
                      ),
                      Text(namaBulan),
                    ],
                  );
                },
              ),
            ),

            SizedBox(height: 10),
            DefaultInput(
              hint: 'Jumlah Tagihan',
              label: 'Jumlah Tagihan',
              controller: jumlahTagihanController,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan',
              onPressed: () async {
                final nama = namaTagihanController.text.trim();
                final jumlahText = jumlahTagihanController.text.trim();
                // final tenggat = dateController.text.trim();

                if (nama.isEmpty || jumlahText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Semua field harus diisi'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                final firestore = FirebaseFirestore.instance;
                final tahun = DateTime.now().year;
                final selectedBulan =
                    _bulanDipilih.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();
                final jumlah = int.tryParse(jumlahText);

                if (jumlah == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Jumlah tagihan harus diisi'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }

                for (var bulan in selectedBulan) {
                  final tenggat = _getTanggalAkhirBulan(bulan, tahun);
                  final tagihanData = {
                    'nama': 'Iuran $bulan',
                    // 'jumlah': int.tryParse(jumlahTagihanController.text),
                    'jumlah': jumlah,
                    'tipe': 'Iuran Bulanan',
                    'tenggat': tenggat,
                    'createdAt': FieldValue.serverTimestamp(),
                  };

                  final tagihanRef = await firestore
                      .collection('tagihan')
                      .add(tagihanData);

                  final wargaSnapshot =
                      await firestore
                          .collection('users')
                          .where('role', isEqualTo: 'warga')
                          .get();

                  for (var doc in wargaSnapshot.docs) {
                    await firestore
                        .collection('tagihan_user')
                        .doc(doc.id)
                        .collection('items')
                        .doc(tagihanRef.id)
                        .set({...tagihanData, 'status': 'belum bayar'});
                  }
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
