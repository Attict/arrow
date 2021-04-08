part of core_module;

class CorePermission {
  int moduleId;
  int groupId;
  int read;
  int create;
  int update;
  int delete;

  ///
  /// Constructor
  ///
  CorePermission({
    this.moduleId,
    this.groupId,
    this.read,
    this.create,
    this.update,
    this.delete,
  });

  ///
  /// From map
  ///
  factory CorePermission.fromMap(Map<String, dynamic> map) {
    return CorePermission(
      moduleId: map['moduleId'],
      groupId: map['groupId'],
      read: map['read'],
      create: map['create'],
      update: map['update'],
      delete: map['delete'],
    );
  }

  ///
  /// To Map
  ///
  Map<String, dynamic> toMap() {
    return {
      'moduleId': moduleId,
      'groupId': groupId,
      'read': read,
      'create': create,
      'update': update,
      'delete': delete,
    };
  }
}
