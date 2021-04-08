import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/shared/routes.dart';
import 'package:web_admin/shared/components/table_component/table_component.dart';

@Component(
  selector: 'groups-component',
  templateUrl: 'groups_component.html',
  styleUrls: ['groups_component.css'],
  directives: [
    routerDirectives,
    MaterialButtonComponent,
    MaterialInputComponent,
    NgClass,
    NgFor,
    TableComponent,
  ],
)
class GroupsComponent implements OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = CoreGroupsBloc();

  ///
  /// headers
  ///
  /// Stored by a String, String map, where the key is the mapped key value,
  /// for sorting, and the value is the label to be shown.
  ///
  final headers = <String, String>{
    'id': 'Id',
    'label': 'Label',
    'authority': 'Authority', // TODO: Weight
  };

  final Router _router;
  GroupsComponent(this._router);

  ///
  /// onActivate
  ///
  ///
  @override
  void onActivate(_, __) => bloc.add(CoreEvent.load);

  ///
  /// ngOnDestroy
  ///
  ///
  @override
  void ngOnDestroy() => bloc.close();

  ///
  /// goTo
  ///
  /// FIXME: Url is for user.
  ///
  String goTo([CoreGroup group]) {
    final url = group != null
        ? RoutePaths.coreUser.toUrl(parameters: {idParam: '${group.id}'})
        : RoutePaths.coreUser.toUrl(parameters: {idParam: 'new'});
    _router.navigateByUrl(url);
  }

  ///
  /// delete
  ///
  ///
  void delete(List<CoreGroup> groups) {
  }
}
