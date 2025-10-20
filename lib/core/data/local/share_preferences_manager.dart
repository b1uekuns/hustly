import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  SharedPreferencesManager() {
    SharedPreferences.getInstance().then((value) {
      _sharedPreferences = value;
    });
  }

  Future<void> saveAccessToken(String token) async {
    await _sharedPreferences.setString('access_token', token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _sharedPreferences.setString('refresh_token', token);
  }

  Future<String?> getAccessToken() async {
    return _sharedPreferences.getString('access_token');
  }

  Future<String?> getRefreshToken() async {
    return _sharedPreferences.getString('refresh_token');
  }

  Set<String> getKeys() {
    return _sharedPreferences.getKeys();
  }

  Future<bool> putString({required String key, required String value}) =>
      _sharedPreferences.setString(key, value);

  Future<bool> putStringList({
    required String key,
    required List<String> value,
  }) => _sharedPreferences.setStringList(key, value);
  String? getString(String key) => _sharedPreferences.getString(key);
  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  Future<bool> putInt({required String key, required int value}) =>
      _sharedPreferences.setInt(key, value);
  int? getInt(String key) => _sharedPreferences.getInt(key);

  Future<bool> putBool({required String key, required bool value}) =>
      _sharedPreferences.setBool(key, value);
  bool? getBool(String key) => _sharedPreferences.getBool(key);

  Future<bool> putDouble({required String key, required double value}) =>
      _sharedPreferences.setDouble(key, value);
  double? getDouble(String key) => _sharedPreferences.getDouble(key);

  Future remove(String key) => _sharedPreferences.remove(key);

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}
