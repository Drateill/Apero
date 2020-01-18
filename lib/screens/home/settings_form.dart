import 'package:Apero/models/brews.dart';
import 'package:Apero/models/user.dart';
import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Apero/screens/services/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String _aperoName;
  String _aperodescription = '';

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
                  //slider
                  // Slider(
                  //   value: (_aperodescription.toDouble() ?? 1),
                  //   activeColor: Colors.brown[400],
                  //   inactiveColor: Colors.brown[400],
                  //   min: 1,
                  //   max: 10,
                  //   divisions: 10,
                  //   onChanged: (val) =>
                  //       setState(() => _aperodescription = val.round()),
                  // ),
                  TextFormField(
                    validator: (val) => val.isEmpty ? 'Combien ?' : null,
                    onChanged: (val) => setState(() => _aperodescription = val),
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
                      if (_formKey.currentState.validate()) {
                        Map aperoData = {
                          'name': _aperoName,
                          'description': _aperodescription
                        };
                        _addApero.addData(aperoData);
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
