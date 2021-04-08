import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/model/menu/menu.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_router/angular_router.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/modules/core_module/authentication_component/authentication_component.dart';
import 'package:web_admin/shared/routes.dart';


@Component(
  selector: 'main-layout',
  templateUrl: 'main_layout.html',
  styleUrls: ['main_layout.css'],
  directives: [
    routerDirectives,
    AuthenticationComponent,
    AutoFocusDirective,
    ClickableTooltipTargetDirective,
    DeferredContentDirective,
    DropdownMenuComponent,
    MaterialButtonComponent,
    MaterialDialogComponent,
    MaterialIconComponent,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialMenuComponent,
    MaterialPersistentDrawerDirective,
    MaterialProgressComponent,
    MaterialTooltipDirective,
    MaterialTooltipTargetDirective,
    MaterialTooltipSourceDirective,
    ModalComponent,
    NgFor,
    NgIf,
  ],
  exports: [
    RoutePaths,
    Routes,
  ],
  providers: [
    popupBindings,
  ],
)
class MainLayout implements OnInit {
  final title = 'Dnd';
  final app = CoreApplication.instance;
  MenuModel<MenuItem> menuItem;
  final Router _router;
  bool loading = false;

  MainLayout(this._router) {
    menuItem = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('My Profile', tooltip: 'Edit your User Profile', action: () {
          _router.navigateByUrl(RoutePaths.dndCharacter.toUrl());
        }),
        MenuItem('My Settings', tooltip: 'Change your User Settings'),
      ], 'User'),
      MenuItemGroup<MenuItem>([
        MenuItem('Change to Dark Theme', tooltip: 'Using dark colors', action: () {}),
        MenuItem('Sign Out', action: app.logout),
      ]),
    ], icon: Icon('person'));
  }

  @override
  void ngOnInit() {
    CoreApplication.instance.listen((state) {
      switch (state) {
        case CoreState.loading:
          loading = true;
          break;
        case CoreState.loaded:
          loading = false;
          break;
        default:
      }
    });
  }
}
