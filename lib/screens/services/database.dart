import 'package:Apero/models/brews.dart';
import 'package:Apero/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Ref

  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');
  final CollectionReference aperoCollection =
      Firestore.instance.collection('apero');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // Brew list from snapshot

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
          name: doc.data['name'] ?? '',
          strength: doc.data['strength'] ?? 0,
          sugar: doc.data['sugars'] ?? '0');
    }).toList();
  }

  // Apero list from snapshot

  List<Apero> _aperoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Apero(
        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? 0,
      );
    }).toList();
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get apero stream
  Stream<List<Apero>> get apero {
    return aperoCollection.snapshots().map(_aperoListFromSnapshot);
  }

  //add apero

  // Future<void> addData(aperoData) async {
  //   return await Firestore.instance.collection('apero').add(
  //       {'name': aperoData['name'], 'description': aperoData['description'],});
  // }
  Future<void> addData(aperoData) async {
    return await aperoCollection.document().setData({
      'name': aperoData['name'],
      'description' : aperoData['description']
    });
  }
  Future getData() async {
    return Firestore.instance.collection('apero').snapshots();
  }

  // user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength'],
        uid: uid);
  }

  deletData(docId) {
    Firestore.instance
        .collection('apero')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  // get user doc stream

  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
