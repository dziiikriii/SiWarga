import 'package:flutter/material.dart';

class ChecklistTagihanItem extends StatefulWidget {
  final String title;
  final int value;
  const ChecklistTagihanItem({
    super.key,
    required this.title,
    required this.value,
  });

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
            widget.title,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            widget.value.toString(),
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
