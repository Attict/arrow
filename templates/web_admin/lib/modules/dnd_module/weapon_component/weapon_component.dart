import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'weapon-component',
  templateUrl: 'weapon_component.html',
  styleUrls: ['weapon_component.css'],
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
class WeaponComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndWeaponBloc();
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
          message: 'Your weapon was successfully saved!',
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
    bloc.weapon
        ..minDmg = form.controls['minDmg'].value
        ..maxDmg = form.controls['maxDmg'].value
        ..minRange = form.controls['minRange'].value
        ..maxRange = form.controls['maxRange'].value;
    bloc.weapon.item
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value
        ..price = form.controls['price'].value
        ..weight = form.controls['weight'].value;

    bloc.add(CoreEvent.save);
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.weapon.item.name, null),
      'desc': Control<String>(bloc.weapon.item.desc, null),
      'minDmg': Control<int>(bloc.weapon.minDmg, null),
      'maxDmg': Control<int>(bloc.weapon.maxDmg, null),
      'minRange': Control<int>(bloc.weapon.minRange, null),
      'maxRange': Control<int>(bloc.weapon.maxRange, null),
      'price': Control<int>(bloc.weapon.item.price, null),
      'weight': Control<int>(bloc.weapon.item.weight, null),
    });
  }
}
