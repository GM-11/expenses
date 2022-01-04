import 'dart:developer';

import 'package:expenses/services/authentications.dart';
import 'package:expenses/shared/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _style =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

    return Consumer(
      builder: (BuildContext context,
          T Function<T>(ProviderBase<Object?, T>) see, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(see(groupNameProvider).state.toString()),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Authentications().signOut();
                  },
                  icon: const Icon(Icons.person))
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 3.0,
                      color: Colors.amber[600],
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Monthly Income:",
                              style: _style,
                            ),
                            Text(
                              "₹ (some random number)",
                              style: _style,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 3.0,
                      color: Colors.amber[600],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          children: [
                            Text(
                              "Monthly Expenses:",
                              style: _style,
                            ),
                            Text(
                              "₹ (some random number)",
                              style: _style,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
