import 'package:brew_crew/models/brews.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:brew_crew/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/screens/services/database.dart';
import 'package:provider/provider.dart';
import 'brewlist.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
          child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
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
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              FlatButton.icon(
                icon: Icon(Icons.settings,
                color: Colors.white,),
                label: Text('Settings'),
                onPressed: () => _showSettingsPanel(),
              ),
            ],
          ),
          body: BrewList()),
    );
  }
}
