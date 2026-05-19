import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/strings/index.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(emptyString) String username,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Factory constructor to map Firebase's User object directly into your UserModel
  factory UserModel.fromFirebase(firebase.User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? emptyString,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      username: firebaseUser.email?.split('@').first ?? emptyString,
    );
  }

  UserEntity toEntity() => UserEntity(
    uid: uid,
    email: email,
    displayName: displayName ?? emptyString,
    profileUrl: photoUrl ?? emptyString,
    username: username,
  );
}
