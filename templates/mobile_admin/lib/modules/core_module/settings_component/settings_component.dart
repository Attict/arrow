///
/// settings_component.dart
/// ~~~~~~~~~~~~~~~~~~~~~~~
///
/// Author: Eric Wagner <eric.wagner@kapioshealth.com>
/// Created: January 17, 2019
///
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:core_module/core_module.dart';

///
/// SettingsComponent
///
///
///
class SettingsComponent extends StatefulWidget {
  @override
  _SettingsComponentState createState() => _SettingsComponentState();
}

///
/// _RoleComponentState
///
///
///
class _SettingsComponentState extends State<SettingsComponent> {
  ///
  /// bloc
  ///
  /// This views bloc
  ///
  final bloc = CoreSettingsBloc();

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
              message: 'Settings successfully updated!',
              buttons: <String, Function>{
                'OK': CoreApplication.instance.closeDialog,
              },
            ));
            break;
          default:
        }
        if (bloc.modules != null) {
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

            _buildSettings(),
          ]
        )
      )
    );
  }

  ///
  /// _buildSettings
  ///
  ///
  Widget _buildSettings() {
    return Container(
      child: Column(
        children: bloc.modules.map<Widget>((i) => _buildModule(i)).toList()
      )
    );
  }

  ///
  /// _buildModule
  ///
  ///
  Widget _buildModule(CoreModule module) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${module.name}', style: TextStyle(
            fontSize: 24,
            height: 3,
          )),
          Column(
            children: module.settingGroups.map<Widget>((i) => _buildGroup(i)).toList()
          ),
        ]
      )
    );
  }

  ///
  /// _buildGroup
  ///
  ///
  Widget _buildGroup(CoreSettingGroup group) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x11000000),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${group.name}', style: TextStyle(
            fontSize: 18,
          )),
          Column(
            children: group.settings.map<Widget>((i) => _buildSetting(i)).toList()
          ),
        ]
      )
    );
  }

  ///
  /// _buildSetting
  ///
  ///
  Widget _buildSetting(CoreSetting setting) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.all(15),
      color: Color(0x11000000),
      child: Column(
        children: <Widget>[
          Text('${setting.name}'),
          _buildInput(setting),
        ]
      )
    );
  }

  Widget _buildInput(CoreSetting setting) {
    Widget r;
    switch (setting.type) {
      case CoreSetting.typeBoolean:
        r = Switch(
          value: setting.value == 'true',
          onChanged: (v) => setting.value = v.toString(),
        );
        break;
      case CoreSetting.typeString:
        r = TextFormField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hasFloatingPlaceholder: true,
            hintText: 'Value',
            icon: Icon(Icons.settings),
          ),
          initialValue: setting.value,
          onSaved: (v) => setting.value = v,
          //validator: (v) => bloc.validators['login'](v),
        );
        break;
      case CoreSetting.typeNumber:
        r = TextFormField(
          // validator:
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter.digitsOnly,
          ],
          onSaved: (String v) => setting.value = v,
          initialValue: setting.value.toString(),
          decoration: InputDecoration(
            hintText: 'Weight',
            border: UnderlineInputBorder(),
            icon: Icon(Icons.line_weight),
          ),
        );
        break;
      case CoreSetting.typeDropdown:
        r = DropdownButton<String>(
          isExpanded: true,
          value: setting.value,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Theme.of(context).primaryColor,
          ),
          onChanged: (String newValue)
              => setState(() => setting.value = newValue),
          items: setting.options.keys.map<DropdownMenuItem<String>>(
              (String key) => DropdownMenuItem<String>(
                value: key,
                child: Text(setting.options[key]),
              )).toList(),
        );
        break;
      case CoreSetting.typePassword:
        r = TextFormField(
          decoration: InputDecoration(
            border: UnderlineInputBorder(),
            hasFloatingPlaceholder: true,
            hintText: 'Value',
            icon: Icon(Icons.settings),
          ),
          obscureText: true,
          initialValue: setting.value,
          onSaved: (v) => setting.value = v,
          //validator: (v) => bloc.validators['login'](v),
        );
        break;
      default:
        r = Container();
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: r
    );
  }

  ///
  /// _formKey
  ///
  /// Used to save the form.
  ///
  final _formKey = new GlobalKey<FormState>();
}
