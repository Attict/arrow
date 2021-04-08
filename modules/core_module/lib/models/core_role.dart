///
/// core_role.dart
/// ~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
///
part of core_module;

///
/// CoreRole
///
///
class CoreRole implements CoreModel {
  ///
  /// id
  ///
  ///
  int id;

  ///
  /// CoreRole
  ///
  ///
  CoreRole({
    this.id,
  });

  ///
  /// CoreRole.fromMap
  ///
  ///
  factory CoreRole.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return CoreRole(
      id: data['id'],
    );
  }

  ///
  /// toMap
  ///
  ///
  Map<String, dynamic> toMap() => {
    'id': id,
  };
}
