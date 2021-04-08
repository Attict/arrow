///
/// module_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:core_module/core_module.dart';
import 'package:acp_module/acp_module.dart';

///
/// ComplianceItemsComponent
///
///
class ComplianceItemComponent extends StatefulWidget {
  final String id;
  ComplianceItemComponent(this.id);

  @override
  _ComplianceItemComponentState createState() => _ComplianceItemComponentState();
}

///
/// _ComplianceItemComponentState
///
///
class _ComplianceItemComponentState extends State<ComplianceItemComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = AcpComplianceItemBloc();

  ///
  /// statusValues
  ///
  /// Pull in the status values from the Model.
  ///
  /// This is not stored statically, so that it's only in memory while
  ///
  final statusValues = AcpComplianceItem.getStatusValues();

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
  Widget build(BuildContext context) => StreamBuilder(
    stream: bloc,
    builder: (BuildContext context, AsyncSnapshot<CoreState> snapshot) {
      final state = snapshot.data;
      switch (state) {
        case CoreState.saved:
          CoreApplication.instance.showDialog(CoreDialog(
            title: 'Saved',
            message: 'Item successfully saved!',
            buttons: <String, Function>{
              'OK': CoreApplication.instance.closeDialog,
            },
          ));
          break;
        default:
      }

      if (bloc.item != null) {
        _updateControllers();
        return _build();
      }

      return Container();
    }
  );

  ///
  /// _build
  ///
  ///
  Widget _build() => Form(
    child: ListView(
      children: <Widget>[
        _buildTop(),
        _buildDetails(),
        _buildKeywords(),
        _buildMedia(),
      ],
    ),
  );

  ///
  /// _buildTop
  ///
  ///
  Widget _buildTop() => Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Back
        IconButton(
          onPressed: () => Navigator.of(context).pop(), // Pop back
          icon: Icon(Icons.keyboard_arrow_left),
        ),
        // Save
        RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          child: Text('Save'),
        ),
      ],
    ),
  );

  ///
  /// _buildDetails
  ///
  ///
  Widget _buildDetails() => Card(
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text('Details'),
      children: <Widget>[
        _buildDetailsName(),
        _buildDetailsDesc(),
        _buildDetailsStatus(),
        _buildDetailsExpire(),
      ],
    )
  );

  ///
  /// _buildDetailsName
  ///
  ///
  Widget _buildDetailsName() => Container(
    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'Name',
      ),
      initialValue: bloc.item.name,
    ),
  );

  ///
  /// _buildDetailsDesc
  ///
  ///
  Widget _buildDetailsDesc() => Container(
    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
    child: TextFormField(
      minLines: 3,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      initialValue: bloc.item.description,
    ),
  );

  ///
  /// _buildDetailsStatus
  ///
  ///
  Widget _buildDetailsStatus() => Container(
    padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        bloc.item.status == AcpComplianceItem.statusActive
            ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
            : const Icon(Icons.block, color: Colors.red),
        // Dropdown
        Container(
          height: 50,
          width: 250,
          child: DropdownButton<int>(
            isExpanded: true,
            value: bloc.item.status,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (int v) => setState(() => bloc.item.status = v),
            items: statusValues.keys.map<DropdownMenuItem<int>>((v) {
              return DropdownMenuItem<int>(
                value: v,
                child: Text(statusValues[v]),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );

  ///
  /// _buildDetailsExpire
  ///
  ///
  Widget _buildDetailsExpire() {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Expire:'),

          Container(
            width: 125,
            height: 50,
            child: TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onChanged: (v) {
                final d = DateTime.tryParse(v);
                if (d != null) {
                  bloc.item.endDate = d;
                }
              },
              onTap: () => showDatePicker(
                context: context,
                initialDate:  bloc.item.endDate != null ? bloc.item.endDate : DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 1, 1),
                lastDate: DateTime(DateTime.now().year + 3, 12),
              ).then((r) {
                bloc.item.endDate = r;
                print(bloc.item.endDate);
                setState(() => _dateController.text = DateFormat.yMd().format(bloc.item.endDate));
              }),
            ),
          ),

          Container(
            width: 120,
            height: 50,
            child: TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.arrow_drop_down),
              ),
              onTap: () => showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(bloc.item.endDate),
              ).then((r) {
                if (r != null) {
                  bloc.item.endDate = DateTime(
                    bloc.item.endDate.year,
                    bloc.item.endDate.month,
                    bloc.item.endDate.day,
                    r.hour ?? bloc.item.endDate.hour,
                    r.minute ?? bloc.item.endDate.minute,
                  );
                  setState(() => _timeController.text = DateFormat('hh:mm a').format(bloc.item.endDate));
                }
              }),
            )
          ),
        ],
      ),
    );
  }

  ///
  /// _buildKeywords
  ///
  ///
  Widget _buildKeywords() {
    return Card(
      child: ExpansionTile(
        title: Text('Keywords'),
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: TextFormField(
              controller: _keywordController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                hasFloatingPlaceholder: true,
                hintText: 'New Keyword',
                suffixIcon: IconButton(
                  onPressed: _addKeyword,
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.all(10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: bloc.item.keywords.reversed.map<Widget>((k) {
                return Container(
                  padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                  child: Chip(
                    label: Text(k.value),
                    onDeleted: () => setState(() => bloc.item.keywords.remove(k)),
                    deleteIcon: Icon(Icons.close, size: 14),
                  )
                );
                //return Chip(
                //  label: Text(k.value),
                //  deleteIcon: Icon(Icons.close),
                //);
              }).toList(),
            ),
          ),
        ],
      )
    );
  }

  ///
  /// _buildMedia
  ///
  ///
  Widget _buildMedia() {
    return Card(
      child: ExpansionTile(
        title: Text('Media'),
        children: <Widget>[

        ],
      ),
    );
  }

  void _updateControllers() {
    _dateController.text = bloc.item.endDate != null
        ? DateFormat.yMd().format(bloc.item.endDate)
        : 'Select a Date';
    _timeController.text = bloc.item.endDate != null
        ? DateFormat('hh:mm a').format(bloc.item.endDate)
        : 'Select a Time';
  }

  void _addKeyword() {
    if (_keywordController.text.isNotEmpty) {
      setState(() =>
          bloc.item.keywords.add(AcpKeyword(value: _keywordController.text)));
    }
  }



  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _keywordController = TextEditingController();



}
