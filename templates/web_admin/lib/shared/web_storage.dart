import 'dart:convert';
import 'dart:html';
import 'package:core_module/core_module.dart';

///
/// WebStorage
///
/// Uses web `localStorage` to manage data.
///
class WebStorage implements CoreStorage {
  ///
  /// load
  ///
  /// Responsible for loading data from the application storage, into
  /// a map, which can then be transformed into an object.
  ///
  @override
  Map<String, dynamic> load(String name) {
    final r = window.localStorage[name];
    if (r != null) {
      return jsonDecode(r);
    }
    return null;
  }

  ///
  /// save
  ///
  /// Responsible for saving data into the application storage.  Data
  /// should be in the form of a map.
  ///
  void save(String name, Map<String, dynamic> data) {
    window.localStorage[name] = jsonEncode(data);
  }

  ///
  /// delete
  ///
  /// Responsible for deleting data from the application storage by
  /// name.
  ///
  void delete(String name) {
    window.localStorage.remove(name);
  }

  ///
  /// getToken
  ///
  /// Responsible for getting a token from storage by name.
  ///
  CoreToken getToken(String name) {
    final pattern = RegExp('$name=[^;]+');
    final m = pattern.firstMatch(document.cookie);
    if (m != null) {
      return CoreToken.fromString(m[0]);
    }
    return null;
  }

  ///
  /// addToken
  ///
  /// Responsible for adding a token to the proper storage for tokens.
  ///
  void addToken(CoreToken token) {
    document.cookie = token.formatted();
  }

  ///
  /// removeToken
  ///
  /// Responsible for removing a token from the storage by name.
  ///
  void removeToken(String name) {
    document.cookie = CoreToken.empty(name);
  }
}
