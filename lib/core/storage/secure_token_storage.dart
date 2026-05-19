import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../error/exceptions.dart';
import '../utils/enum/index.dart';
import 'token_storage.dart';

final class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  String? _accessToken;
  String? _refreshToken;

  static final _accessTokenKey = SecureStorageKey.bearerToken.name;
  static final _refreshTokenKey = SecureStorageKey.refreshToken.name;

  SecureTokenStorage(this._storage);

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      _accessToken = accessToken;
      _refreshToken = refreshToken;

      await Future.wait([
        _storage.write(key: _accessTokenKey, value: accessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      throw StorageException('Failed to save tokens: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw StorageException('Failed to read access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw StorageException('Failed to read refresh token: $e');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      _accessToken = null;
      _refreshToken = null;

      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw StorageException('Failed to clear tokens: $e');
    }
  }

  @override
  Future<void> init() async {
    try {
      final results = await Future.wait([
        _storage.read(key: _accessTokenKey),
        _storage.read(key: _refreshTokenKey),
      ]);

      _accessToken = results[0];
      _refreshToken = results[1];
    } catch (e) {
      throw StorageException('Failed to initialize token storage: $e');
    }
  }

  @override
  String? get refreshToken => _refreshToken;

  @override
  String? get accessToken => _accessToken;
}
