import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/colors.dart';
import 'package:google_docs/services/auth_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void signOut(WidgetRef ref) async {
    ref.read(authServiceProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(backgroundColor: kWhiteColor, elevation: 0, actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
            color: kBlackColor,
          ),
        ),
        IconButton(
          onPressed: () => signOut(ref),
          icon: const Icon(
            Icons.logout,
            color: kRedColor,
          ),
        ),
      ]),
      body: Center(
        child: Text(ref.watch(userProvider)!.uid),
      ),
    );
  }
}
