import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const TokenEntity({this.accessToken, this.refreshToken});

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
