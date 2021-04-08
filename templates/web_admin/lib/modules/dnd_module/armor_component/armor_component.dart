import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'armor-component',
  templateUrl: 'armor_component.html',
  styleUrls: ['armor_component.css'],
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
class ArmorComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndArmorBloc();
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
          message: 'Your armor was successfully saved!',
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
    bloc.armor
        ..ac = form.controls['ac'].value
        ..reqStr = form.controls['reqStr'].value
        ..dexModMax = form.controls['dexModMax'].value;
    bloc.armor.item
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value
        ..price = form.controls['price'].value
        ..weight = form.controls['weight'].value;
    bloc.add(CoreEvent.save);
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.armor.item.name, null),
      'desc': Control<String>(bloc.armor.item.desc, null),
      'ac': Control<int>(bloc.armor.ac, null),
      'reqStr': Control<int>(bloc.armor.reqStr, null),
      'dexModMax': Control<int>(bloc.armor.dexModMax, null),
      'price': Control<int>(bloc.armor.item.price, null),
      'weight': Control<int>(bloc.armor.item.weight, null),
    });
  }
}
