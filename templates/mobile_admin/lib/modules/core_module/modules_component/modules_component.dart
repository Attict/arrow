///
/// modules_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~~
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
class ModulesComponent extends StatefulWidget {
  @override
  _ModulesComponentState createState() => _ModulesComponentState();
}

///
/// _ModulesComponentState
///
///
///
class _ModulesComponentState extends State<ModulesComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreModulesBloc();

  ///
  /// modules
  ///
  ///
  List<CoreModule> modules;

  ///
  /// state
  ///
  CoreState state;


  ///
  /// initState
  ///
  /// Loads the bloc.
  ///
  @override
  void initState() {
    super.initState();
    bloc.listen((s) => setState(() => state = s));
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
    if (state == CoreState.ready) {
      return _build();
    }
    return Container();
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
      child: TextFormField(
        onChanged: (v) {
          setState(() => modules = CoreFilter.filter(bloc.modules, v));
        },
        decoration: InputDecoration(
          hintText: 'Filter',
        )
      )
    ));
    if (modules == null) {
      modules = bloc.modules;
    }
    for (final m in modules) {
      widgets.add(GestureDetector(
        onTap: () => goTo(m.id),
        child: Card(
          child: Container(
            padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(m.name, style: TextStyle(

                )),
                Text(m.enabled ? 'ON' : 'OFF', style: TextStyle(
                  color: m.enabled ? Colors.green : Colors.red,
                  fontSize: 20,
                )),
              ],
            )
          )
        )
      ));
    }
    return ListView(
      children: widgets,
    );
  }

  ///
  /// _goToModule
  ///
  /// Route to module by ID.
  ///
  void goTo(int id) {
    Navigator.of(context).pushNamed('/module', arguments: id);
  }
}
