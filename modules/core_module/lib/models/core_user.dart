///
/// core_user.dart
/// ~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
/// This is the core user model, which is the base for every user.
///
///
part of core_module;

class CoreUser implements CoreModel {
  int id;
  String username;
  String password;
  String firstName;
  String lastName;
  int groupId;
  CoreGroup group;
  int authAttempts;
  bool blocked;
  DateTime lastActivity;

  ///
  /// CoreUser
  ///
  CoreUser({
    this.id,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.groupId,
    this.group,
    this.authAttempts,
    this.blocked,
    this.lastActivity,
  });

  ///
  /// CoreUser.fromMap
  ///
  /// Convert Map to Object
  ///
  factory CoreUser.fromMap(Map<String, dynamic> map) {
    return CoreUser(
      id: map['id'],
      username: map['username'],
      password: map['password'] ?? null,
      firstName: map['firstName'],
      lastName: map['lastName'],
      groupId: map['groupId'],
      group: map['group'] != null ? CoreGroup.fromMap(map['group']) : null,
      authAttempts: map['authAttempts'],
      blocked: map['blocked'],
    );
  }

  ///
  /// toMap
  ///
  /// Convert the object to a map object, which can then be converted to JSON.
  ///
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'groupId': groupId,
      'group': group != null ? group.toMap() : null,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

}
