import 'package:core_module/core_module.dart';

class ServiceProvider {
  static final instance = ServiceProvider._private();
  factory ServiceProvider() => instance;
  ServiceProvider._private();

  final moduleService = MockModuleService();
  final roleService = MockRoleService();
  final userService = MockUserService();
  final authService = MockAuthenticationService();
  final permissionService = MockPermissionService();
}
