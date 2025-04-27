import 'package:flutter/material.dart';

class DefaultInputPassword extends StatefulWidget {
  final TextEditingController? controller;

  const DefaultInputPassword({super.key, this.controller});

  @override
  State<DefaultInputPassword> createState() => _DefaultInputPasswordState();
}

class _DefaultInputPasswordState extends State<DefaultInputPassword> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Masukkan password',
              hintStyle: TextStyle(fontSize: 15, color: Color(0xFF777777)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
