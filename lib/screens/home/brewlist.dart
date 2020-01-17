import 'package:Apero/models/brews.dart';
import 'package:Apero/screens/home/BrewTile.dart';
import 'package:Apero/screens/services/database.dart';
import 'package:Apero/screens/services/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrewList extends StatefulWidget {
  @override
  _BrewListState createState() => _BrewListState();
}

class _BrewListState extends State<BrewList> {
  @override
  Widget build(BuildContext context) {
    final apero = Provider.of<List<Apero>>(context) ?? [];
    // final DatabaseService aperos= new DatabaseService();
         return ListView.builder(
           itemCount: apero.length,
           itemBuilder: (context, index){
             return BrewTile( apero: apero[index]);
           },

      );
    }





    // return StreamBuilder(
    //     stream: Firestore.instance.collection('apero').snapshots(),
    //     builder: (context, snapshot) {
    //       if (!snapshot.hasData) return Loading();
    //       return ListView.builder(
    //         itemCount: aperos.getData().,
    //         itemBuilder: (context, index) {
    //           return Card(
    //             margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
    //             child: ListTile(
    //               leading: CircleAvatar(
    //                 radius: 25,
    //                 backgroundColor: Colors.brown[100],
    //                 backgroundImage: AssetImage('assets/coffee_icon.png'),
    //               ),
    //               title: Text(snapshot.data.documents[index]['name']),
    //               subtitle: Text(
    //                   snapshot.data.documents[index]['Quantité'].toString()),
    //             ),
    //           );
    //         },
    //       );
    //     });
  }
