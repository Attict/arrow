///
/// core_role_service.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
part of core_module;

///
/// CoreRoleService
///
///
class CoreRoleService extends CoreService<CoreRole> {
  ///
  /// route
  ///
  ///
  String get route => '${CoreApplication.instance.config.api}/core/roles';

  ///
  /// createObject
  ///
  ///
  @override
  CoreRole createObject(Map<String, dynamic> data) => CoreRole.fromMap(data);
}
