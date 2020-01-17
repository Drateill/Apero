import 'package:Apero/models/user.dart';
import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:Apero/screens/services/shared/constants.dart';
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
  String _currentSugars;
  int _currentStrength;


  String _aperoName;
  int _aperoQuantite=1;

  DatabaseService _addApero = new DatabaseService();

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
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Enter your name' : null,
                    onChanged: (val) => setState(() => _aperoName = val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //dropdown
                  // DropdownButtonFormField(
                  //   decoration: textInputDecoration,
                  //   value: _currentSugars ?? userData.sugars,
                  //   items: sugars.map((sugar) {
                  //     return DropdownMenuItem(
                  //       value: sugar,
                  //       child: Text('$sugar sugars'),
                  //     );
                  //   }).toList(),
                  //   onChanged: (val) => setState(() => _currentSugars = val),
                  // ),
                  //slider
                  Slider(
                    value: (_aperoQuantite.toDouble() ?? 1),
                    activeColor: Colors.brown[400],
                    inactiveColor: Colors.brown[400],
                    min: 1,
                    max: 10,
                    divisions: 10,
                    onChanged: (val) =>
                        setState(() => _aperoQuantite = val.round()),
                  ),
                  //Submit change
                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                 if (_formKey.currentState.validate()){
                   Map aperoData = {
                     'name': _aperoName,
                     'quantite' : _aperoQuantite
                   };
                   print(aperoData);
                  _addApero.addData(aperoData);
                  // await DatabaseService().;
                 }
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
