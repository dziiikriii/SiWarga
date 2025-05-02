import 'package:flutter/material.dart';

class DefaultInputDate extends StatefulWidget {
  final String title;

  const DefaultInputDate({super.key, required this.title});

  @override
  State<DefaultInputDate> createState() => _DefaultInputDateState();
}

class _DefaultInputDateState extends State<DefaultInputDate> {
  final dateController = TextEditingController();

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontSize: 14)),
        SizedBox(height: 10),
        TextField(
          controller: dateController,
          readOnly: true, // agar tidak bisa diketik manual
          onTap: () => selectDate(context),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            hintText: 'Tanggal',
            hintStyle: TextStyle(color: Color(0xFF777777)),
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
