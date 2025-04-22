import 'package:flutter/material.dart';

class LunasBar extends StatefulWidget {
  const LunasBar({super.key});

  @override
  State<LunasBar> createState() => _LunasBarState();
}

class _LunasBarState extends State<LunasBar> {
  int selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              TextButton(
                onPressed: () => _onTabTapped(0),
                child: Text(
                  'Belum Lunas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        selectedIndex == 0
                            ? Color(0xFF37672F)
                            : Color(0xFF777777),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 100,
                color:
                    selectedIndex == 0 ? Color(0xFF37672F) : Color(0xFF777777),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                onPressed: () => _onTabTapped(1),
                child: Text(
                  'Lunas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color:
                        selectedIndex == 1
                            ? Color(0xFF37672F)
                            : Color(0xFF777777),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 100,
                color:
                    selectedIndex == 1 ? Color(0xFF37672F) : Color(0xFF777777),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
