import 'package:flutter/material.dart';

class DefaultCheckbox extends StatelessWidget {
  final bool? value;
  final Function(bool?)? onChanged;

  const DefaultCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      activeColor: const Color(0xFF37672F),
      onChanged: onChanged,
    );
  }
}

