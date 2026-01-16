import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session extends ChangeNotifier {
  static const _kTokenKey = 'auth_token';

  String? _token;
  String? get token => _token;

  bool get isAuthed => _token != null && _token!.isNotEmpty;

  Future<void> setToken(String? value) async {
    _token = value;
    final sp = await SharedPreferences.getInstance();
    if (value == null || value.isEmpty) {
      await sp.remove(_kTokenKey);
    } else {
      await sp.setString(_kTokenKey, value);
    }
    notifyListeners();
  }

  Future<void> restore() async {
    final sp = await SharedPreferences.getInstance();
    _token = sp.getString(_kTokenKey);
    notifyListeners();
  }

  Future<void> logout() async => setToken(null);
}
