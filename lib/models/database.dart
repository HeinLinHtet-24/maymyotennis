import 'package:cloud_firestore/cloud_firestore.dart';
import '../pages/members.dart';

class databaseMethods {
  Future addUserInfoToDB(String userId, Map<String, dynamic> userInfoMap) {
    return FirebaseFirestore.instance
        .collection("Members")
        .doc(userId)
        .set(userInfoMap);
  }

  Future<DocumentSnapshot> getUserFromDB(String userId) {
    return FirebaseFirestore.instance.collection("Members").doc(userId).get();
  }
}
