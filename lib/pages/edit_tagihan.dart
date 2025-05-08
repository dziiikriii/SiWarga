import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/default_input.dart';
import 'package:si_warga/widgets/default_input_date.dart';
import 'package:si_warga/widgets/full_width_button.dart';

class EditTagihan extends StatefulWidget {
  final String tagihanId;
  final Map<String, dynamic> tagihanData;
  const EditTagihan({
    super.key,
    required this.tagihanId,
    required this.tagihanData,
  });

  @override
  State<EditTagihan> createState() => _EditTagihanState();
}

class _EditTagihanState extends State<EditTagihan> {
  // final namaTagihanController = TextEditingController();
  // final jumlahTagihanController = TextEditingController();
  // final tipeTagihanController = TextEditingController();
  // final dateController = TextEditingController();
  late TextEditingController namaTagihanController;
  late TextEditingController jumlahTagihanController;
  late TextEditingController tipeTagihanController;
  late TextEditingController dateController;

  String? selectedType;

  final List<String> tipeTagihan = ['Iuran Bulanan', 'Iuran Lainnya'];

  @override
  void initState() {
    super.initState();
    namaTagihanController = TextEditingController(
      text: widget.tagihanData['nama'],
    );
    jumlahTagihanController = TextEditingController(
      text: widget.tagihanData['jumlah'].toString(),
    );
    tipeTagihanController = TextEditingController(
      text: widget.tagihanData['tipe'],
    );
    dateController = TextEditingController(text: widget.tagihanData['tenggat']);
    selectedType = widget.tagihanData['tipe'];
  }

  // Future<void> selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(2024),
  //     lastDate: DateTime(2050),
  //     initialDate: DateTime.now(),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       dateController.text =
  //           "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
  //     });
  //   }
  // }

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
              text: 'Simpan Perubahan',
              onPressed: () async {
                final firestore = FirebaseFirestore.instance;

                final updatedData = {
                  'nama': namaTagihanController.text,
                  'jumlah': int.parse(jumlahTagihanController.text),
                  'tipe': selectedType,
                  'tenggat': dateController.text,
                  // 'createdAt': FieldValue.serverTimestamp(),
                };

                await firestore
                    .collection('tagihan')
                    .doc(widget.tagihanId)
                    .update(updatedData);

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
                      .doc(widget.tagihanId)
                      .update(updatedData);
                }

                // final tagihanRef = await firestore
                //     .collection('tagihan')
                //     .add(tagihanData);

                // final wargaSnapshot =
                //     await firestore
                //         .collection('users')
                //         .where('role', isEqualTo: 'warga')
                //         .get();

                // for (var doc in wargaSnapshot.docs) {
                //   await firestore
                //       .collection('tagihan_user')
                //       .doc(doc.id)
                //       .collection('items')
                //       .doc(tagihanRef.id)
                //       .set({...tagihanData, 'status': 'belum bayar'});
                // }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
