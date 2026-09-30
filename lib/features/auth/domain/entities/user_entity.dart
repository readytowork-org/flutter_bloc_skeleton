import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String displayName;
  final String profileUrl;
  final String username;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.profileUrl,
    required this.username,
  });

  @override
  List<Object?> get props => [uid, email, displayName, profileUrl, username];
}
