import 'package:Apero/models/brews.dart';
import 'package:Apero/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // Collection Ref

  final CollectionReference userCollection =
      Firestore.instance.collection('user');
  final CollectionReference aperoCollection =
      Firestore.instance.collection('apero');
  Future getUserId() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return (uid);
  }

  Future updateUserData(String sugars, String name, int strength) async {
    return await userCollection.document(name).setData({
      'id': uid,
      'name': name,
    });
  }
    Future updateApero(aperoData, uid) async {
    return await aperoCollection.document(uid).setData(
        {'name': aperoData['name'], 'description': aperoData['description'], 'byWho': aperoData['byWho']});
  }

  Future getUserData(QuerySnapshot snapshot) async {
    return snapshot.documents.map((uid) {
      return User(name: uid.data['name'], uid: uid.data['id']);
    });
  }

  // Brew list from snapshot

  List<Users> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Users(
        name: doc.data['name'] ?? '',
        id: doc.data['id'] ?? 0,
      );
    }).toList();
  }

  // Apero list from snapshot

  List<Apero> _aperoListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Apero(
        name: doc.data['name'] ?? '',
        description: doc.data['description'] ?? 0,
        byWho: doc.data['byWho'] ?? '',
      );
    }).toList();
  }

  // get user stream
  Stream<List<Users>> get user {
    return userCollection.snapshots().map(_userListFromSnapshot);
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
    return await aperoCollection.document().setData(
        {'name': aperoData['name'], 'description': aperoData['description'], 'byWho': aperoData['byWho']});
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
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
