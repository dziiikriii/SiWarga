// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:si_warga/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:si_warga/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://uiwijslwhhvjehzqftfq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpd2lqc2x3aGh2amVoenFmdGZxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTM0MjcsImV4cCI6MjA2MDcyOTQyN30.CGTgQIUwi0Ahe7C5FinI0W8oB986Sqrqu8GUBwBn7aQ',
  );
  await initializeDateFormatting('id_ID', null);
  await NotificationService.initialize();
  await requestNotificationPermission();
  // await FirebaseMessaging.instance.requestPermission();
  // final fcmToken = await FirebaseMessaging.instance.getToken();
  runApp(const MyApp());
}

// Future<void> saveAdminToken() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     final fcmToken = await FirebaseMessaging.instance.getToken();
//     if (fcmToken != null) {
//       await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
//         {'fcmToken': fcmToken},
//       );
//     }
//   }
// }

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;
  if (!status.isGranted) {
    await Permission.notification.request();
  }
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
