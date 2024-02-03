import 'package:flutter/material.dart';
import 'package:google_docs/colors.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () {},
          icon: Image.asset(
            "assets/images/google-logo.png",
            height: 20,
          ),
          label: const Text(
            "Sign in with Google",
            style: TextStyle(
              color: kDarkGreyColor,
              fontSize: 14,
            ),
          ),
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(400, 50),
            backgroundColor: kWhiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
