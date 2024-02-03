import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(
    googleSignIn: GoogleSignIn(),
  ),
);

class AuthService {
  final GoogleSignIn _googleSignIn;

  AuthService({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        print(user);
      }
    } catch (error) {
      print(error);
    }
  }
}
