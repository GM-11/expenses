import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/shared/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentications {
  User? _user;

  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  Future registerUser(String email, String name, String pass) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);

      _user = result.user;

      FirebaseFirestore.instance
          .collection("users")
          .doc(_user!.uid)
          .set({"pass": pass});

      _user!.updateDisplayName(name);

      return "done";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future addDetails(String? name, String? email, int? type,
      [int? monthlyIncome, var groupId]) async {
    if (type == 0) {
      // personal use --- 0
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        "name": name,
        "email": email,
        "monthlyIncome": monthlyIncome,
        "type": type
      }, SetOptions(merge: true));

      UserPreferences.setType(0);
    } else {
      // group use --- 1
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({"name": name, "email": email, "groupId": groupId, "type": type},
              SetOptions(merge: true));

      UserPreferences.setType(1);
    }
  }

  Future signOut() async {
    UserPreferences.clearEverythingInPrefs();
    await FirebaseAuth.instance.signOut();
  }
}
