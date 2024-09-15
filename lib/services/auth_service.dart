import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String loginApiUrl = 'https://legacy.matviran.com/api/login.php';
  final String SignupApiUrl = 'https://legacy.matviran.com/api/Signup.php'; // Registration endpoint

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(loginApiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['success'] == true;
    }
    return false;
  }

  Future<bool> Signup(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(SignupApiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['success'] == true;
    }
    return false;
  }
}
