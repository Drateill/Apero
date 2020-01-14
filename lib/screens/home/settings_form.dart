import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/services/database.dart';
import 'package:brew_crew/screens/services/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/screens/services/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form Values

  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(
          uid: user.uid,
        ).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData=snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text('Update your brew settings.',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugar ?? userData.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugar = val),
                  ),
                  //slider
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  //Submit change
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      print(_currentName);
                      print(_currentSugar);
                      print(_currentStrength);
                    },
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
