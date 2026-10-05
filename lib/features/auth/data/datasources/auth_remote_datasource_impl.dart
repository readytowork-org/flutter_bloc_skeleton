import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/enum/index.dart';
import '../../domain/entities/token_entity.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;

  AuthRemoteDataSourceImpl(this._dioClient, this._storage);

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await _dioClient.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password, 'expiresInMins': 1},
    );

    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dioClient.post(ApiEndpoints.forgotPassword, data: {'email': email});
  }

  @override
  Future<TokenEntity> refreshToken(String token) async {
    final response = await _dioClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': token},
    );

    return TokenEntity(
      accessToken: response.data['accessToken'],
      refreshToken: response.data['refreshToken'],
    );
  }

  @override
  Future<TokenEntity> getCurrentSession() async {
    final accessToken = await _storage.read(
      key: SecureStorageKey.bearerToken.name,
    );
    final refreshToken = await _storage.read(
      key: SecureStorageKey.refreshToken.name,
    );
    return TokenEntity(accessToken: accessToken, refreshToken: refreshToken);
  }
}
