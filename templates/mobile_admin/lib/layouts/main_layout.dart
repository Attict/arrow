import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';

///
/// MainLayout
///
/// The main layout for the application
///
class MainLayout extends StatefulWidget {
  final Widget page;
  final String title;
  MainLayout(this.page, {this.title: 'Mobile', Key key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

///
/// _MainLayoutState
///
/// The state for the main layout.
///
class _MainLayoutState extends State<MainLayout> {
  ///
  /// app
  ///
  final app = CoreApplication.instance;

  ///
  /// initState
  ///
  /// Overrides the default initState, to create the layout listeners
  /// for snackbar, and potentially dialog.
  ///
  @override
  void initState() {
    super.initState();
    _appSubscription = app.listen((state) {
      switch (state) {
        default:
      }
      setState((){});
    });
  }

  ///
  /// dispose
  ///
  /// Dispose of the dialog and snackbar stream subscriptions.
  ///
  @override
  void dispose() {
    _appSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final widgets = List<Widget>();

    // Logo --
    widgets.add(Container(
      alignment: Alignment.center,
      width: 35,
      height: 35,
      margin: EdgeInsets.all(10.0),
      child: Image.asset('assets/images/logos/app-icon.png'),
    ));

    // Custom Modules --
    widgets.add(Divider());
    widgets.add(ListTile(
      leading: const Icon(Icons.dashboard),
      title: Text('Dashboard'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/dashboard'),
    ));

    // ACP Module --
    widgets.add(Divider());
    widgets.add(ListTile(
      leading: const Icon(Icons.security),
      title: Text('Compliance Items'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/acp/compliance/items'),
    ));
    widgets.add(ListTile(
      leading: const Icon(Icons.description),
      title: Text('Forms'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/acp/forms'),
    ));


    // Core Modules --
    widgets.add(Divider());
    widgets.add(ListTile(
      leading: const Icon(Icons.people),
      title: Text('Users'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/users'),
    ));
    widgets.add(ListTile(
      leading: const Icon(Icons.label),
      title: Text('Roles'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/roles'),
    ));
    widgets.add(ListTile(
      leading: const Icon(Icons.extension),
      title: Text('Modules'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/modules'),
    ));
    widgets.add(ListTile(
      leading: const Icon(Icons.settings),
      title: Text('Settings'),
      selected: false,
      onTap: () => Navigator.of(context).pushReplacementNamed('/settings'),
      //onTap: () => CoreApplication.instance.showSnackbar(
      //  CoreSnackbar(message: 'Test message', buttonText: 'Btn', buttonCallback: () {})
      //),
    ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.person),
            onSelected: (v) {
              switch (v) {
                // Signout
                case 0:
                  CoreApplication.instance.logout();
                  Navigator.of(context).popUntil(ModalRoute.withName('/'));
                  break;
                case 1:
                  Navigator.of(context).pushReplacementNamed('/profile');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                value: 1,
                child: Text('My Profile')
              ),
              PopupMenuItem(child: Text('My Settings')),
              PopupMenuDivider(),
              PopupMenuItem(child: Text('Change to Dark Theme')),
              PopupMenuItem(
                value: 0,
                child: Text('Sign out'),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(child: ListView(children: widgets)),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // PAGE
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: widget.page
          ),

          // LOADING
          Positioned(
            top: 0,
            width: MediaQuery.of(context).size.width,
            height: 5,
            child: app.loading > 0 ? LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              valueColor: AlwaysStoppedAnimation(Color(0xAAFFFFFF)),
            ) : Container()
          )
        ]
      )
    );
  }

  ///
  /// _updateDialog
  ///
  ///
  void _updateDialog() {
    if (app.dialog != null) {
      showDialog<AlertDialog>(context: _scaffoldKey.currentContext, builder:
        (BuildContext context) => AlertDialog(
          title: Text('${app.dialog.title}'),
          content: Container(
            child: Text('${app.dialog.message}'),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('OK'),
              onPressed: () {
                CoreApplication.instance.closeDialog();
                Navigator.of(context).pop();
              }
            ),
          ]
        )
      );
    }
  }


  ///
  /// _scaffoldKey
  ///
  /// The unique key for the scaffold state.
  ///
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ///
  /// _appSubscription
  ///
  ///
  StreamSubscription<CoreState> _appSubscription;

}
