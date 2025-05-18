import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/full_width_button.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

class MetodePembayaran extends StatefulWidget {
  final List<QueryDocumentSnapshot> selectedTagihan;
  const MetodePembayaran({super.key, required this.selectedTagihan});

  @override
  State<MetodePembayaran> createState() => MetodePembayaranState();
}

class MetodePembayaranState extends State<MetodePembayaran> {
  List<String> metodePembayaran = ['Transfer', 'Cash'];
  String? selectedMetode;
  File? _buktiBayar;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _buktiBayar = File(picked.path);
      });
    }
  }

  Future<void> _konfirmasiPembayaran() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (selectedMetode == null ||
        (selectedMetode == 'Transfer' && _buktiBayar == null)) {
      // if (selectedMetode == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lengkapi semua data!')));
      return;
    }

    String? buktiUrl;
    if (selectedMetode == 'Transfer') {
      buktiUrl = await uploadImageToSupabase(_buktiBayar!);

      if (buktiUrl == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Upload gambar gagal')));
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pembayaran sudah diteruskan ke bendahara untuk konrfirmasi',
        ),
      ),
    );

    for (var tagihan in widget.selectedTagihan) {
      final tagihanId = tagihan.id;
      await FirebaseFirestore.instance
          .collection('tagihan_user')
          .doc(currentUser!.uid)
          .collection('items')
          .doc(tagihanId)
          .update({
            'status': 'menunggu_konfirmasi',
            'metode_pembayaran': selectedMetode,
            'bukti_url': buktiUrl ?? '',
            'tanggal_bayar': DateTime.now(),
          });
    }

    Navigator.pop(context, 'success');
  }

  Future<String?> uploadImageToSupabase(File imageFile) async {
    final supabase = Supabase.instance.client;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = 'public/$fileName';

    try {
      await supabase.storage
          .from('buktipembayaran')
          .upload(filePath, imageFile);

      // Jika berhasil, `response` akan kosong string (""), jadi kita lanjut ambil URL
      final publicUrl = supabase.storage
          .from('buktipembayaran')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final totalTagihan =
        widget.selectedTagihan
            .fold<num>(0, (sum, item) => sum + (item['jumlah'] ?? 0))
            .toInt(); // ubah hasil akhir ke int

    return Scaffold(
      appBar: AppBarDefault(title: 'Bayar Tagihan'),
      body: SingleChildScrollView(
        child: Container(
          // height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                offset: Offset(4, 4),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tagihan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF184E0E),
                        ),
                      ),
                      Text(
                        'Jumlah',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF184E0E),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(height: 2, color: Colors.black),
                  SizedBox(height: 20),
                  ...widget.selectedTagihan.map((tagihan) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tagihan['nama'],
                                style: TextStyle(fontSize: 15),
                              ),
                              // Text('Rp ${tagihan['jumlah']}'),
                              Text(formatter.format(tagihan['jumlah'])),
                            ],
                          ),
                          SizedBox(height: 5),
                          Divider(
                            height: 2,
                            color: const Color.fromARGB(255, 219, 219, 219),
                          ),
                        ],
                      ),
                    );
                    // }).toList(),
                  }),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Total : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(formatter.format(totalTagihan)),
                    ],
                  ),
                  // Text('Pilih Metode Pembayaran : '),
                  DropdownButton<String>(
                    value: selectedMetode,
                    hint: Text(
                      'Pilih Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedMetode = value;
                      });
                    },
                    items:
                        metodePembayaran.map((metode) {
                          return DropdownMenuItem(
                            value: metode,
                            child: Text(metode),
                          );
                        }).toList(),
                  ),
                ],
              ),

              // if(selectedMetode == 'transfer') {
              //   Text('Transfer ke salah satu bank berikut'),
              // },
              SizedBox(height: 20),
              if (selectedMetode == 'Transfer') ...[
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transfer ke salah satu bank berikut',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Bank Mandiri'),
                            Text('Bank BCA'),
                            Text('Bank BSI'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SelectableText('1234 5678 9999'),
                            SelectableText('1234 5678 9999'),
                            SelectableText('1234 5678 9999'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),

                Text(
                  'Upload Bukti Pembayaran',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Color(0xFF777777)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _pickImage,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        color: Color(0xFF777777),
                      ),
                      Text(
                        'Tambahkan File',
                        style: TextStyle(color: Color(0xFF777777)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_buktiBayar != null) Image.file(_buktiBayar!, height: 150),
                SizedBox(height: 10),
                Text(path.basename(_buktiBayar?.path ?? '')),
                SizedBox(height: 30),
              ],
              FullWidthButton(
                text: 'Konfirmasi Bendahara',
                onPressed: _konfirmasiPembayaran,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
