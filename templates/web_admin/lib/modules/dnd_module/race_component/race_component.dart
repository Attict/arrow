import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'race-component',
  templateUrl: 'race_component.html',
  styleUrls: ['race_component.css'],
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
  ]
)
class RaceComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndRaceBloc();
  ControlGroup form;
  final levels = List<int>.generate(20, (i) => i + 1);
  List<bool> featsCollapsed;

  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.loaded:
        _createForm();
        featsCollapsed = List<bool>.generate(bloc.race.feats.length, (i) => true);
        break;
      case CoreState.saved:
        CoreApplication.instance.dialog = CoreDialog(
          title: 'Success',
          message: 'Your race was successfully saved!',
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
    bloc.race.feats.add(DndFeat());
    featsCollapsed.add(false);
  }

  void removeFeat(int i) {
    bloc.race.feats.removeAt(i);
    featsCollapsed.removeAt(i);
  }

  void delete() => null;

  void save() {
    bloc.race
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value
        ..speed = form.controls['speed'].value
        ..strength = form.controls['str'].value
        ..dexterity = form.controls['dex'].value
        ..constitution = form.controls['con'].value
        ..intelligence = form.controls['int'].value
        ..wisdom = form.controls['wis'].value
        ..charisma = form.controls['cha'].value
        ..attrPoints = form.controls['attrPoints'].value
        ..featPoints = form.controls['featPoints'].value;

    bloc.add(CoreEvent.save);
  }

  String getProficiencyName(int i) {
    if (bloc.race.proficiencyIds[i] > 0) {
      return bloc.proficiencies.firstWhere(
          (p) => p.id == bloc.race.proficiencyIds[i], orElse: () => null)?.name;
    }

    return null;
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.race.name, null),
      'desc': Control<String>(bloc.race.desc, null),
      'speed': Control<int>(bloc.race.speed, null),
      'str': Control<int>(bloc.race.strength, null),
      'dex': Control<int>(bloc.race.dexterity, null),
      'con': Control<int>(bloc.race.constitution, null),
      'int': Control<int>(bloc.race.intelligence, null),
      'wis': Control<int>(bloc.race.wisdom, null),
      'cha': Control<int>(bloc.race.charisma, null),
      'attrPoints': Control<int>(bloc.race.attrPoints, null),
      'featPoints': Control<int>(bloc.race.featPoints, null),
      'langPoints': Control<int>(bloc.race.langPoints, null),
    });
  }
}
