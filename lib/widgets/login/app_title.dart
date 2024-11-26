import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Sign in to get started',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(0xFF48B04C),
      ),
      textAlign: TextAlign.center,
    );
  }
}
