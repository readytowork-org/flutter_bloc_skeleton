import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthTokenSource {
  Future<String?> getValidToken();
}

class FirebaseAuthTokenSource implements AuthTokenSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String?> getValidToken() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Automatically fetches cached token or refreshes it if expired
        return await user.getIdToken();
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
