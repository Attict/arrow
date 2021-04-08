///
/// compliance_items_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: January 29, 2019
///
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core_module/core_module.dart';
import 'package:acp_module/acp_module.dart';

///
/// ComplianceItemsComponent
///
///
class ComplianceItemsComponent extends StatefulWidget {
  @override
  _ComplianceItemsComponentState createState() => _ComplianceItemsComponentState();
}

///
/// _ComplianceItemsComponentState
///
///
class _ComplianceItemsComponentState extends State<ComplianceItemsComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = AcpComplianceItemsBloc();

  ///
  /// items
  ///
  /// For filtering
  ///
  List<AcpComplianceItem> items;

  ///
  /// sortField
  ///
  /// Which column to sort by.
  ///
  String sortField = 'endDate';

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
          setState(() => items = CoreFilter.filter(bloc.items, v));
        },
        decoration: InputDecoration(
          hintText: 'Filter',
        )
      )
    ));

    items = items == null ? bloc.items : items;
    items = CoreSort.sort(items, sortField, sortDir);
    final rows = List<TableRow>();


    // Header & Rows
    rows.add(_buildHeader());
    for (final item in items) {
      rows.add(_buildRow(item));
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
    Navigator.of(context).pushNamed('/acp/compliance/item', arguments: id);
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
            child: Text('Name'),
          ),
        ),

        // WEIGHT
        GestureDetector(
          onTap: () => sort('endDate'),
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            child: Text('End Date'),
          ),
        ),
      ],
    );
  }

  ///
  /// _buildRow
  ///
  ///
  TableRow _buildRow(AcpComplianceItem item) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
            top: BorderSide(width: 1.0, color: const Color(0x1F000000))),
      ),
      children: <Widget>[
        // USERNAME
        GestureDetector(
          onTap: () => goTo(item.id),
          child: Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(item.name),
          ),
        ),

        // NAME
        GestureDetector(
          onTap: () => goTo(item.id),
          child: Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: item.endDate != null
                ? Text(DateFormat.yMd().format(item.endDate)) : Text('N/A'),
          ),
        ),
      ]
    );
  }
}
