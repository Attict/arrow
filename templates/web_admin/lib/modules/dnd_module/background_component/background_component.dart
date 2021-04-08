import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'background-component',
  templateUrl: 'background_component.html',
  styleUrls: ['background_component.css'],
  directives: [
    formDirectives,
    materialInputDirectives,
    materialNumberInputDirectives,
    routerDirectives,
    DropdownSelectValueAccessor,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialSelectDropdownItemComponent,
    MaterialTooltipDirective,
    NgClass,
    NgFor,
    NgIf,
    PopupSizeProviderDirective,
  ],
)
class BackgroundComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndBackgroundBloc();
  ControlGroup form;

  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.loaded:
        _createForm();
        break;
      case CoreState.saved:
        CoreApplication.instance.dialog = CoreDialog(
          title: 'Success',
          message: 'Your background was successfully saved!',
          buttons: <CoreDialogButton>[CoreDialogButton.close(label: 'Done')],
        );
        break;
      default:
    }
  });

  @override
  void onActivate(_, RouterState current) {
    bloc.id = getId(current.parameters);
    bloc.add(CoreEvent.load);
  }

  @override
  void ngOnDestroy() => bloc.close();

  void delete() => null;

  void save() {
    bloc.background
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value;

    bloc.add(CoreEvent.save);
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.background.name, null),
      'desc': Control<String>(bloc.background.desc, null),
    });
  }
}
