import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/screens/home_screen.dart';
import 'package:google_docs/services/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final sMessanger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final errorModel = await ref.read(authServiceProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      sMessanger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
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
