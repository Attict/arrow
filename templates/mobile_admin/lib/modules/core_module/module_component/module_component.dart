///
/// module_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: December 9, 2019
///
import 'package:flutter/material.dart';
import 'package:core_module/core_module.dart';

///
/// ModulesComponent
///
///
///
class ModuleComponent extends StatefulWidget {
  final int id;
  ModuleComponent(this.id);

  @override
  _ModuleComponentState createState() => _ModuleComponentState();
}

///
/// _ModuleComponentState
///
///
///
class _ModuleComponentState extends State<ModuleComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreModuleBloc();

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
        return Container(child: Text('Loading...'));
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
    widgets.add(Container(
      padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
    ));
    widgets.add(Card(
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

                  RaisedButton(
                    onPressed: () {},
                    textColor: Colors.white,
                    child: Text('Save')
                  ),
                ]
              )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text('ID: ${bloc.module.id}')
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text('Name: ${bloc.module.name}'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text('Parent: ${bloc.module.parent}'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text('Enabled: ${bloc.module.enabled}'),
            ),
          ]
        )
      )
    ));
    return ListView(
      children: widgets,
    );
  }
}
