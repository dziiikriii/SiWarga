import 'package:flutter/material.dart';

class ChecklistRekap extends StatelessWidget {
  final bool condition;
  const ChecklistRekap({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   decoration: BoxDecoration(
    //     color: Color.fromARGB(255, 173, 235, 148),
    //     borderRadius: BorderRadius.circular(20)
    //   ),
    //   child: Icon(Icons.check_circle_rounded),
    // );
    return condition
        ? Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Icon(
            Icons.check_circle_rounded,
            color: Color.fromARGB(255, 113, 213, 73),
            size: 30,
          ),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.6),
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 217, 42, 42),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.close_rounded, color: Colors.white, size: 25),
          ),
        );
  }
}
