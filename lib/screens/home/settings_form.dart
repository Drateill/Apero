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

  String _aperoName = '';
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
                    initialValue: _aperoName,
                    decoration: textInputDecoration.copyWith(hintText: 'Que doit on ajouter au frigo ?'),
                    validator: (val) => val.isEmpty ? 'Ajouter quoi ? ' : null,
                    onChanged: (val) => setState(() => _aperoName = val),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description'
                    ),
                    initialValue: _aperodescription,
                    validator: (val) => val.isEmpty ? 'Sois plus précis !' : null,
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
                        Navigator.pop(context);
                        alerte();
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

  Future<void> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Vient d\'être ajouter : '),
            content: Text('$_aperoName - $_aperodescription'),
          );
        });
  }



}
