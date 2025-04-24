import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultInput extends StatelessWidget {
  final String hint;
  final String label;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const DefaultInput({
    super.key,
    required this.hint,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF777777)),
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
