import '../../../core/result.dart';
import '../../../core/storage/tokens.dart';
import '../../../services/api_client.dart';
import '../../../services/api_config.dart';
import '../../../services/endpoints.dart';
import '../../../services/mockdata.dart';
import '../model/user_profile.dart';

class AuthRepository {
  AuthRepository({ApiClient? api, TokenStorage? storage})
      : _api = api ?? ApiClient(),
        _storage = storage ?? TokenStorage();

  final ApiClient _api;
  final TokenStorage _storage;

  Future<Result<void>> login({
    required String username,
    required String password,
  }) async {
    // MOCK ONLY
    if (ApiConfig.useMockOnly) {
      await _storage.saveToken('mock-token');
      return Result.success(null);
    }

    try {
      final res = await _api.post(Endpoints.login, body: {
        'username': username,
        'password': password,
      });

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = _api.decode(res) as Map<String, dynamic>;
        final token = (data['token'] ?? '').toString();
        await _storage.saveToken(token);
        return Result.success(null);
      }
      return Result.failure('Login fehlgeschlagen: ${res.body}');
    } catch (e) {
      // FALLBACK AUF MOCK
      if (ApiConfig.useMockFallback) {
        await _storage.saveToken('mock-token');
        return Result.success(null);
      }
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> register({
    required String firstname,
    required String lastname,
    required String phone,
    required String password,
  }) async {
    if (ApiConfig.useMockOnly) return Result.success(null);

    try {
      final res = await _api.post(Endpoints.register, body: {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'password': password,
      });

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Result.success(null);
      }
      return Result.failure('Registrierung fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) return Result.success(null);
      return Result.failure(e.toString());
    }
  }

  Future<Result<User>> me() async {
    if (ApiConfig.useMockOnly) {
      return Result.success(MockData.user());
    }

    try {
      final token = await _storage.readToken();
      final res = await _api.get(Endpoints.me, token: token);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        final json = _api.decode(res);
        final data = (json['user'] ?? json) as Map<String, dynamic>;
        return Result.success(User.fromJson(data));
      }
      return Result.failure('Profil laden fehlgeschlagen: ${res.body}');
    } catch (e) {
      if (ApiConfig.useMockFallback) {
        return Result.success(MockData.user());
      }
      return Result.failure(e.toString());
    }
  }

  Future<void> logout() async => _storage.clear();
}
