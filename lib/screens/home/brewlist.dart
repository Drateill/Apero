import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/constants.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:Apero/screens/services/userdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  void _showUpdatePanel(description, name, uid) {
    var userData;
    final _formKey = GlobalKey<FormState>();
    DatabaseService _addApero = new DatabaseService();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 120),
              child: FutureBuilder(
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
                            Text('Quelque chose à corriger ?',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              initialValue: name,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Que doit on ajouter au frigo ?'),
                              validator: (val) =>
                                  val.isEmpty ? 'Ajouter quoi ? ' : null,
                              onChanged: (val) => setState(() => name = val),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Description'),
                              initialValue: description,
                              validator: (val) =>
                                  val.isEmpty ? 'Sois plus précis !' : null,
                              onChanged: (val) =>
                                  setState(() => description = val),
                            ),
                            //Submit change
                            RaisedButton(
                              color: Colors.pink[400],
                              child: Text(
                                'Modifier',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  Map aperoData = {
                                    'name': name,
                                    'description': description,
                                    'byWho': userData['name'],
                                  };
                                  _addApero.updateApero(aperoData, uid);
                                  Navigator.pop(context);
                                  alerteadded(context);
                                }
                              },
                            )
                          ],
                        ),
                      );
                    } else {
                      return Loading();
                    }
                  }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('apero').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Loading();

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.documents[index];
            return Padding(
              padding: EdgeInsets.only(top: 8),
              child: Card(
                margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.brown[100],
                      backgroundImage: AssetImage('assets/beer.png'),
                    ),
                    title: Text(ds['name']),
                    subtitle: Text(
                        '${ds['description']} ajouté par : ${ds['byWho']}'),
                    trailing: FlatButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      onPressed: () {
                        alerte(ds.documentID);
                      },
                    ),
                    onTap: () {
                      _showUpdatePanel(
                          ds['description'], ds['name'], ds.documentID);
                    }),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> alerte(dsdoc) async {
    DatabaseService _delete = new DatabaseService();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Attention'),
            content: Text('Etes vous sûre de vouloir supprimer ?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Delete'),
                onPressed: () {
                  _delete.deletData(dsdoc);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<void> alerteadded(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Modification enregistrée.'),
            content: Text('Merci.'),
          );
        });
  }
}
