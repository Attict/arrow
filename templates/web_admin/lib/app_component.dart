import 'dart:html';
import 'package:angular/angular.dart';
import 'package:core_module/core_module.dart';
import 'package:web_admin/layouts/main_layout/main_layout.dart';
import 'package:web_admin/shared/web_storage.dart';
import 'package:http/browser_client.dart';

@Component(
  directives: [MainLayout],
  selector: 'app-component',
  template: '<main-layout></main-layout>'
)
class AppComponent implements OnInit {
  @override
  void ngOnInit() {
    // Development while on this port
    if (window.location.port == '4900') {
      CoreApplication.instance.config = CoreConfig(
        environment: CoreEnvironment.development,
        api: 'http://localhost:8500/api',
        storage: WebStorage(),
        client: BrowserClient()..withCredentials = true,
      );
    } else {
      CoreApplication.instance.config = CoreConfig(
        storage: WebStorage(),
      );
    }
    CoreApplication.instance.init();
  }

}
