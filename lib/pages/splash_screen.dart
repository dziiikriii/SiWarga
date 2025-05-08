import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si_warga/pages/first_onboarding.dart';
import 'package:si_warga/pages/login_page.dart';
import 'package:si_warga/widgets/bottom_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  Future<void> navigateUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final onboardingSeen = prefs.getBool('onboardingSeen') ?? false;

    if (!onboardingSeen) {
      // await prefs.setBool('onboardingSeen', true);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FirstOnboarding()),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      try {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          final role = userDoc.get('role');
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottomBar(role: role)),
          );
        } else {
          // Kalau data user tidak ditemukan di Firestore
          FirebaseAuth.instance.signOut();
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      } catch (e) {
        debugPrint('Error mengambil role user: $e');
        FirebaseAuth.instance.signOut();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
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
