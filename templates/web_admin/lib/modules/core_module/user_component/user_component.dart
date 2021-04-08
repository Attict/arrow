import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'user-component',
  templateUrl: 'user_component.html',
  styleUrls: ['user_component.css'],
  directives: [
    formDirectives,
    materialInputDirectives,
    routerDirectives,
    DropdownSelectValueAccessor,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialSelectDropdownItemComponent,
    MaterialTooltipDirective,
    NgFor,
    NgIf,
    PopupSizeProviderDirective,
  ],
)
class UserComponent implements OnInit, OnActivate, OnDestroy {
  ///
  /// bloc
  ///
  ///
  final bloc = CoreUserBloc();

  ///
  /// form
  ///
  ///
  ControlGroup form;

  ///
  /// ngOnInit
  ///
  ///
  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.loaded:
        _createForm();
        break;
      default:
    }
  });

  ///
  /// ngOnDestroy
  ///
  ///
  @override
  void ngOnDestroy() => bloc.close();

  ///
  /// onActivate
  ///
  ///
  @override
  void onActivate(_, RouterState current) => bloc
      ..id = getId(current.parameters)
      ..add(CoreEvent.load);

  ///
  /// delete
  ///
  ///
  void delete() {}

  ///
  /// save
  ///
  ///
  void save() {}

  ///
  /// _createForm
  ///
  ///
  void _createForm() {
    form = FormBuilder.controlGroup({
      'username': Control<String>(bloc.user.username, null),
      'firstName': Control<String>(bloc.user.firstName, null),
      'lastName': Control<String>(bloc.user.lastName, null),
    });
  }
}
