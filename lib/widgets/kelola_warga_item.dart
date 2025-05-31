import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class KelolaWargaItem extends StatefulWidget {
  final String nama;
  final String email;
  final String uid;

  const KelolaWargaItem({
    super.key,
    required this.nama,
    required this.email,
    required this.uid,
  });

  @override
  State<KelolaWargaItem> createState() => _KelolaWargaItemState();
}

class _KelolaWargaItemState extends State<KelolaWargaItem> {
  // final List<String> roles = ['warga', 'admin', 'pengurus'];
  final List<String> roles = ['warga', 'admin', 'pengurus'];
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(
                0,
                0,
                0,
                0.1,
              ), // alternatif yang direkomendasikan
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nama,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.email, style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: selectedRole,
                hint: Text("Pilih role"),
                isExpanded: true,
                items:
                    roles.map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if (selectedRole != null) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: widget.email)
                            .get()
                            .then((query) async {
                              if (query.docs.isNotEmpty) {
                                final userRef = query.docs.first.reference;

                                final Map<String, dynamic> updateData = {
                                  'role': selectedRole,
                                };

                                if (selectedRole == 'admin' ||
                                    selectedRole == 'pengurus') {
                                  updateData['blok'] = FieldValue.delete();
                                  updateData['no_rumah'] = FieldValue.delete();
                                }
                                await userRef.update(updateData);

                                if (selectedRole == 'warga') {
                                  final tagihanSnapshot =
                                      await FirebaseFirestore.instance
                                          .collection('tagihan')
                                          .get();

                                  for (var tagihanDoc in tagihanSnapshot.docs) {
                                    final tagihanData = tagihanDoc.data();

                                    await FirebaseFirestore.instance
                                        .collection('tagihan_user')
                                        .doc(widget.uid)
                                        .collection('items')
                                        .doc(tagihanDoc.id)
                                        .set({
                                          ...tagihanData,
                                          'status': 'belum bayar',
                                        });
                                  }
                                }
                              }

                              // query.docs.first.reference.update({
                              //   'role': selectedRole,
                              // });
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Akun berhasil disetujui dengan role $selectedRole',
                                  ),
                                  backgroundColor: Color(0xFF184E0E),
                                ),
                              );
                            });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Silakan pilih role terlebih dahulu'),
                            backgroundColor: const Color.fromARGB(
                              255,
                              212,
                              127,
                              0,
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.check_circle_rounded,
                      color: Color.fromARGB(255, 113, 213, 73),
                      size: 30,
                    ),
                    // padding: EdgeInsets.zero,
                    // constraints: BoxConstraints(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.6),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 217, 42, 42),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .where('email', isEqualTo: widget.email)
                              .get()
                              .then((query) {
                                if (query.docs.isNotEmpty) {
                                  query.docs.first.reference.delete();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('User telah ditolak'),
                                    ),
                                  );
                                }
                              });
                        },
                        icon: Icon(Icons.close_rounded, size: 25),
                        color: Colors.white,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
