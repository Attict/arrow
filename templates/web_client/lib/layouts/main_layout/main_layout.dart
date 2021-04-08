import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:core_module/core_module.dart';

import 'package:web_client/shared/route_paths.dart';
import 'package:web_client/shared/routes.dart';

@Component(
  selector: 'main-layout',
  templateUrl: 'main_layout.html',
  styleUrls: ['main_layout.css'],
  directives: [
    coreDirectives,
    formDirectives,
    routerDirectives,
  ],
  exports: [RoutePaths, Routes],
)
class MainLayout implements OnInit {
  final title = 'Website';

  @ViewChild('header')
  Element header;

  @ViewChild('headerNav')
  Element headerNav;

  @ViewChild('headerUser')
  Element headerUser;

  @ViewChild('toTop')
  Element toTop;

  @ViewChild('contactPopup')
  Element contactPopup;

  final app = CoreApplication.instance;
  //ContactSingleController contactController = ContactSingleController();

  final Router _router;
  MainLayout(this._router);

  bool get isLoggedIn => CoreApplication.instance.user != null;

  @override
  void ngOnInit() {
    _router.onRouteActivated.listen((_) {
      headerUser.classes.remove('active');
      window.scrollTo(0, 0);
    });

    document.addEventListener('scroll', _onDocumentScroll);
  }

  void _onDocumentScroll(Event e) {
    final scrollTop = document.scrollingElement.scrollTop;
    final topHeight = 60;

    if (scrollTop > 60) {
      header.classes.add('fixed');
      toTop.classes.add('active');
    } else {
      if (header.classes.contains('fixed')) {
        header.classes.remove('fixed');
      }
      if (toTop.classes.contains('active')) {
        toTop.classes.remove('active');
      }
    }
  }

  void scrollToTop() {
    final int speed = (document.scrollingElement.scrollTop * 0.1).toInt();
    Timer.periodic(Duration(milliseconds: 15), (timer) {
      document.scrollingElement.scrollTop -= speed;
      if (document.scrollingElement.scrollTop <= 0) timer.cancel();
    });
  }

  void toggleContact(bool show) {
    if (show) {
      contactPopup.classes.add('active');
    } else {
      contactPopup.classes.remove('active');
    }
  }

  void toggleHeaderUser() {
    headerUser.classes.toggle('active');
  }

  void goTo(String route) {
    headerUser.classes.remove('active');
    _router.navigateByUrl(route);
  }

  void logout() {
    headerUser.classes.remove('active');
    _router.navigateByUrl(RoutePaths.homepage.toUrl());
    app.logout();
  }

  bool showFooter() {
    if (_router.current?.toUrl() == RoutePaths.homepage.toUrl()) {
      return false;
    }
    return true;
  }


  void contactSubmit(Event event) {
    //event.preventDefault();
    //event.stopPropagation();
    //contactController.create().then((_) {
    //  contactPopup.classes.remove('active');
    //  contactController.clear();
    //});
  }
}
