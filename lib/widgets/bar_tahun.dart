import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarTahun extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;

  const BarTahun({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<BarTahun> createState() => _BarTahunState();
}

class _BarTahunState extends State<BarTahun> {
  @override
  Widget build(BuildContext context) {
    // final monthYearText = DateFormat('MMMM yyyy').format(widget.selectedDate);
    final year = DateFormat('yyyy').format(widget.selectedDate);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15),
              onPressed: () {
                final newDate = DateTime(
                  widget.selectedDate.year - 1,
                  // widget.selectedDate.month - 1,
                );
                widget.onDateChanged(newDate);
                debugPrint('back');
              },
            ),
            Text(year, style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              onPressed: () {
                final newDate = DateTime(
                  widget.selectedDate.year + 1,
                  // widget.selectedDate.month + 1,
                );
                widget.onDateChanged(newDate);
                debugPrint('next');
              },
            ),
          ],
        ),
      ),
    );
  }
}
