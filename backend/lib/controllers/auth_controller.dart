import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../services/auth_service.dart';  // Import your AuthService

class AuthController {
  final AuthService _authService = AuthService();

  // Signup User
  Future<Response> signup(Request request) async {
    try {
      // Parse request body
      final payload = jsonDecode(await request.readAsString());
      final email = payload['email'];
      final password = payload['password'];
      final name = payload['name'];

      // Check for missing input fields
      if (email == null || password == null || name == null) {
        return Response(400, body: 'Invalid input');
      }

      // Call service to handle signup
      final result = await _authService.signup(email, password, name);

      if (result['error'] != null) {
        return Response(400, body: jsonEncode(result));  // Return error if signup failed
      }

      return Response(201, body: jsonEncode(result));  // Return success with token
    } catch (e) {
      return Response(500, body: 'Server error');  // Catch unexpected errors
    }
  }

  // Login User
  Future<Response> login(Request request) async {
    try {
      // Parse request body
      final payload = jsonDecode(await request.readAsString());
      final email = payload['email'];
      final password = payload['password'];

      // Check for missing input fields
      if (email == null || password == null) {
        return Response(400, body: 'Invalid input');
      }

      // Call service to handle login
      final result = await _authService.login(email, password);

      if (result['error'] != null) {
        return Response(400, body: jsonEncode(result));  // Return error if login failed
      }

      return Response(200, body: jsonEncode(result));  // Return success with token
    } catch (e) {
      return Response(500, body: 'Server error');
    }
  }

  // Create Router for handling routes
  Router get router {
    final router = Router();
    
    // Define routes
    router.post('/signup', signup);
    router.post('/login', login);

    return router;
  }
}
