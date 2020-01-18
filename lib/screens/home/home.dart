import 'package:Apero/models/brews.dart';
import 'package:Apero/screens/home/settings_form.dart';
import 'package:Apero/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:Apero/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'brewlist.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Apero>>.value(
      value: DatabaseService().apero,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text('Apero'),
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('Logout'),
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text('Ajouter'),
              onPressed: () => _showSettingsPanel(),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BrewList(),
        ),
      ),
    );
  }
}
