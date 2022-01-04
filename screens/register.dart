import 'dart:developer';

import 'package:expenses/main.dart';
import 'package:expenses/screens/ask_details.dart';
import 'package:expenses/screens/home_screen.dart';
import 'package:expenses/services/authentications.dart';
import 'package:expenses/shared/shared_prefs.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    UserPreferences.changeFirstTime(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 55.0);
    return PageView(
      children: [
        Scaffold(
          backgroundColor: Colors.amber[600],
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Your expenses", style: _textStyle),
          )),
        ),
        const SignIn()
      ],
    );
  }
}

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final n = TextEditingController();
  final p = TextEditingController();
  final e = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(shrinkWrap: false, children: [
                  const SizedBox(height: 100.0),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: const TextStyle(),
                    controller: n,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(),
                    controller: e,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline_sharp)),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(),
                    controller: p,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.security_sharp),
                      labelText: 'Password',
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.amber),
                      onPressed: () async {
                        dynamic result = await Authentications()
                            .registerUser(e.text, n.text, p.text)
                            .onError((error, stackTrace) =>
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(error.toString()),
                                  backgroundColor: Colors.amber,
                                  elevation: 10.0,
                                )));

                        log(result);
                      },
                      child: const Text("GO")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
