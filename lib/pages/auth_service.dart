import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:si_warga/widgets/bottom_bar.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Register
  Future<User?> registerWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user!.sendEmailVerification();

      return cred.user;
    } catch (e) {
      debugPrint('Error saat register: $e');
      return null;
    }
  }

  Future<void> saveUserData(
    String uid,
    String name,
    String address,
    String blok,
    String noRumah,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'address': address,
        'blok': blok,
        'no_rumah': noRumah,
        'role': 'warga',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

  // Login
  Future<User?> loginWithEmail(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!cred.user!.emailVerified) {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email belum diverifikasi. Silakan cek email anda'),
          ),
        );
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(cred.user!.uid).get();

      if (userDoc.exists) {
        String role = userDoc['role'];

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomBar(role: role)),
        );
      }

      return cred.user;
    } catch (e) {
      debugPrint('Error saat login: $e');
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('Error saat mengirim email reset password: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
