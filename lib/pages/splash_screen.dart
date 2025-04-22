import 'package:flutter/material.dart';
import 'package:si_warga/pages/first_onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FirstOnboarding()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return const Image(image: AssetImage('lib/assets/siwarga_logo.png'));
    return Scaffold(
      backgroundColor: const Color(0xFFECFCEC),
      body: Center(child: Image.asset('lib/assets/siwarga_logo.png')),
    );
  }
}
