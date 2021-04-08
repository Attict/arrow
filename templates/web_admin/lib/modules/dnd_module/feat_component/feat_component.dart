import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'feat-component',
  templateUrl: 'feat_component.html',
  styleUrls: ['feat_component.css'],
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
  exports: [
    DndModifier,
  ],
)
class FeatComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndFeatBloc();
  ControlGroup form;

  final levels = List<int>.generate(20, (i) => i + 1);

  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.loaded:
        _createForm();
        break;
      case CoreState.saved:
        CoreApplication.instance.dialog = CoreDialog(
          title: 'Success',
          message: 'Your feat was successfully saved!',
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
    bloc.feat
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value;

    bloc.add(CoreEvent.save);
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.feat.name, null),
      'desc': Control<String>(bloc.feat.desc, null),
    });
  }
}
