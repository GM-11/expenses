import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/main.dart';
import 'package:expenses/screens/ask_details.dart';
import 'package:expenses/screens/home_screen.dart';
import 'package:expenses/services/authentications.dart';
import 'package:expenses/services/groups_database.dart';
import 'package:expenses/shared/providers.dart';
import 'package:expenses/shared/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';
import 'package:riverpod/riverpod.dart';

// ignore: must_be_immutable
class ConfirmationScreen extends StatefulWidget {
  int? type;
  String? group;
  String? groupType;
  ConfirmationScreen({Key? key, this.type, this.group, this.groupType})
      : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    TextStyle _style = const TextStyle(
      color: Colors.amber,
      fontWeight: FontWeight.w600,
    );
    final id = widget.group;

    if (widget.type == 1 && widget.groupType == 'join') {
      return Scaffold(
          body: Center(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("groups").doc(id).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        data?["name"],
                        style: _style.copyWith(fontSize: 30.0),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Text(
                      "Members",
                      style: _style.copyWith(
                          fontSize: 15.0, color: Colors.blueGrey),
                    ),
                    SizedBox(
                      height: 350.0,
                      child: ListView(
                        shrinkWrap: true,
                        children: data?['members'].map<Widget>((snapshot) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Card(
                              elevation: 2.0,
                              child: ListTile(
                                title: Text(
                                  snapshot['name'],
                                  style: _style,
                                ),
                                subtitle: Text(snapshot['email']),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.amber),
                          onPressed: () async {
                            await GroupsDatabase().addMemberInGroup({
                              "name": _user?.displayName.toString(),
                              "email": _user?.email.toString()
                            }, widget.group.toString());

                            await Authentications().addDetails(
                                _user!.displayName, _user!.email, 1);
                            UserPreferences.changeFirstTime(false);
                            context.read(groupNameProvider).state =
                                data?['name'];
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeWrapper()));
                          },
                          child: const Text("Join Group")),
                    )
                  ],
                ),
              );
            }

            return const CircularProgressIndicator(
              color: Colors.amber,
            );
          },
        ),
      ));
    }

    if (widget.type == 0 && widget.groupType == 'create') {
      String x = GroupsDatabase().generateGroupId(widget.group.toString());
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Group Name:",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                Text(widget.group.toString(),
                    style: _style.copyWith(fontSize: 40.0)),
                const SizedBox(
                  height: 50.0,
                ),
                const Text(
                  "Group ID:",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                Text(x.toString(), style: _style.copyWith(fontSize: 40.0)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.amber),
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text("Change Group ID")),
                const SizedBox(
                  height: 50.0,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.amber),
                      onPressed: () async {
                        await GroupsDatabase().createGroup(
                            x.toString(),
                            {
                              "name": FirebaseAuth
                                  .instance.currentUser!.displayName,
                              "email": FirebaseAuth.instance.currentUser!.email,
                            },
                            widget.group.toString());

                        await Authentications()
                            .addDetails(_user!.displayName, _user!.email, 0);

                        UserPreferences.changeFirstTime(false);
                        context.read(groupNameProvider).state =
                            widget.group.toString();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeWrapper()));
                      },
                      child: const Text("Create Group")),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: [],
        ),
      );
    }
  }
}
