import 'package:flutter/material.dart';

class ChecklistTagihanItem extends StatefulWidget {
  const ChecklistTagihanItem({super.key});

  @override
  State<ChecklistTagihanItem> createState() => _ChecklistTagihanItemState();
}

class _ChecklistTagihanItemState extends State<ChecklistTagihanItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Februari',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            'Rp 50.000',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
