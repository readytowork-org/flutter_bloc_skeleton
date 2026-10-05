import 'package:equatable/equatable.dart';

import '../../../../core/utils/index.dart';

class UserEntity extends Equatable {
  final String username;
  final String email;
  final String fullname;
  final String firstName;
  final String lastName;
  final String gender;
  final String profile;
  final String? accessToken;
  final String? refreshToken;

  const UserEntity({
    this.username = emptyString,
    this.email = emptyString,
    this.fullname = emptyString,
    this.firstName = emptyString,
    this.lastName = emptyString,
    this.gender = emptyString,
    this.profile = emptyString,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [
    username,
    email,
    fullname,
    gender,
    profile,
    accessToken,
    refreshToken,
    firstName,
    lastName,
  ];
}
