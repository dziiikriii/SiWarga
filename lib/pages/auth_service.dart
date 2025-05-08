import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:si_warga/widgets/bottom_bar.dart';

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
    String email,
    String address,
    String blok,
    String noRumah,
  ) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'address': address,
        'blok': blok,
        'no_rumah': noRumah,
        // 'role': 'warga',
        'role': null,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

  Future<void> saveUserDataAdmin(String uid, String name) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'role': 'admin',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saat menyimpan data user: $e');
    }
  }

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
          const SnackBar(
            content: Text('Email belum diverifikasi. Silakan cek email anda'),
          ),
        );
        return null;
      }

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(cred.user!.uid).get();

      if (!userDoc.exists) {
        return null;
      }

      final role = userDoc['role'];
      if (role == null || role == 'pending') {
        await _auth.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun anda belum disetujui oleh admin')),
        );
        return null;
      }

      return cred.user;
    } catch (e) {
      debugPrint('Error saat login: $e');
      return null;
    }
  }

  // Future<Map<String, dynamic>?> loginWithEmail(
  //   String email,
  //   String password,
  // ) async {
  //   try {
  //     UserCredential cred = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Cek verifikasi email
  //     if (!cred.user!.emailVerified) {
  //       await _auth.signOut();
  //       return {'error': 'Email belum diverifikasi. Silakan cek email anda'};
  //     }

  //     // Ambil data user dari Firestore
  //     DocumentSnapshot userDoc =
  //         await _firestore.collection('users').doc(cred.user!.uid).get();

  //     if (userDoc.exists) {
  //       return {'user': cred.user, 'role': userDoc['role']};
  //     } else {
  //       return {'error': 'Data user tidak ditemukan di Firestore'};
  //     }
  //   } catch (e) {
  //     debugPrint('Error saat login: $e');
  //     return {'error': 'Login gagal. Email atau password salah'};
  //   }
  // }

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
