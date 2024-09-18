import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../config/config.dart';  // Import the DBConfig
import '../utils/jwt_utils.dart';  // Import JWT utility

class AuthService {
  // Hash the password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  // Handle user signup
  Future<Map<String, dynamic>> signup(String email, String password, String name) async {
    try {
      final conn = await DBConfig.connect();  
      final hashedPassword = _hashPassword(password);  // Hash the password

      // Check if email already exists in DB
      var result = await conn.query('SELECT id FROM users WHERE email = ?', [email]);
      if (result.isNotEmpty) {
        return {'error': 'Email already exists'};
      }

      // Insert user in DB
      await conn.query(
        'INSERT INTO users (email, password, name) VALUES (?, ?, ?)',
        [email, hashedPassword, name],
      );

      // Get User ID
      var userIdResult = await conn.query('SELECT LAST_INSERT_ID() as id');
      final userId = userIdResult.first['id'];

      conn.close();

      // Generate JWT token for new user
      final token = JwtUtils.generateToken(userId, email);

      return {'token': token};  // Return the token
    } catch (e) {
      return {'error': 'Server error'};
    }
  }

  // Handle user login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final conn = await DBConfig.connect();  // Use the existing DBConfig
      final hashedPassword = _hashPassword(password);  // Hash the password

      // Check if user exists and the password matches
      var result = await conn.query(
        'SELECT id, password FROM users WHERE email = ?',
        [email],
      );

      if (result.isEmpty) {
        return {'error': 'Invalid email or password'};
      }

      final dbPassword = result.first['password'];
      if (dbPassword != hashedPassword) {
        return {'error': 'Invalid email or password'};
      }

      final userId = result.first['id'];
      conn.close();

      // Generate JWT token for user
      final token = JwtUtils.generateToken(userId, email);

      return {'token': token};  // Return the token
    } catch (e) {
      return {'error': 'Server error'};
    }
  }
}
