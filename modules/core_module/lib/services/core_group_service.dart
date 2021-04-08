///
/// core_group_service.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
part of core_module;

///
/// CoreGroupService
///
///
class CoreGroupService extends CoreService<CoreGroup> {
  ///
  /// route
  ///
  ///
  String get route => '${CoreApplication.instance.config.api}/core/groups';

  ///
  /// createObject
  ///
  ///
  @override
  CoreGroup createObject(Map<String, dynamic> data) => CoreGroup.fromMap(data);
}
