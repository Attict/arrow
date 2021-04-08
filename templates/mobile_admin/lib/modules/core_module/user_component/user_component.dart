///
/// user_component.dart
/// ~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_module/core_module.dart';

///
/// UserComponent
///
///
///
class UserComponent extends StatefulWidget {
  final String id;
  UserComponent(this.id);

  @override
  _UserComponentState createState() => _UserComponentState();
}

///
/// _UserComponentState
///
///
///
class _UserComponentState extends State<UserComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreUserBloc();

  ///
  /// showPassword
  ///
  ///
  bool showPassword = false;

  ///
  /// initState
  ///
  /// Loads the bloc.
  ///
  @override
  void initState() {
    super.initState();
    bloc.id = widget.id;
    bloc.add(CoreEvent.load);
  }

  ///
  /// save
  ///
  ///
  void save() {
    _formKey.currentState.save();
    bloc.add(CoreEvent.save);
  }


  ///
  /// build
  ///
  /// Builds with a `StreamBuilder` that listens to the `bloc.state`,
  /// for updates, and build accordingly.
  ///
  /// `_build()` is the internal build for what the final state should be.
  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc,
      builder: (BuildContext context, AsyncSnapshot<CoreState> snapshot) {
        final state = snapshot.data;
        switch (state) {
          case CoreState.saved:
            CoreApplication.instance.showDialog(CoreDialog(
              title: 'Saved',
              message: 'User successfully updated!',
              buttons: <String, Function>{
                'OK': CoreApplication.instance.closeDialog,
              },
            ));
            break;
          default:
        }
        if (bloc.user != null) {
          return _build();
        }
        return Container();
      }
    );
  }

  ///
  /// _build
  ///
  /// The internal build, for a completely loaded page.
  ///
  Widget _build() {
    final widgets = List<Widget>();
    widgets
        ..add(Container(padding: EdgeInsets.fromLTRB(25, 15, 25, 15)))
        ..add(_buildMain())
        ..add(_buildProfile())
        ..add(_buildContact());

    return Form(
      key: _formKey,
      child: ListView(
        children: widgets,
      )
    );
  }

  ///
  /// _buildMain
  ///
  ///
  Widget _buildMain() {
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    color: Colors.black54,
                    icon: Icon(Icons.info),
                  ),

                  Row(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: save,
                        textColor: Colors.white,
                        child: Text('Save')
                      ),
                    ]
                  ),
                ]
              )
            ),

            Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Text('ID: ${bloc.user.id}'),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Text('Username: ${bloc.user.username}'),
            ),

            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: showPassword,
                    onChanged: (v) => setState(() => showPassword = v),
                  ),
                  Text('Show Password'),
                ]
              ),
            ),

            // Passwords
            showPassword ? _buildPasswords() : Container(),

          ]
        )
      )
    );
  }

  Widget _buildPasswords() {
    return Container(
      child: Column(
        children: <Widget>[

          // FIRST NAME
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hasFloatingPlaceholder: true,
                hintText: 'Password',
                icon: Icon(Icons.person),
              ),
              initialValue: bloc.user.profile.password,
              onSaved: (v) {
                if (v != _verifyPassword || v.isEmpty) return;
                bloc.user.profile.password = v;
              }
              //validator: (v) => bloc.validators['login'](v),
            ),
          ),

          // CONFIRM PASSWORD
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hasFloatingPlaceholder: true,
                hintText: 'Confirm Password',
                icon: Icon(Icons.person),
              ),
              initialValue: _verifyPassword,
              onSaved: (v) => _verifyPassword = v,
              //validator: (v) => bloc.validators['login'](v),
            ),
          ),

        ]
      ),
    );
  }

  ///
  /// _buildProfile
  ///
  ///
  Widget _buildProfile() {
    return Card(
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Profile'),

            // FIRST NAME
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'First Name',
                  icon: Icon(Icons.person),
                ),
                initialValue: bloc.user.profile.firstName,
                onSaved: (v) => bloc.user.profile.firstName = v,
                //validator: (v) => bloc.validators['login'](v),
              ),
            ),

            // LAST NAME
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'Last Name',
                  icon: Icon(Icons.person),
                ),
                initialValue: bloc.user.profile.lastName,
                onSaved: (v) => bloc.user.profile.lastName = v,
                //validator: (v) => bloc.validators['login'](v),
              ),
            ),

            // DISPLAY NAME
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'Display Name',
                  icon: Icon(Icons.person),
                ),
                initialValue: bloc.user.profile.displayName,
                onSaved: (v) => bloc.user.profile.displayName = v,
                //validator: (v) => bloc.validators['login'](v),
              ),
            ),

            // COMPANY
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'Company',
                  icon: Icon(Icons.business),
                ),
                initialValue: bloc.user.profile.company,
                onSaved: (v) => bloc.user.profile.company = v,
                //validator: (v) => bloc.validators['login'](v),
              ),
            ),

            // TITLE
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'Title',
                  icon: Icon(Icons.title),
                ),
                initialValue: bloc.user.profile.title,
                onSaved: (v) => bloc.user.profile.title = v,
                //validator: (v) => bloc.validators['login'](v),
              ),
            ),
          ]
        )
      ),
    );
  }

  Widget _buildContact() {
    return Column(
      children: <Widget>[

        // EMAILS
        Card(
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text('Emails'),
                Column(
                  children: bloc.user.profile.emails.map<Widget>((i) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hasFloatingPlaceholder: true,
                          hintText: 'Email',
                          icon: Icon(Icons.email),
                        ),
                        initialValue: i.email,
                        onSaved: (v) => i.email = v,
                        //validator: (v) => bloc.validators['login'](v),
                      ),
                    );
                  }).toList(),
                ),

                RaisedButton(
                  textColor: Colors.white,
                  onPressed: _addEmail,
                  child: Text('Add Email'),
                ),
              ]
            )
          )
        ),

        // PHONES
        Card(
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text('Phone'),

                Column(
                  children: bloc.user.profile.phones.map<Widget>((i) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hasFloatingPlaceholder: true,
                          hintText: 'Phone',
                          icon: Icon(Icons.email),
                        ),
                        initialValue: i.phone,
                        onSaved: (v) => i.phone = v,
                        //validator: (v) => bloc.validators['login'](v),
                      ),
                    );
                  }).toList(),
                ),

                RaisedButton(
                  textColor: Colors.white,
                  onPressed: _addPhone,
                  child: Text('Add Phone'),
                ),
              ]
            )
          )
        ),

        // ADDRESSES
        Card(
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Text('Addresses'),

                Column(
                  children: bloc.user.profile.addresses.map<Widget>((i) {
                    return Column(
                      children: <Widget>[

                        // Address 1
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hasFloatingPlaceholder: true,
                              hintText: 'Address Line 1',
                              icon: Icon(Icons.email),
                            ),
                            initialValue: i.address1,
                            onSaved: (v) => i.address1 = v,
                            //validator: (v) => bloc.validators['login'](v),
                          ),
                        ),

                        // Address 2
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hasFloatingPlaceholder: true,
                              hintText: 'Address Line 2',
                              icon: Icon(Icons.email),
                            ),
                            initialValue: i.address2,
                            onSaved: (v) => i.address2 = v,
                            //validator: (v) => bloc.validators['login'](v),
                          ),
                        ),

                        // City
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hasFloatingPlaceholder: true,
                              hintText: 'City',
                              icon: Icon(Icons.email),
                            ),
                            initialValue: i.city,
                            onSaved: (v) => i.city = v,
                            //validator: (v) => bloc.validators['login'](v),
                          ),
                        ),

                        // State
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hasFloatingPlaceholder: true,
                              hintText: 'State',
                              icon: Icon(Icons.email),
                            ),
                            initialValue: i.state,
                            onSaved: (v) => i.state = v,
                            //validator: (v) => bloc.validators['login'](v),
                          ),
                        ),

                        // Address 1
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hasFloatingPlaceholder: true,
                              hintText: 'Zip Code',
                              icon: Icon(Icons.email),
                            ),
                            initialValue: i.zip,
                            onSaved: (v) => i.zip = v,
                            //validator: (v) => bloc.validators['login'](v),
                          ),
                        ),

                      ]
                    );
                  }).toList(),
                ),

                RaisedButton(
                  textColor: Colors.white,
                  onPressed: _addAddress,
                  child: Text('Add Address'),
                ),

              ]
            )
          )
        ),

      ]
    );
  }

  void _addEmail() {
    if (bloc.user.profile.emails == null) {
      bloc.user.profile.emails = List<CoreEmail>();
    }
    setState(() => bloc.user.profile.emails.add(CoreEmail()));
  }

  void _addPhone() {
    if (bloc.user.profile.phones == null) {
      bloc.user.profile.phones = List<CorePhone>();
    }
    setState(() => bloc.user.profile.phones.add(CorePhone()));
  }

  void _addAddress() {
    if (bloc.user.profile.addresses == null) {
      bloc.user.profile.addresses = List<CoreAddress>();
    }
    setState(() => bloc.user.profile.addresses.add(CoreAddress()));
  }


  ///
  /// _verifyPassword
  ///
  ///
  String _verifyPassword = '';

  ///
  /// _formKey
  ///
  /// Used to save the form.
  ///
  final _formKey = new GlobalKey<FormState>();
}
