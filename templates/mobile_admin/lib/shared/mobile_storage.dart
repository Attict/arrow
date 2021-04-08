import 'dart:convert';
import 'package:core_module/core_module.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileStorage implements CoreStorage {
  final SharedPreferences prefs;
  MobileStorage(this.prefs);

  Map<String, dynamic> load(String name) {
    final data = prefs.getString(name);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  void save(String name, Map<String, dynamic> data)
      => prefs.setString(name, jsonEncode(data));

  void delete(String name)
      => prefs.remove(name);

  CoreToken getToken(String name) {
    final data = load(name);
    if (data != null) {
      return CoreToken.fromMap(data);
    }
    return null;
  }

  void addToken(CoreToken token) => save(token.name, token.toMap());
  void removeToken(String name) => delete(name);
}
