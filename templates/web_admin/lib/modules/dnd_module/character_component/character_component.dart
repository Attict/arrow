import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'character-component',
  templateUrl: 'character_component.html',
  styleUrls: ['character_component.css'],
  directives: [
    formDirectives,
    materialInputDirectives,
    materialNumberInputDirectives,
    DropdownSelectValueAccessor,
    FocusListDirective,
    FocusItemDirective,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialSelectComponent,
    MaterialSelectItemComponent,
    MaterialSelectDropdownItemComponent,
    MaterialTooltipDirective,
    MaterialTooltipTargetDirective,
    MaterialTooltipSourceDirective,
    NgFor,
    NgIf,
    PopupSizeProviderDirective,
  ],
)
class CharacterComponent implements OnInit, OnDestroy, OnActivate {
  ///
  /// bloc
  ///
  ///
  final bloc = DndCharacterBloc();

  ///
  /// skillsChoosen
  ///
  /// FIXME:
  ///   Is this still used?
  ///
  List<DndSkill> skillsChoosen;

  ///
  /// levels
  ///
  ///
  final levels = List<int>.generate(20, (i) => i + 1);

  ///
  /// bonuses
  ///
  ///
  List<DndBonus> bonuses;
  final bonusTypes = DndBonus.typeValues();
  final bonusFrom = DndBonus.fromValues();
  Map<int, String> get bonusAttrsOnly =>
      Map.from(bonusTypes)..removeWhere((k, v) => k > DndBonus.typeCha);


  ///
  /// raceProfs
  ///
  /// Race proficiencies
  ///
  List<DndProficiency> get raceProfs => bloc.proficiencies.where(
      (i) => bloc.currentRace.proficiencyIds.contains(i.id)).toList();

  ///
  /// itemSelection
  ///
  /// Used to determine which items are selected in the selection list.
  ///
  final itemSelection = SelectionModel<DndItem>.single();

  ///
  /// itemType
  ///
  /// Control for wat types of items are shown.
  ///
  /// Use `0` for all. TODO
  ///
  int itemType = 0;
  final itemTypeValues = <int, String>{
    0: 'All',
  }..addAll(DndItem.getTypeValues());

  DndWeapon currentEquipWeapon;

  @override
  void ngOnInit() => bloc.listen((state) {
    switch (state) {
      case CoreState.saved:
        CoreApplication.instance.dialog = CoreDialog(
          title: 'Success',
          message: 'Your character was successfully saved!',
          buttons: <CoreDialogButton>[CoreDialogButton.close(label: 'Done')],
        );
        break;
      default:
    }
  });

  @override
  void ngOnDestroy() => bloc.close();

  @override
  void onActivate(_, RouterState current) {
    bloc.id = getId(current.parameters);
    bloc.add(CoreEvent.load);
  }

  void setClass(DndClass c) {
    bloc.character.baseClass = c;
    skillsChoosen = List<DndSkill>(c.numOfSkills);
  }

  void setRace(DndRace r) {
    bloc.character.raceId = r.id;
    bonuses = List<DndBonus>.generate(r.attrPoints, (i) => DndBonus());
  }

  void download() {
    final json = jsonEncode(bloc.saveCharacter());
    final data = 'data:text/json;charset=utf-8,$json';
    final a = document.createElement('a')
        ..setAttribute('href', data)
        ..setAttribute('download', 'my_character.json');
    document.body.append(a);
    a.click();
    a.remove();
  }

  void upload() {
    final InputElement i = document.createElement('input')
        ..setAttribute('type', 'file')
        ..setAttribute('accept', 'application/json')
        ..style.display = 'none';
    document.body.append(i);
    i.onChange.listen((f) {
      final d = f.target as FileUploadInputElement;
      if (d.files != null && d.files[0] != null) {
        FileReader reader = FileReader();
        reader.onLoad.listen((r) {
          final json = jsonDecode((r.target as dynamic).result);
          bloc.loadCharacter(json);
        });
        reader.readAsText(d.files[0]);
      }
    });
    i.click();
    i.remove();
  }

  void generate() {
    bloc.character.skillIds = bloc.currentSkills != null
        ? bloc.currentSkills.map<int>((i) => i?.id).toList() : null;
    bloc.generate().then((r) {
      final JsObject w = context.callMethod('open', ['about:blank', '_blank']);
      w['document'].callMethod('write', ['$r']);
      w['document'].callMethod('close');
    });
  }

  void save() => bloc.add(CoreEvent.save);

  void view() => window.location.replace('/characters/main/${bloc.id}');

  void addItem() {
    for (final i in itemSelection.selectedValues) {
      if (i.type == DndItem.typeWeapon) {
        bloc.character.weaponIds.add(i.id);
      } else if (i.type == DndItem.typeArmor) {
        bloc.character.armorIds.add(i.id);
      } else {
        bloc.character.itemIds.add(i.id);
      }
    }
  }

  String equippedArmorName() {
    if (bloc.character?.equipmentArmor != null
        && bloc.character.equipmentArmor > 0) {
      final a = bloc.armors.firstWhere(
          (i) => i.id == bloc.character.equipmentArmor, orElse: () => null);
      if (a != null) {
        return a.item.name;
      }
    }
    return null;
  }

  List<DndArmor> get equipmentArmor {
    final r = <DndArmor>[
      DndArmor(id: null, item: DndItem(name: 'None')),
    ]..addAll(bloc.armors.where((a) => bloc.character.armorIds.contains(a.id)));
    return r;
  }

  List<DndWeapon> get equipmentWeapons {
    final r = bloc.weapons.where((w)
        => bloc.character.weaponIds.contains(w.id)).toList();
    return r;
  }

  List<DndWeapon> get equippedWeapons => bloc.weapons.where(
      (i) => bloc.character.equipmentWeapons.contains(i.id)).toList();

  void equipWeapon() {
    bloc.character.equipmentWeapons.add(currentEquipWeapon.id);
    currentEquipWeapon = null;
  }

  String getWeaponName(int id) =>
      bloc.weapons.firstWhere((i) => i.id == id, orElse: () => null) ?? '';

  List<DndItem> get items {
    if (itemType > 0) {
      return bloc.allItems.where((i) => i.type == itemType).toList();
    }
    return bloc.allItems;
  }

  DndModifier createModifier(int type, int subtype, int value) =>
      DndModifier(type: type, subtype: subtype, value: value);

  final attrValues = DndModifier.attrValues;

}
