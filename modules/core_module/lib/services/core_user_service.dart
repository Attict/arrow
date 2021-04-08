///
/// core_user_service.dart
/// ~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
part of core_module;

///
/// CoreUserService
///
///
class CoreUserService extends CoreService<CoreUser> {
  ///
  /// route
  ///
  ///
  String get route => '${CoreApplication.instance.config.api}/core/users';

  ///
  /// createObject
  ///
  ///
  @override
  CoreUser createObject(Map<String, dynamic> data) => CoreUser.fromMap(data);
}
