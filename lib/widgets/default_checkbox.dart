import 'package:flutter/material.dart';

class DefaultCheckbox extends StatefulWidget {
  const DefaultCheckbox({super.key});

  @override
  State<DefaultCheckbox> createState() => _DefaultCheckboxState();
}

class _DefaultCheckboxState extends State<DefaultCheckbox> {
  @override
  Widget build(BuildContext context) {
    bool? isChecked = false;
    return Checkbox(
      value: isChecked,
      activeColor: Color(0xFF37672F),
      onChanged: (newBool) {
        setState(() {
          isChecked = newBool;
        });
      },
    );
  }
}
