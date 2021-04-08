///
/// roles_component.dart
/// ~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';

///
/// RolesComponent
///
///
class RolesComponent extends StatefulWidget {
  @override
  _RolesComponentState createState() => _RolesComponentState();
}

///
/// _RolesComponentState
///
///
class _RolesComponentState extends State<RolesComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreRolesBloc();

  ///
  /// roles
  ///
  /// For filtering
  ///
  List<CoreRole> roles;

  ///
  /// sortField
  ///
  /// Which column to sort by.
  ///
  String sortField = 'id';

  ///
  /// sortDir
  ///
  /// Values:
  /// - [1]  Ascending
  /// - [0]  None
  /// - [-1] Descending
  ///
  int sortDir = 1;

  ///
  /// initState
  ///
  /// Loads the bloc.
  ///
  @override
  void initState() {
    super.initState();
    bloc.add(CoreEvent.load);
  }

  ///
  /// dispose
  ///
  /// Make sure to always close the bloc.
  ///
  @override
  void dispose() {
    bloc.close();
    super.dispose();
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
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.done) {
          final state = snapshot.data;
          if (state == CoreState.complete) {
            return _build();
          }
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
    // Filter
    widgets.add(Container(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
      child: Row(
        children: <Widget>[
          Expanded(
            child:TextFormField(
              onChanged: (v) {
                setState(() => roles = CoreFilter.filter(bloc.roles, v));
              },
              decoration: InputDecoration(
                hintText: 'Filter',
              )
            ),
          ),

          RaisedButton(
            onPressed: goTo,
            textColor: Colors.white,
            child: Text('Add Role'),
          )
        ]
      )
    ));

    roles = roles == null ? bloc.roles : roles;
    roles = CoreSort.sort(roles, sortField, sortDir);
    final rows = List<TableRow>();


    // Header & Rows
    rows.add(_buildHeader());
    for (final role in roles) {
      rows.add(_buildRow(role));
    }

    widgets.add(Card(
      child: Table(
        columnWidths: <int, TableColumnWidth> {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(4),
          2: FlexColumnWidth(4),
        },
        children: rows,
      ),
    ));

    return ListView(children: widgets);
  }

  ///
  /// goTo
  ///
  /// Route to
  ///
  void goTo([String id]) {
    Navigator.of(context).pushNamed('/role', arguments: id);
  }

  ///
  /// sort
  ///
  /// Defines the sorting, swaping between ascending & descending.
  ///
  void sort(String field) {
    setState(() {
      sortDir = field != sortField ? 1 : sortDir * -1;
      sortField = field;
    });
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
          onTap: () => sort('name'),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text('name'),
          ),
        ),

        // WEIGHT
        GestureDetector(
          onTap: () => sort('weight'),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('weight'),
          ),
        ),
      ],
    );
  }

  ///
  /// _buildRow
  ///
  ///
  TableRow _buildRow(CoreRole role) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1.0, color: const Color(0x1F000000))),
      ),
      children: <Widget>[
        // USERNAME
        GestureDetector(
          onTap: () => goTo(role.id),
          child: Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(role.name),
          ),
        ),

        // NAME
        GestureDetector(
          onTap: () => goTo(role.id),
          child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(role.weight.toString()),
          ),
        ),
      ]
    );
  }
}
