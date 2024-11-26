import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe/auth/auth_service.dart';
import 'package:recipe/screens/signup.dart';
import 'package:recipe/screens/tab.dart';
import 'package:recipe/widgets/login/app_title.dart';
import 'package:recipe/widgets/login/email_field.dart';
import 'package:recipe/widgets/login/footer.dart';
import 'package:recipe/widgets/login/google_button.dart';
import 'package:recipe/widgets/login/login_button.dart';
import 'package:recipe/widgets/login/password_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSigning = false;

  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTitle(),
            const SizedBox(height: 40),
            EmailField(controller: _emailController),
            const SizedBox(height: 16),
            PasswordField(controller: _passwordController),
            const SizedBox(height: 24),
            LoginButton(
              onPressed: _signIn,
              isSigning: _isSigning,
            ),
            const SizedBox(height: 16),
            GoogleButton(
              onPressed: () {
                _signInWithGoogle();
              },
            ),
            const SizedBox(height: 24),
            Footer(
              onSignUp: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const SignUpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Save login state using SharedPreferences
  Future<void> saveLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isLoggedIn', true);
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    User? user =
        await _auth.signInWithEmailAndPassword(context, email, password);

    setState(() {
      _isSigning = false;
    });

    if (user != null) {
      await saveLoginState();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabScreen(),
          ),
        );
      }
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        User? user = userCredential.user;

        if (user != null) {
          // Check if the user already exists in Firestore
          final DocumentReference userDoc =
              FirebaseFirestore.instance.collection('users').doc(user.uid);

          final DocumentSnapshot userSnapshot = await userDoc.get();

          // If user doesn't exist, save their data to Firestore
          if (!userSnapshot.exists) {
            await userDoc.set({
              'name': user.displayName ?? 'Unknown',
              'email': user.email ?? '',
              'createdAt': FieldValue.serverTimestamp(),
            });
          }
          await saveLoginState();

          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const TabScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 1),
            content: Text("Sign in failed"),
          ),
        );
      }
    }
  }
}
