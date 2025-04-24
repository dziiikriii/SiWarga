import 'package:flutter/material.dart';

class LunasBar extends StatefulWidget {
  final String leftText;
  final String rightText;
  const LunasBar({super.key, required this.leftText, required this.rightText});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () => _onTabTapped(0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.leftText,
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
              ),
              Container(
                height: 2,
                width: 130,
                color:
                    selectedIndex == 0 ? Color(0xFF37672F) : Color(0xFF777777),
              ),
            ],
          ),
          Column(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  splashFactory: NoSplash.splashFactory,
                ),
                onPressed: () => _onTabTapped(1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.rightText,
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
              ),
              Container(
                height: 2,
                width: 130,
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
