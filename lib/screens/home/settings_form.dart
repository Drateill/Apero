import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Apero/screens/services/shared/constants.dart';

import 'package:Apero/screens/services/userdata.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  String _aperoName = '';
  String _aperodescription = '';

  DatabaseService _addApero = new DatabaseService();

  var userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              GetUserData()
                  .getUserData(snapshot.data.uid)
                  .then((QuerySnapshot docs) {
                if (docs.documents.isNotEmpty) {
                  userData = docs.documents[0].data;
                } else {
                  userData = 'Vide';
                }
              });
              return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Text('Qu\'avez vous de beau à ajouter ?',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      initialValue: _aperoName,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Que doit on ajouter au frigo ?'),
                      validator: (val) => val.isEmpty ? 'Ajouter quoi ? ' : null,
                      onChanged: (val) => setState(() => _aperoName = val),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Description'),
                      initialValue: _aperodescription,
                      validator: (val) =>
                          val.isEmpty ? 'Sois plus précis !' : null,
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
                            'description': _aperodescription,
                            'byWho': userData['name'],
                          };
                          _addApero.addData(aperoData);
                          Navigator.pop(context);
                          alerte(context);
                        }
                      },
                    )
                  ],
                ),
              );
            } else {
              return Loading();
            }
          },
    );
  }
}

Future<void> alerte(context) async {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Text('Ajout effectuer.'),
          content: Text('Merci.'),
        );
      });
}
