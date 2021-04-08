import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'class-component',
  templateUrl: 'class_component.html',
  styleUrls: ['class_component.css'],
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
    DndFeat,
    DndModifier,
  ],
)
class ClassComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndClassBloc();
  ControlGroup form;
  final levels = List<int>.generate(20, (i) => i + 1);
  List<bool> featsCollapsed;

  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.loaded:
        _createForm();
        featsCollapsed = List<bool>.generate(bloc.c.feats.length, (i) => true);
        break;
      case CoreState.saved:
        CoreApplication.instance.dialog = CoreDialog(
          title: 'Success',
          message: 'Your class was successfully saved!',
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

  void addFeat() {
    bloc.c.feats.add(DndFeat());
    featsCollapsed.add(false);
  }

  void removeFeat(int i) {
    bloc.c.feats.removeAt(i);
    featsCollapsed.removeAt(i);
  }

  void delete() => null;

  void save() {
    bloc.c
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value
        ..numOfSkills = form.controls['numOfSkills'].value;

    bloc.add(CoreEvent.save);
  }

  String getProficiencyName(int i) {
    if (bloc.c.proficiencyIds[i] > 0) {
      return bloc.proficiencies.firstWhere(
          (p) => p.id == bloc.c.proficiencyIds[i], orElse: () => null)?.name;
    }
    return null;
  }


  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.c.name, null),
      'desc': Control<String>(bloc.c.desc, null),
      'numOfSkills': Control<int>(bloc.c.numOfSkills, null),
    });
  }
}
