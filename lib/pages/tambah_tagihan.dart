import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_date.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class TambahTagihan extends StatefulWidget {
  const TambahTagihan({super.key});

  @override
  State<TambahTagihan> createState() => _TambahTagihanState();
}

class _TambahTagihanState extends State<TambahTagihan> {
  final namaTagihanController = TextEditingController();
  final jumlahTagihanController = TextEditingController();
  final tipeTagihanController = TextEditingController();
  final dateController = TextEditingController();

  String? selectedType = 'Iuran Bulanan';

  final List<String> tipeTagihan = ['Iuran Bulanan', 'Iuran Lainnya'];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2050),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: 'Tambah Tagihan'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultInput(
              hint: 'Nama Tagihan',
              label: 'Nama Tagihan',
              controller: namaTagihanController,
            ),
            DefaultInput(
              hint: 'Jumlah Tagihan',
              label: 'Jumlah Tagihan',
              controller: jumlahTagihanController,
              keyboardType: TextInputType.number,
            ),
            Text('Tipe Tagihan : '),
            DropdownButton<String>(
              value: selectedType,
              onChanged: (newValue) {
                setState(() {
                  selectedType = newValue;
                  tipeTagihanController.text = newValue ?? '';
                });
              },
              items:
                  tipeTagihan.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            DefaultInputDate(
              title: 'Tenggat Tagihan',
              dateController: dateController,
            ),
            SizedBox(height: 20),
            FullWidthButton(
              text: 'Simpan',
              onPressed: () async {
                if (namaTagihanController.text.trim().isEmpty ||
                    jumlahTagihanController.text.trim().isEmpty ||
                    dateController.text.trim().isEmpty ||
                    selectedType == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Mohon isi seluruh data di atas'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final firestore = FirebaseFirestore.instance;

                final tagihanData = {
                  'nama': namaTagihanController.text,
                  'jumlah': int.tryParse(jumlahTagihanController.text),
                  'tipe': selectedType,
                  'tenggat': dateController.text,
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
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil menambahkan tagihan'),
                    backgroundColor: Color(0xFF184E0E),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
