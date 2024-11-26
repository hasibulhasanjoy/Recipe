import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final VoidCallback onSignUp;

  const Footer({
    super.key,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don’t have an account?"),
        TextButton(
          onPressed: onSignUp,
          child: const Text(
            'Sign up',
            style: TextStyle(color: Color(0xFFFFA500)),
          ),
        ),
      ],
    );
  }
}
