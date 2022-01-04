import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/screens/ask_details.dart';
import 'package:expenses/screens/confirmation_screen.dart';
import 'package:expenses/screens/home_screen.dart';
import 'package:expenses/screens/register.dart';
import 'package:expenses/shared/providers.dart';
import 'package:expenses/shared/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await UserPreferences.init();
  runApp(ProviderScope(
      child: MaterialApp(
    routes: {
      "home_screen": (context) => const HomeScreen(),
      "root": (context) => const Root(),
      "confirmation_screen": (context) => ConfirmationScreen(),
      'home_root': (context) => const HomeWrapper()
    },
    theme: ThemeData(
      appBarTheme: const AppBarTheme(color: Colors.blueGrey),
      inputDecorationTheme: const InputDecorationTheme(
          focusColor: Colors.amber, labelStyle: TextStyle(color: Colors.amber)),
      primaryColor: Colors.amber,
    ),
    home: const Root(),
  )));
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      final groupID = UserPreferences.getGroupId();
      FirebaseFirestore.instance
          .collection("groups")
          .doc(groupID)
          .get()
          .then((value) {
        context.read(groupNameProvider).state = value.get("name");
        // log(context.read(groupNameProvider).state + " the group name");
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context,
          T Function<T>(ProviderBase<Object?, T>) see, Widget? child) {
        final _authState = see(authStateProvider);
        // return _authState.data == null ? const Register() : const HomeWrapper();
        return _authState.when(
            data: (data) {
              return data == null ? const Register() : const HomeWrapper();
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, trace) {
              return Text(e.toString());
            });
      },
    );
  }
}
