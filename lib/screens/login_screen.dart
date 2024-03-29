import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/services/auth_service.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref) async {
    final sMessanger = ScaffoldMessenger.of(context);
    final navigator = Routemaster.of(context);
    final errorModel = await ref.read(authServiceProvider).signInWithGoogle();

    if (errorModel.error == null) {
      ref.read(userProvider.notifier).update((state) => errorModel.data);
      navigator.replace("/");
    } else {
      debugPrint(errorModel.error);
      sMessanger.showSnackBar(
        SnackBar(
          content: Text(errorModel.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/signin.svg",
              height: size.height * 0.4,
              width: size.width * 0.4,
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () => signInWithGoogle(context, ref),
              icon: Image.asset(
                "assets/images/google-logo.png",
                height: 25,
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  color: kDarkGreyColor,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                maximumSize: const Size(500, 80),
                backgroundColor: kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
