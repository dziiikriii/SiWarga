import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultInput extends StatelessWidget {
  final String hint;
  final String label;
  final double verticalPadding;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  const DefaultInput({
    super.key,
    required this.hint,
    required this.label,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.verticalPadding = 10.0,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Color(0xFF777777),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
