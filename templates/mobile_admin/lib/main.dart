import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_module/core_module.dart';

import 'package:mobile_admin/shared/mobile_storage.dart';
import 'package:mobile_admin/layouts/main_layout.dart';
import 'package:mobile_admin/dashboard.dart';

import 'package:mobile_admin/modules/core_module/authentication_component/authentication_component.dart';
import 'package:mobile_admin/modules/core_module/module_component/module_component.dart';
import 'package:mobile_admin/modules/core_module/modules_component/modules_component.dart';
import 'package:mobile_admin/modules/core_module/role_component/role_component.dart';
import 'package:mobile_admin/modules/core_module/roles_component/roles_component.dart';
import 'package:mobile_admin/modules/core_module/user_component/user_component.dart';
import 'package:mobile_admin/modules/core_module/users_component/users_component.dart';
import 'package:mobile_admin/modules/core_module/profile_component/profile_component.dart';
import 'package:mobile_admin/modules/core_module/settings_component/settings_component.dart';

import 'package:mobile_admin/modules/acp_module/compliance_item_component/compliance_item_component.dart';
import 'package:mobile_admin/modules/acp_module/compliance_items_component/compliance_items_component.dart';
import 'package:mobile_admin/modules/acp_module/forms_component/forms_component.dart';
import 'package:mobile_admin/modules/acp_module/form_component/form_component.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final p = await SharedPreferences.getInstance();
  CoreApplication.instance.storage = MobileStorage(p);
  CoreApplication.instance.config = CoreConfig(api: 'https://acpdev.kapioshealth.com/api');
  CoreApplication.instance.init();
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anteater',
      theme: ThemeData(
        primaryColor: Color(0xFF1A577E),
        primaryColorLight: Color(0xFF3A778E),
        primaryColorDark: Color(0xFF0A476E),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF3A778E),
        ),
        //brightness: Brightness.dark,
      ),
      home: AuthenticationComponent(),
      //routes: <String, WidgetBuilder> {
      //  '/dashboard': (BuildContext context)
      //      => MainLayout(DashboardPage(), title: 'Dashboard'),
      //  '/users': (BuildContext context)
      //      => MainLayout(UsersPage(), title: 'Users'),
      //  '/user': (BuildContext context)
      //      => MainLayout(UserPage()),
      //},
      onGenerateRoute: (RouteSettings settings) {
        final routes = <String, WidgetBuilder> {
          '/dashboard': (BuildContext context)
              => MainLayout(DashboardPage(), title: 'Dashboard'),
          '/module': (BuildContext context)
              => MainLayout(ModuleComponent(settings.arguments)),
          '/modules': (BuildContext context)
              => MainLayout(ModulesComponent(), title: 'Modules'),
          '/role': (BuildContext context)
              => MainLayout(RoleComponent(settings.arguments), title: 'Role'),
          '/roles': (BuildContext context)
              => MainLayout(RolesComponent(), title: 'Roles'),
          '/user': (BuildContext context)
              => MainLayout(UserComponent(settings.arguments), title: 'User'),
          '/users': (BuildContext context)
              => MainLayout(UsersComponent(), title: 'Users'),
          '/profile': (BuildContext context)
              => MainLayout(ProfileComponent(), title: 'Profile'),
          '/settings': (BuildContext context)
              => MainLayout(SettingsComponent(), title: 'Settings'),
          '/acp/compliance/items': (BuildContext context)
              => MainLayout(ComplianceItemsComponent(), title: 'Compliance Items'),
          '/acp/compliance/item': (BuildContext context)
              => MainLayout(ComplianceItemComponent(settings.arguments), title: 'Compliance Items'),
          '/acp/forms': (BuildContext context)
              => MainLayout(FormsComponent(), title: 'Forms'),
          '/acp/form': (BuildContext context)
              => MainLayout(FormComponent(settings.arguments), title: 'Form'),


          //'/roles': (BuildContext context)
          //    => MainLayout(RolesPage(), title: 'Roles'),
          //'/role': (BuildContext context)
          //    => MainLayout(RolePage(settings.arguments)),
          //'/users': (BuildContext context)
          //    => MainLayout(UsersPage(), title: 'Users'),
          //'/user': (BuildContext context)
          //    => MainLayout(UserPage(settings.arguments)),
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (context) => builder(context));
      },
    );
  }
}

