import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/data/models/user_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  // Passing FirebaseAuth allows easy mocking in your profile data source tests
  ProfileRemoteDataSourceImpl(this._firebaseAuth);
  @override
  Future<UserModel> getProfile() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null) {
        // Map the live Firebase User object into your existing UserModel
        return UserModel.fromFirebase(currentUser);
      } else {
        throw FirebaseAuthException(
          code: 'no-user-session',
          message: 'Failed to fetch profile: No active user session found.',
        );
      }
    } catch (e) {
      throw Exception('An error occurred while fetching the profile: $e');
    }
  }
}
