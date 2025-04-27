import 'package:flutter/material.dart';

class BlokNoRumahInput extends StatefulWidget {
  final TextEditingController blokController;
  final TextEditingController noRumahController;

  const BlokNoRumahInput({
    super.key,
    required this.blokController,
    required this.noRumahController,
  });

  @override
  State<BlokNoRumahInput> createState() => _BlokNoRumahInputState();
}

class _BlokNoRumahInputState extends State<BlokNoRumahInput> {
  String? selectedValueBlok = 'Blok';
  String? selectedValueNo = 'No. Rumah';

  final List<String> optionsBlok = ['Blok', 'A', 'B', 'C', 'D', 'E', 'F'];
  final List<String> optionsNo = [
    'No. Rumah',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Blok : '),
            DropdownButton<String>(
              value: selectedValueBlok != 'Blok' ? selectedValueBlok : null,
              onChanged: (newValue) {
                setState(() {
                  selectedValueBlok = newValue;
                  widget.blokController.text = newValue ?? '';
                });
              },
              items:
                  optionsBlok.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
        SizedBox(width: 40),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No. Rumah : '),
            DropdownButton<String>(
              value: selectedValueNo != 'No. Rumah' ? selectedValueNo : null,
              onChanged: (newValueNo) {
                setState(() {
                  selectedValueNo = newValueNo;
                  widget.noRumahController.text = newValueNo ?? '';
                });
              },
              items:
                  optionsNo.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}
