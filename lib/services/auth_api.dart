import '../session_store.dart';
import 'api_client.dart';
import '../model/user_profile.dart';

class AuthApi {
  final ApiClient _api;
  final Session _session;

  AuthApi(this._api, this._session);

  /// Erwartet: { token: "...", user: {...} }
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final j = await _api.postJson(
      '/auth/login',
      body: {
        'username': username,
        'password': password,
      },
    );

    final token = (j['token'] ?? '').toString();
    if (token.isNotEmpty) {
      await _session.setToken(token);
    }

    final userJson = (j['user'] ?? {}) as Map<String, dynamic>;
    return User.fromJson(userJson);
  }

  Future<void> register({
    required String firstname,
    required String lastname,
    required String phone,
    required String password,
  }) async {
    await _api.postJson(
      '/auth/register',
      body: {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'password': password,
      },
    );
  }

  Future<User> getMe() async {
    final j = await _api.getJson('/me', token: _session.token);
    final u = (j['user'] ?? j) as Map<String, dynamic>;
    return User.fromJson(u);
  }

  Future<User> updateMe(User u) async {
    final j = await _api.putJson(
      '/me',
      token: _session.token,
      body: u.toJson(),
    );
    final out = (j['user'] ?? j) as Map<String, dynamic>;
    return User.fromJson(out);
  }
}
