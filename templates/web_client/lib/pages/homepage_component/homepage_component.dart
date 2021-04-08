import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_client/shared/route_paths.dart';

@Component(
  selector: 'homepage-component',
  templateUrl: 'homepage_component.html',
  styleUrls: ['homepage_component.css'],
  directives: [
    coreDirectives,
    routerDirectives,
  ],
  exports: [RoutePaths],
)
class HomepageComponent {
  final Router _router;
  HomepageComponent(this._router);
}
