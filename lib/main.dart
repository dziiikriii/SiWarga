import 'package:flutter/material.dart';
import 'package:si_warga/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://uiwijslwhhvjehzqftfq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpd2lqc2x3aGh2amVoenFmdGZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTM0MjcsImV4cCI6MjA2MDcyOTQyN30.CGTgQIUwi0Ahe7C5FinI0W8oB986Sqrqu8GUBwBn7aQ',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiWarga',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF184E0E)),
        fontFamily: 'Neue Montreal',
      ),
      home: const SplashScreen(),
    );
  }
}
