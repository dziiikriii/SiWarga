import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YearBar extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;

  const YearBar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<YearBar> createState() => _YearBarState();
}

class _YearBarState extends State<YearBar> {
  @override
  Widget build(BuildContext context) {
    final monthYearText = DateFormat('MMMM yyyy').format(widget.selectedDate);
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
                  widget.selectedDate.year,
                  widget.selectedDate.month - 1,
                );
                widget.onDateChanged(newDate);
                debugPrint('back');
              },
            ),
            Text(monthYearText, style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              // padding: EdgeInsets.zero,
              // constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 15),
              onPressed: () {
                final newDate = DateTime(
                  widget.selectedDate.year,
                  widget.selectedDate.month + 1,
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
