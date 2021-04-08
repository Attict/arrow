///
/// core_group.dart
/// ~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
/// This is the core group model, which is the base for every group,
/// and it's associated permissions.
///
///
part of core_module;

class CoreGroup implements CoreModel {
  int id;
  String label;
  int authority;
  List<CorePermission> permissions;

  ///
  /// Constructor
  ///
  CoreGroup({
    this.id,
    this.label,
    this.authority,
    this.permissions,
  });

  ///
  /// Convert Map to Object
  ///
  factory CoreGroup.fromMap(Map<String, dynamic> map) {
    return CoreGroup(
      id: map['id'],
      label: map['label'],
      authority: map['authority'],
      //permissions: permFromListMap(map['permissions']),
    );
  }

  ///
  /// Convert the object to a map object, which can then be converted to JSON.
  ///
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'authority': authority,
      'permissions': permToListMap(),
    };
  }

  ///
  /// Gets permission from a list of mapped objects
  ///
  /// Static so that the constructor can use it.
  ///
  static List<CorePermission> permFromListMap(List<Map<String, dynamic>> map) {
    return map != null
      ? map.map<CorePermission>((i) => CorePermission.fromMap(i)).toList()
      : null;
  }

  ///
  /// Permission list to a mapped object for json encoding.
  ///
  List<Map<String, dynamic>> permToListMap() {
    return permissions != null
      ? permissions.map<Map<String, dynamic>>((p) => p.toMap()).toList()
      : null;
  }
}
