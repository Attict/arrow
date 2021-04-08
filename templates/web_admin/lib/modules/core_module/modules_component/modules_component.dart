import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/shared/routes.dart';
import 'package:web_admin/shared/components/table_component/table_component.dart';

@Component(
  selector: 'modules-component',
  templateUrl: 'modules_component.html',
  styleUrls: ['modules_component.css'],
  directives: [
    MaterialButtonComponent,
    MaterialInputComponent,
    NgClass,
    NgFor,
    TableComponent,
  ],
)
class ModulesComponent implements OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = CoreModulesBloc();

  ///
  /// headers
  ///
  ///
  final headers = <String, String>{
    'id': 'Id',
    'label': 'Label',
    'enabled': 'Enabled',
  };

  final Router _router;
  ModulesComponent(this._router);

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
  ///
  void goTo([CoreModule module]) {
    final url = module != null
        ? RoutePaths.coreUser.toUrl(parameters: {idParam: '${module.id}'})
        : RoutePaths.coreUser.toUrl(parameters: {idParam: 'new'});
    _router.navigateByUrl(url);
  }
}
