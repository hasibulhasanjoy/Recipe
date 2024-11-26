import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isSigning;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.isSigning,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF48B04C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: isSigning
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'Sign in',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
    );
  }
}
