import 'package:angular_router/angular_router.dart';

const idParam = 'id';

///
/// RoutePaths
///
/// The defined routes for the application used in the URL.
///
class RoutePaths {
  static final homepage = RoutePath(path: 'homepage');
}

int getId(Map<String, String> parameters) {
  final id = parameters[idParam];
  return id == null ? null : int.tryParse(id);
}
