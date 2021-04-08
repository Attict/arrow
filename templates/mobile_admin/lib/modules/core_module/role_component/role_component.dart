///
/// role_component.dart
/// ~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_module/core_module.dart';

///
/// RoleComponent
///
///
///
class RoleComponent extends StatefulWidget {
  final String id;
  RoleComponent(this.id);

  @override
  _RoleComponentState createState() => _RoleComponentState();
}

///
/// _RoleComponentState
///
///
///
class _RoleComponentState extends State<RoleComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreRoleBloc();

  ///
  /// editModule
  ///
  /// Used when changing the permissions on a given module, so that
  /// the previous state is saved for reverting.
  ///
  CoreModule editModule;

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
              message: 'Role successfully saved!',
              buttons: <String, Function>{
                'OK': CoreApplication.instance.closeDialog,
              },
            ));
            break;
          default:
        }
        if (bloc.role != null) {
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
        ..add(_buildMain());
    return ListView(
      children: widgets,
    );
  }

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
                      bloc.id != null ?
                        RaisedButton(
                          color: Theme.of(context).errorColor,
                          onPressed: () {},
                          textColor: Colors.white,
                          child: Text('Delete')
                        ) : Container(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,
                        child: Text('Save')
                      ),
                    ]
                  ),
                ]
              )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text('ID: ${bloc.role.id}')
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //child: Text('Name: ${bloc.role.name}'),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hasFloatingPlaceholder: true,
                  hintText: 'Name',
                  icon: Icon(Icons.label),
                ),
                initialValue: bloc.role.name,
                onSaved: (v) => bloc.role.name = v,
                validator: (v) => bloc.validators['name'](v),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Weight',
                  border: UnderlineInputBorder(),
                  icon: Icon(Icons.line_weight),
                ),
                initialValue: bloc.role.weight.toString(),
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                onSaved: (String v) => bloc.role.weight = int.parse(v),
              ),
              //child: Text('Weight: ${bloc.role.weight}'),
            ),
            _buildPermissions(),
          ]
        )
      )
    );
  }

  Widget _buildPermissions() {
    final widgets = List<TableRow>();
    widgets..add(_buildHeader())
           ..addAll(bloc.role.modules.map<TableRow>(_buildPermission).toList());

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
            child: Text('Permissions', style: TextStyle(
              fontSize: 20,
            )),
          ),
          Table(
            columnWidths: <int, TableColumnWidth>{
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(1.5),
            },
            children: widgets,
          ),
        ]
      )
    );
  }

  ///
  /// _buildHeader
  ///
  /// Builds the header for the table.
  ///
  TableRow _buildHeader() {
    return TableRow(
      children: <Widget>[
        // NAME
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('name'),
          ),
        ),

        // READ
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('read'),
          ),
        ),

        // CREATE
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('create'),
          ),
        ),

        // UPDATE
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('update'),
          ),
        ),

        // DELETE
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('delete'),
          ),
        ),

      ],
    );
  }

  TableRow _buildPermission(CoreModule module) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1.0, color: const Color(0x1F000000))),
      ),
      children: <Widget>[
        GestureDetector(
          onTap: () => setEditPermission(module),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text(module.name),
          )
        ),
        GestureDetector(
          onTap: () => setEditPermission(module),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text(bloc.permissionValues[module.read]),
          )
        ),
        GestureDetector(
          onTap: () => setEditPermission(module),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text(bloc.permissionValues[module.create]),
          )
        ),
        GestureDetector(
          onTap: () => setEditPermission(module),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text(bloc.permissionValues[module.update]),
          )
        ),
        GestureDetector(
          onTap: () => setEditPermission(module),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text(bloc.permissionValues[module.delete]),
          )
        ),
      ],
    );
  }

  void setEditPermission(CoreModule module) {
    editModule = CoreModule.fromMap(module.toMap());
    print(bloc.permissionValues);
    showDialog<AlertDialog>(context: context, builder:
      (BuildContext context) => AlertDialog(
        title: Text('Set Permissions for Module'),
        content: Container(
          child: Row(
            children: <Widget>[
              // Labels
              Container(
                width: 80,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: Text('Read:'),
                    ),
                    Text('Create:'),
                    Text('Update:'),
                    Text('Delete:'),
                  ]
                ),
              ),

              // Values
              Expanded(
                child: Column(
                  children: <Widget>[

                    // Read
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 50,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: bloc.permissionValues[0],
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                        onChanged: (String v)
                            => setState(() => editModule.read = int.parse(v)),
                        items: bloc.permissionValues.keys
                            .map<DropdownMenuItem<String>>((int k) {
                              print(k);
                              return DropdownMenuItem<String>(
                                value: k.toString(),
                                child: Text(bloc.permissionValues[k]));
                              }).toList(),
                      ),
                    ),

                  ]
                ),
              )
            ]
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              editModule = null;
              Navigator.of(context).pop();
            }
          ),
          RaisedButton(
            child: Text('Save'),
            onPressed: () {
              saveEditPermission();
              Navigator.of(context).pop();
            }
          ),
        ]
      )
    );
  }

  void saveEditPermission() {
    final module = bloc.role.modules.firstWhere((i) => i.id == editModule.id);
    module
        ..read = editModule.read
        ..create = editModule.create
        ..update = editModule.update
        ..delete = editModule.delete;
    editModule = null;
  }


  ///
  /// _formKey
  ///
  /// Used to save the form.
  ///
  final _formKey = new GlobalKey<FormState>();
}
