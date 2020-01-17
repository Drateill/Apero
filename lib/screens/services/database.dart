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
          quantite: doc.data['quantite'] ?? 0,);
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

  Future<void> addData(aperoData) async {

     return await Firestore.instance.collection('apero').add({
       'name' : aperoData['name'],
       'Quantité' : aperoData['quantite']
     });
    

  }

  Future getData() async {

    return await Firestore.instance.collection('apero').getDocuments();
  }


  // user data from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        name: snapshot.data['name'],
        sugars: snapshot.data['sugars'],
        strength: snapshot.data['strength'],
        uid: uid);
  }

  // get user doc stream

  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
