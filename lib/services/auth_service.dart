import 'dart:convert';

import 'package:google_docs/constants.dart';
import 'package:google_docs/models/error_model.dart';
import 'package:google_docs/services/local_storage_service.dart';
import 'package:http/http.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider(
  (ref) => AuthService(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageService: LocalStorageService(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthService {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageService _localStorageService;

  AuthService({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageService localStorageService,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageService = localStorageService;

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
              token: jsonDecode(response.body)['token'],
            );
            _localStorageService.setToken(newUser.token);
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

  Future<ErrorModel> getUserData() async {
    ErrorModel errorModel = ErrorModel(
      error: 'Some unexpected error occured!',
      data: null,
    );
    try {
      String? token = await _localStorageService.getToken();
      if (token != null) {
        final response = await _client.get(
          Uri.parse('$host/'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        switch (response.statusCode) {
          case 200:
            final newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(response.body)['user'],
              ),
            ).copyWith(token: token);
            errorModel = ErrorModel(error: null, data: newUser);
            _localStorageService.setToken(newUser.token);
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
