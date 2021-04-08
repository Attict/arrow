///
/// core_storage.dart
/// ~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
/// Created:
///
///
part of core_module;

///
/// CoreStorage
///
/// Controls how the application stores information, such as tokens,
/// user information, and any other data.  This is an abstract
/// implementation, which needs to be implemented at the application
/// level as a sub-class, so that these functions are defined specific.
///
abstract class CoreStorage {
  ///
  /// load
  ///
  /// Responsible for loading data from the application storage, into
  /// a map, which can then be transformed into an object.
  ///
  Map<String, dynamic> load(String name);

  ///
  /// save
  ///
  /// Responsible for saving data into the application storage.  Data
  /// should be in the form of a map.
  ///
  void save(String name, Map<String, dynamic> data);

  ///
  /// delete
  ///
  /// Responsible for deleting data from the application storage by
  /// name.
  ///
  void delete(String name);

  ///
  /// getToken
  ///
  /// Responsible for getting a token from storage by name.
  ///
  CoreToken getToken(String name);

  ///
  /// addToken
  ///
  /// Responsible for adding a token to the proper storage for tokens.
  ///
  void addToken(CoreToken token);

  ///
  /// removeToken
  ///
  /// Responsible for removing a token from the storage by name.
  ///
  void removeToken(String name);
}
