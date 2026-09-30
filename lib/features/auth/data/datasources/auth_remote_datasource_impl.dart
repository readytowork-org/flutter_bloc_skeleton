import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/typedf/index.dart' show JsonMap;
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> login(JsonMap user) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: user['email'] as String,
        password: user['password'] as String,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User payload missing from Firebase authentication.',
        );
      }

      return UserModel.fromFirebase(credential.user!);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred during login: $e');
    }
  }

  @override
  Future<UserModel> signup(JsonMap user) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: user['email'] as String,
        password: user['password'] as String,
      );

      if (credential.user == null) {
        throw FirebaseAuthException(
          code: 'missing-user',
          message: 'User payload missing from Firebase registration.',
        );
      }

      // If a display name is provided in the map, update the Firebase profile
      if (user.containsKey('displayName') && user['displayName'] != null) {
        await credential.user!.updateDisplayName(user['displayName'] as String);
        // Reload to accurately refresh the cached currentUser profile data
        await credential.user!.reload();
      }

      final updatedUser = _firebaseAuth.currentUser ?? credential.user!;
      return UserModel.fromFirebase(updatedUser);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('An unexpected error occurred during signup: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentSession() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel.fromFirebase(currentUser);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to retrieve current user session: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to log out from Firebase session: $e');
    }
  }
}
