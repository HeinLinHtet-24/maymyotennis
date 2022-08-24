import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './database.dart';

class Authent {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    return await auth.currentUser!;
  }

  Future<void> createUserWithEmailAndPassword(
      String email,
      String id,
      String password,
      String image,
      String membername,
      String role,
      int passcode,
      DateTime dob,
      int match,
      int points) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    Map<String, dynamic> userInfoMap = {
      "id": auth.currentUser!.uid,
      "MemberName": membername,
      "Role": role,
      "PassCode": passcode,
      "Email": email,
      "DOB": dob,
      "Points": points,
      "Images": image,
      "Match": match
    };

    if (userCredential != null) {
      databaseMethods().addUserInfoToDB(auth.currentUser!.uid, userInfoMap);
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
