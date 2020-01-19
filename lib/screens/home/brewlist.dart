import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
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
                    subtitle: Text(ds['description']),
                    trailing: FlatButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      onPressed: () {
                        alerte(ds.documentID);
                      },
                    ),
                    onTap: () {}),
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
                onPressed: (){
                  _delete.deletData(dsdoc);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
  
}
