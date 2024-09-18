import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtUtils {
  static const String _secretKey = 'your_secret_key';  // Use a strong secret key

  // Generate JWT token
  static String generateToken(int userId, String email) {
    final claimSet = JwtClaim(
      subject: email,
      issuer: 'alumni-platform',
      otherClaims: <String, dynamic>{
        'userId': userId,
      },
      maxAge: const Duration(hours: 24),  // Token valid for 24 hours
    );

    return issueJwtHS256(claimSet, _secretKey);
  }

  // Verify JWT token (optional, in case you need to validate the token later)
  static JwtClaim verifyToken(String token) {
    return verifyJwtHS256Signature(token, _secretKey);
  }
}
