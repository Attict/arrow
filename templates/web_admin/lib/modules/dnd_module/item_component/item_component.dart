import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:dnd_module/dnd_module.dart';
import 'package:web_admin/shared/route_paths.dart';

@Component(
  selector: 'item-component',
  templateUrl: 'item_component.html',
  styleUrls: ['item_component.css'],
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
class ItemComponent implements OnInit, OnActivate, OnDestroy {
  final bloc = DndItemBloc();
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
          message: 'Your item was successfully saved!',
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
    bloc.item
        ..name = form.controls['name'].value
        ..desc = form.controls['desc'].value
        ..price = form.controls['price'].value
        ..weight = form.controls['weight'].value;

    bloc.add(CoreEvent.save);
  }

  void _createForm() {
    form = FormBuilder.controlGroup({
      'name': Control<String>(bloc.item.name, null),
      'desc': Control<String>(bloc.item.desc, null),
      'price': Control<int>(bloc.item.price, null),
      'weight': Control<int>(bloc.item.weight, null),
    });
  }
}
