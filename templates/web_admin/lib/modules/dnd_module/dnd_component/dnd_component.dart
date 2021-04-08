import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:web_admin/shared/routes.dart';

@Component(
  selector: 'dnd-component',
  templateUrl: 'dnd_component.html',
  styleUrls: ['dnd_component.css'],
  directives: [
    routerDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
  exports: [RoutePaths],
)
class DndComponent implements OnInit {
  @override
  void ngOnInit() {

  }
}
