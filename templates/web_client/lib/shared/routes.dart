import 'package:angular_router/angular_router.dart';

import 'package:web_client/shared/route_paths.dart';
export 'package:web_client/shared/route_paths.dart';

import 'package:web_client/pages/homepage_component/homepage_component.template.dart' as homepage_template;

///
/// Routes
///
/// *In alphabetical order.*
///
class Routes {
  static final homepage = RouteDefinition(
    routePath: RoutePaths.homepage,
    component: homepage_template.HomepageComponentNgFactory,
  );
  static final all = <RouteDefinition>[
    homepage,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.homepage.toUrl(),
    ),
  ];
}
