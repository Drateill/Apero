import 'package:brew_crew/screens/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {

final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('Brew Crew'),
        elevation: 0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              await _auth.signOut();
            },
            label: Text('Logout'),
            icon:Icon(Icons.person,
            color: Colors.white,),
          )
        ],
      ),
    );
  }
}