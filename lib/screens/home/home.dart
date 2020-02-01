import 'package:Apero/models/brews.dart';
import 'package:Apero/screens/chat.dart';
import 'package:Apero/screens/home/settings_form.dart';
import 'package:Apero/screens/services/auth.dart';
// import 'package:Apero/screens/services/shared/constants.dart';
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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 120),
              child: SettingsForm(),
            );
          });
    }



void _selectedDate() { showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2018),
  lastDate: DateTime(2030),
  builder: (BuildContext context, Widget child) {
    return Theme(
      data: ThemeData.dark(),
      child: child,
    );
  },
);
    }

    return StreamProvider<List<Apero>>.value(
      value: DatabaseService().apero,
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          backgroundColor: Colors.brown[400],
          title: Text('Apero'),
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              FlatButton.icon(
              label: Text('Chat'),
              icon: Icon(Icons.message),
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> Chat())
              )),
            FlatButton.icon(
              icon: Icon(
                Icons.add,
              ),
              label: Text('Add'),
              onPressed: () {
                _showSettingsPanel();} ,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.date_range,
              ),
              label: Text('Calendrier'),
              onPressed: ()  {
                _selectedDate();
                } ,
            ),
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              label: Text('Déconnexion'),
              icon: Icon(
                Icons.person,
              ),
            ),
            ],
          ),
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
