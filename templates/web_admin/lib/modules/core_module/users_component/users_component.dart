import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/shared/routes.dart';
import 'package:web_admin/shared/components/table_component/table_component.dart';

@Component(
  selector: 'users-component',
  templateUrl: 'users_component.html',
  styleUrls: ['users_component.css'],
  directives: [
    MaterialButtonComponent,
    MaterialInputComponent,
    NgClass,
    NgFor,
    TableComponent,
  ],
)
class UsersComponent implements OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = CoreUsersBloc();

  ///
  /// headers
  ///
  ///
  final headers = <String, String>{
    'id': 'Id',
    'username': 'Username',
    'firstName': 'First Name',
    'lastName': 'Last Name',
  };

  final Router _router;
  UsersComponent(this._router);

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
  void goTo([CoreUser user]) {
    final url = user != null
        ? RoutePaths.coreUser.toUrl(parameters: {idParam: '${user.id}'})
        : RoutePaths.coreUser.toUrl(parameters: {idParam: 'new'});
    _router.navigateByUrl(url);
  }

  ///
  /// delete
  ///
  ///
  void delete(List<dynamic> u) {
    bloc.selected = List<CoreUser>.from(u);
    bloc.add(CoreEvent.delete);
  }
}
