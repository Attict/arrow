import 'dart:async';
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';

///
/// AuthenticationComponent
///
///
///
class AuthenticationComponent extends StatefulWidget {
  @override
  _AuthenticationComponentState createState()
      => _AuthenticationComponentState();
}

///
/// _AuthenticationComponentState
///
/// Controls the state for the AuthenticationComponent.
///
class _AuthenticationComponentState extends State<AuthenticationComponent> {
  ///
  /// bloc
  ///
  /// This component's bloc.
  ///
  final bloc = CoreAuthenticationBloc();

  ///
  /// _authenticationKey
  ///
  /// Controls the login form.
  ///
  final _authenticationKey = GlobalKey<FormState>();

  ///
  /// _username, _password
  ///
  /// The username and password to be sent in request.
  ///
  String _username, _password;

  ///
  /// _loading
  ///
  /// Whether or not the loading should be shown, and form disabled
  /// while loading.
  ///
  bool _loading = false;

  ///
  /// _dialogStream
  ///
  /// The subscription for the dialog stream.  To be canceled on dispose.
  ///
  StreamSubscription<CoreState> _appSubscription;

  ///
  /// initState
  ///
  /// Initialize the dialog stream subscription.
  ///
  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 100), () => CoreApplication.instance.user != null
            ?  Navigator.of(context).pushNamed('/dashboard') : null);

    _appSubscription = CoreApplication.instance.listen((state) {
      switch (state) {
        case CoreState.dialog:
          _updateDialog();
          break;
        default:
      }
      setState((){});
    });


    //_appStateSub = CoreApplication.instance.state.listen((state) {
    //  if (state == CoreApplicationState.dialogChanged &&
    //      CoreApplication.instance.dialog != null) {

    //    showDialog<AlertDialog>(context: context, builder:
    //      (BuildContext context) => AlertDialog(
    //        content: Container(
    //          child: Text('${CoreApplication.instance.dialog.message}'),
    //        )
    //      )
    //    );
    //  }
    //});
  }

  ///
  /// dispose
  ///
  @override
  void dispose() {
    _appSubscription.cancel();
    super.dispose();
  }

  ///
  /// build
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final whiteBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    );
    final whiteStyle = TextStyle(
      color: Colors.white,
    );

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // Logo
                  Image.asset('assets/images/logos/app-icon.png', width: 100),

                  // Login Form
                  Container(
                    padding: EdgeInsets.fromLTRB(75, 25, 75, 25),
                    child: Form(
                      key: _authenticationKey,
                      child: Column(
                        children: <Widget>[

                          // Username
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: whiteBorder,
                                enabledBorder: whiteBorder,
                                focusedBorder: whiteBorder,
                                hintStyle: whiteStyle,
                                hintText: 'Username',
                              ),
                              onSaved: (v) => _username = v,
                              style: whiteStyle,
                            ),
                          ),

                          // Password
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: whiteBorder,
                                enabledBorder: whiteBorder,
                                focusedBorder: whiteBorder,
                                hintStyle: whiteStyle,
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              onSaved: (v) => _password = v,
                              style: whiteStyle,
                            ),
                          ),

                          // Sign In
                          FittedBox(
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: _login,
                              child: Text('Sign In'),
                            ),
                          )
                        ],
                      ),
                    ), // Form
                  ),
                ],
              ),

              _loading ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(strokeWidth: 6.0),
                ),
              ) : Container(),
            ],
          ),
        ),
      ), // Center
    );
  }

  ///
  /// _login
  ///
  /// Attempts to log a user in.
  ///
  Future<Null> _login() async {
    _authenticationKey.currentState.save();
    await bloc.authenticate(_username, _password);
    if (CoreApplication.instance.user != null) {
      _authenticationKey.currentState.reset();
      Navigator.of(context).pushNamed('/dashboard');
    }
  }

  void _updateDialog() {
    if (CoreApplication.instance.dialog != null) {
      showDialog<AlertDialog>(context: _scaffoldKey.currentContext, builder:
        (BuildContext context) => AlertDialog(
          title: Text('${CoreApplication.instance.dialog.title}'),
          content: Container(
            child: Text('${CoreApplication.instance.dialog.message}'),
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
}
