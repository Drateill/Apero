import 'package:Apero/screens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:Apero/models/brews.dart';

class BrewTile extends StatelessWidget {
  final Apero apero;
  DatabaseService _delete= new DatabaseService();
  BrewTile({this.apero});
  @override
  Widget build(BuildContext context) {
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
          title: Text(apero.name),
          subtitle: Text(apero.description),
//           trailing: FlatButton.icon(
//             icon: Icon(Icons.delete),
//             label: Text('Delete'),
//             onPressed: (){
// _delete.deletData(apero.docId);

// print(apero.name);
//             },
//           ),
        ),
      ),
    );
  }
}
