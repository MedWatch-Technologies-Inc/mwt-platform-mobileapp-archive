import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  SharedPreferences? _preferences;

  static final PreferencesUtil _instance = PreferencesUtil._();

  factory PreferencesUtil() {
    return _instance;
  }

  PreferencesUtil._();

  Future<SharedPreferences> _getPref() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<bool> containsKey(String key) async {
    var preferences = await _getPref();
    return preferences.containsKey(key);
  }


  Future<dynamic> get(String key) async {
    var preferences = await _getPref();
    return preferences.get(key);
  }


  Future<bool> getBool(String key, {required bool defaultValue}) async {
    var preferences = await _getPref();
    return preferences.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, {bool? value}) async {
    var preferences = await _getPref();
    if (value == null) {
      await remove(key);
    } else {
      await preferences.setBool(key, value);
    }
  }

  Future<String> getString(String key, {required String defaultValue}) async {
    var preferences = await _getPref();
    return preferences.getString(key) ?? defaultValue;
  }

  Future<void> setString(String key, {String? value}) async {
    var preferences = await _getPref();
    if (value == null) {
      await remove(key);
    } else {
      await preferences.setString(key, value);
    }
  }

  Future<List<String>> getStringList(String key,
      {required List<String> defaultValue}) async {
    var preferences = await _getPref();
    return preferences.getStringList(key) ?? defaultValue;
  }

  Future<void> setStringList(String key, {List<String>? value}) async {
    var preferences = await _getPref();
    if (value == null) {
      await remove(key);
    } else {
      await preferences.setStringList(key, value);
    }
  }

  Future<int> getInt(String key, {required int defaultValue}) async {
    var preferences = await _getPref();
    return preferences.getInt(key) ?? defaultValue;
  }

  Future<void> setInt(String key, {int? value}) async {
    var preferences = await _getPref();
    if (value == null) {
      await remove(key);
    } else {
      await preferences.setInt(key, value);
    }
  }

  Future<double> getDouble(String key, {required double defaultValue}) async {
    var preferences = await _getPref();
    return preferences.getDouble(key) ?? defaultValue;
  }

  Future<void> setDouble(String key, {double? value}) async {
    var preferences = await _getPref();
    if (value == null) {
      await remove(key);
    } else {
      await preferences.setDouble(key, value);
    }
  }

  Future<bool> remove(String key) async {
    var preferences = await _getPref();
    if (preferences.containsKey(key)) {
      return await preferences.remove(key);
    } else {
      return true;
    }
  }

  Future<void> clearAll() async {
    var preferences = await _getPref();
    preferences.clear();
  }

  /// Use this method to observe modifications that were made in native code
  Future<void> reload() async {
    var preferences = await _getPref();
    return preferences.reload();
  }
}
