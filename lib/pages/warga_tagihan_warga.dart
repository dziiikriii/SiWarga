import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:si_warga/widgets/app_bar_default.dart';
import 'package:si_warga/widgets/bayar_tagihan_bar.dart';
import 'package:si_warga/widgets/default_checkbox.dart';

class WargaTagihanWarga extends StatefulWidget {
  const WargaTagihanWarga({super.key});

  @override
  State<WargaTagihanWarga> createState() => _WargaTagihanWargaState();
}

class _WargaTagihanWargaState extends State<WargaTagihanWarga> {
  final Map<String, bool> _selectedTagihan = {};
  List<QueryDocumentSnapshot> _tagihanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTagihan();
  }

  Future<void> _fetchTagihan() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid;

    final snapshot =
        await FirebaseFirestore.instance
            .collection('tagihan_user')
            .doc(currentUserId)
            .collection('items')
            .orderBy('createdAt', descending: true)
            .get();

    final tagihanList =
        snapshot.docs.where((doc) => doc['status'] == 'belum bayar').toList();

    tagihanList.sort((a, b) {
      final dateFormat = DateFormat('dd-MM-yyyy');
      final dateA = dateFormat.parse(a['tenggat']);
      final dateB = dateFormat.parse(b['tenggat']);
      return dateA.compareTo(dateB);
    });

    setState(() {
      _tagihanList = tagihanList;
      // _tagihanList =
      //     snapshot.docs.where((doc) => doc['status'] == 'belum bayar').toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalTagihan = 0;
    int jumlahDipilih = 0;

    for (var tagihan in _tagihanList) {
      final id = tagihan.id;
      final jumlah = tagihan['jumlah'];
      if (_selectedTagihan[id] == true) {
        totalTagihan += (jumlah is int) ? jumlah : (jumlah as num).toInt();
        jumlahDipilih++;
      }
    }

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    // String formatted = formatter.format(jumlah); // jumlah = 50000

    return Scaffold(
      appBar: AppBarDefault(title: 'Tagihan Iuran Warga'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // YearBar(),
            // LunasBar(leftText: 'Iuran Bulanan', rightText: 'Iuran Lainnya'),
            SizedBox(height: 20),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20), // Warna shadow
                      offset: Offset(
                        4,
                        4,
                      ), // Posisi shadow (horizontal, vertical)
                      blurRadius: 8, // Seberapa buram shadow
                      spreadRadius: 1, // Seberapa besar shadow menyebar
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20,
                    top: 10,
                    // bottom: 10,
                  ),
                  child:
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: _tagihanList.length,
                            itemBuilder: (context, index) {
                              final tagihan = _tagihanList[index];
                              final tagihanId = tagihan.id;
                              final nama = tagihan['nama'] ?? 'Tanpa Nama';
                              final jumlah = tagihan['jumlah'] ?? 0;
                              final tenggat = tagihan['tenggat'] ?? '-';
                              final isChecked =
                                  _selectedTagihan[tagihanId] ?? false;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        DefaultCheckbox(
                                          value: isChecked,
                                          onChanged: (newValue) {
                                            setState(() {
                                              _selectedTagihan[tagihanId] =
                                                  newValue ?? false;
                                            });
                                          },
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.35, // atur lebar agar tidak melebar terus
                                              child: Text(
                                                nama,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                            Text(
                                              tenggat,
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      formatter.format(jumlah).toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ),
            ),
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20), // Warna shadow
                    offset: Offset(
                      4,
                      4,
                    ), // Posisi shadow (horizontal, vertical)
                    blurRadius: 8, // Seberapa buram shadow
                    spreadRadius: 1, // Seberapa besar shadow menyebar
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BayarTagihanBar(
                  total: totalTagihan,
                  jumlahDipilih: jumlahDipilih,
                  onBayar: () {
                    _fetchTagihan();
                  },
                  isAllChecked:
                      _selectedTagihan.length == _tagihanList.length &&
                      _selectedTagihan.values.every((value) => value),
                  onAllCheckedChanged: (value) {
                    setState(() {
                      for (var tagihan in _tagihanList) {
                        _selectedTagihan[tagihan.id] = value ?? false;
                      }
                    });
                  },
                  selectedTagihan:
                      _tagihanList
                          .where(
                            (tagihan) => _selectedTagihan[tagihan.id] == true,
                          )
                          .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
