import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;

      if (user != null) {
        // Save the user's name and email to Firestore
        await _firestore.collection('users').doc(user.uid).set(
          {
            'name': name,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          },
        );
        await user.updateDisplayName(name);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(
            context: context,
            message: 'The email address is already in use.',
          );
        } else {
          showSnackBar(
            context: context,
            message: 'An error occurred: ${e.code}',
          );
        }
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          showSnackBar(context: context, message: 'Invalid email or password.');
        } else {
          showSnackBar(
              context: context, message: 'An error occurred: ${e.code}');
        }
      }
    }
    return null;
  }
}
