import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserData {
  getUserData(String uid,) {
    return Firestore.instance
        .collection('user')
        .where('id', isEqualTo: uid)
        .getDocuments();
  }
}
