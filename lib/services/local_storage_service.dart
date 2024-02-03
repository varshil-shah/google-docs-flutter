import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  void setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('x-auth-token');
    return token;
  }
}
