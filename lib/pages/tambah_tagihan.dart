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
      lastDate: DateTime(2030),
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
            // TextField(
            //   controller: dateController,
            //   readOnly: true, // agar tidak bisa diketik manual
            //   onTap: () => selectDate(context),
            //   decoration: InputDecoration(
            //     hintText: 'Tanggal',
            //     hintStyle: TextStyle(color: Color(0xFF777777)),
            //     suffixIcon: Icon(Icons.calendar_today),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            // ),
            DefaultInputDate(title: 'Tenggat Tagihan'),
            SizedBox(height: 20),
            FullWidthButton(text: 'Simpan', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
