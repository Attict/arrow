///
/// core_module_service.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric@attict.net>
///
part of core_module;

///
/// CoreModuleService
///
///
class CoreModuleService extends CoreService<CoreModule> {
  ///
  /// route
  ///
  ///
  String get route => '${CoreApplication.instance.config.api}/core/modules';

  ///
  /// createObject
  ///
  ///
  @override
  CoreModule createObject(Map<String, dynamic> data) => CoreModule.fromMap(data);
}
