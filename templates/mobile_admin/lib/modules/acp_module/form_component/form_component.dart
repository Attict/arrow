///
/// module_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';
import 'package:acp_module/acp_module.dart';

///
/// FormsComponent
///
///
class FormComponent extends StatefulWidget {
  final String id;
  FormComponent(this.id);

  @override
  _FormComponentState createState() => _FormComponentState();
}

///
/// _FormComponentState
///
///
class _FormComponentState extends State<FormComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = AcpFormBloc();

  ///
  /// statusValues
  ///
  /// Pull in the status values from the Model.
  ///
  /// This is not stored statically, so that it's only in memory while
  ///
  final statusValues = AcpForm.getStatusValues();

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

      if (bloc.form != null) {
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
        _buildTitle(),
        _buildDetails(),
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
  /// _buildTitle
  ///
  ///
  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
      child: TextFormField(
        initialValue: bloc.form.title,
        decoration: InputDecoration(
          labelText: 'Description',
        ),
      ),
    );
  }

  ///
  /// _buildDetails
  ///
  ///
  Widget _buildDetails() => Card(
    child: ExpansionTile(
      initiallyExpanded: true,
      title: Text('Details'),
      children: <Widget>[
        _buildDetailsStatus(),
      ],
    )
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
        bloc.form.status == AcpComplianceItem.statusActive
            ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
            : const Icon(Icons.block, color: Colors.red),
        // Dropdown
        Container(
          height: 50,
          width: 250,
          child: DropdownButton<int>(
            isExpanded: true,
            value: bloc.form.status,
            icon: Icon(Icons.arrow_drop_down),
            onChanged: (int v) => setState(() => bloc.form.status = v),
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



}
