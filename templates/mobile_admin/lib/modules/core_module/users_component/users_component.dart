///
/// users_component.dart
/// ~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';

///
/// UsersComponent
///
///
class UsersComponent extends StatefulWidget {
  @override
  _UsersComponentState createState() => _UsersComponentState();
}

///
/// _UsersComponentState
///
///
class _UsersComponentState extends State<UsersComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreUsersBloc();

  ///
  /// users
  ///
  /// For filtering
  ///
  List<CoreUser> users;

  ///
  /// sortField
  ///
  /// Which column to sort by.
  ///
  String sortField = 'userRole.weight';

  ///
  /// sortDir
  ///
  /// Values:
  /// - [1]  Ascending
  /// - [0]  None
  /// - [-1] Descending
  ///
  int sortDir = -1;

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
          if (state == CoreState.ready) {
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
      child: TextFormField(
        onChanged: (v) {
          setState(() => users = CoreFilter.filter(bloc.users, v));
        },
        decoration: InputDecoration(
          hintText: 'Filter',
        )
      )
    ));

    users = users == null ? bloc.users : users;
    users = CoreSort.sort(users, sortField, sortDir);
    final rows = List<TableRow>();


    // Header & Rows
    rows.add(_buildHeader());
    for (final user in users) {
      rows.add(_buildRow(user));
    }

    widgets.add(Card(
      child: Table(
        columnWidths: <int, TableColumnWidth> {
          0: FlexColumnWidth(6),
          1: FlexColumnWidth(4),
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
  void goTo(String id) {
    Navigator.of(context).pushNamed('/user', arguments: id);
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
          onTap: () => sort('username'),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Text('username'),
          ),
        ),

        // WEIGHT
        GestureDetector(
          onTap: () => sort('role.name'),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('role'),
          ),
        ),
      ],
    );
  }

  ///
  /// _buildRow
  ///
  ///
  TableRow _buildRow(CoreUser user) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1.0, color: const Color(0x1F000000))),
      ),
      children: <Widget>[
        // USERNAME
        GestureDetector(
          onTap: () => goTo(user.id),
          child: Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(user.username),
          ),
        ),

        // NAME
        GestureDetector(
          onTap: () => goTo(user.id),
          child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(user.userRole.name),
          ),
        ),
      ]
    );
  }
}
