import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/shared/shared_prefs.dart';

class GroupsDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateGroupId(String groupName) {
    int min = 10000;
    int max = 1000000;

    if (groupName.contains(" ")) {
      groupName.replaceAll(" ", "-");
    }

    int x = min + Random().nextInt(max - min);

    List<int> list = [4, 5, 6, 7];
    int k = Random().nextInt(list.length - 1);

    int e = list[k];

    List<String> symbols = ["!", "_", "-", "?", "@", "#", "%"];
    int p = Random().nextInt(symbols.length - 1);

    return groupName.substring(0, e) + symbols[p] + x.toString();
  }

  Future createGroup(String id, Map creater, String name) async {
    try {
      await _firestore.collection("groups").doc(id).set({
        "name": name,
        "id": id,
        "members": [creater]
      });

      UserPreferences.setGroupId(id);

      return;
    } catch (e) {
      return e.toString();
    }
  }

  Future addMemberInGroup(Map member, String groupId) async {
    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference _ref = _firestore.collection("groups").doc(groupId);
        DocumentSnapshot _snap = await transaction.get(_ref);
        List _list = _snap.get("members");
        _list.add(member);
        transaction.update(_ref, {"members": _list});
        UserPreferences.setGroupId(groupId);
        return;
      });
    } catch (e) {
      return e.toString();
    }
  }
}
