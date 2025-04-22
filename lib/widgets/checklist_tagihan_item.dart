import 'package:flutter/material.dart';
import 'package:si_warga/widgets/default_checkbox.dart';

class ChecklistTagihanItem extends StatefulWidget {
  const ChecklistTagihanItem({super.key});

  @override
  State<ChecklistTagihanItem> createState() => _ChecklistTagihanItemState();
}

class _ChecklistTagihanItemState extends State<ChecklistTagihanItem> {
  bool? isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            DefaultCheckbox(),
            Text(
              'Februari',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
          ],
        ),
        Text(
          'Rp 50.000',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ],
    );
  }
}
