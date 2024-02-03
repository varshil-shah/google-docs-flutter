import 'dart:convert';

import 'package:google_docs/constants.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:http/http.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(
    googleSignIn: GoogleSignIn(),
    client: Client(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthService {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthService({
    required GoogleSignIn googleSignIn,
    required Client client,
  })  : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel errorModel =
        ErrorModel(error: 'Some unexpected error occured!', data: null);
    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        final userAccount = UserModel(
          uid: '',
          name: user.displayName!,
          email: user.email,
          profilePic: user.photoUrl,
          token: '',
        );

        final response = await _client.post(
          Uri.parse('$host/api/signup'),
          body: userAccount.toJson(),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        );

        switch (response.statusCode) {
          case 200:
            final newUser = userAccount.copyWith(
              uid: jsonDecode(response.body)['user']['_id'],
            );
            errorModel = ErrorModel(error: null, data: newUser);
            break;
          default:
            throw Exception('An error occured while signing in with Google');
        }
      }
    } catch (error) {
      errorModel = ErrorModel(error: error.toString(), data: null);
    }

    return errorModel;
  }
}
