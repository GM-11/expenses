import 'package:expenses/screens/confirmation_screen.dart';
import 'package:expenses/screens/home_screen.dart';
import 'package:expenses/shared/shared_prefs.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({Key? key}) : super(key: key);

  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  @override
  Widget build(BuildContext context) {
    final firstTime = UserPreferences.getIfFirstTime();
    return firstTime ? const AskDetails() : const HomeScreen();
  }
}

// ignore: must_be_immutable
class AskDetails extends StatefulWidget {
  const AskDetails({Key? key}) : super(key: key);

  @override
  _AskDetailsState createState() => _AskDetailsState();
}

class _AskDetailsState extends State<AskDetails> {
  final PageController _usingForController = PageController();

  int? type;

  int? groupValue = 0;
  bool joinGroup = false;
  bool creatGroup = false;
  int selectedIndex = 0;
  bool selected = false;

  final _incomePersonalController = TextEditingController();
  final _joinGroupController = TextEditingController();
  final _createGroupController = TextEditingController();

  final _scroll = ScrollController();
  final _scrol = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextStyle _heading = const TextStyle(
        color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 18);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Using for",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600)),
            ),
            flex: 1,
          ),
          Flexible(
            flex: 2,
            child: CupertinoSlidingSegmentedControl<int>(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              backgroundColor: Colors.amber.withOpacity(.2),
              thumbColor: Colors.amber,
              groupValue: groupValue,
              onValueChanged: (value) {
                setState(() {
                  groupValue = value;

                  groupValue == 1
                      ? _usingForController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease)
                      : _usingForController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                });
              },
              children: {
                0: headingBox("Personal Use"),
                1: headingBox("Group Use"),
              },
            ),
          ),
          Flexible(
            flex: 7,
            child: PageView(
              controller: _usingForController,
              onPageChanged: (val) {
                setState(() {
                  groupValue = val;
                });
              },
              children: [
                // PERSONAL USE SCREEN
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Text(
                            "Enter your Monthly income to begin (₹)",
                            style: _heading,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.5),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              onChanged: (_) {
                                setState(() {
                                  selected = true;
                                });
                              },
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.amber,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              controller: _incomePersonalController,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.amber),
                            onPressed: selected == false ||
                                    _incomePersonalController.text == ""
                                ? null
                                : () async {
                                    setState(() {
                                      type = 0;
                                    });

                                    Navigator.of(context).push(PageTransition(
                                        childCurrent: widget,
                                        type: PageTransitionType
                                            .rightToLeftJoined,
                                        child: ConfirmationScreen(
                                          type: 0,
                                          group: _incomePersonalController.text,
                                        )));
                                  },
                            child: const Text("Continue")),
                      ],
                    ),
                  ),
                ),

                // GROUP USE SCREEN
                Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 37.0,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.amber),
                            onPressed: () {
                              setState(() {
                                joinGroup = !joinGroup;
                                creatGroup = false;
                              });

                              _scrol.animateTo(
                                _scrol.position.maxScrollExtent,
                                duration: const Duration(microseconds: 50),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            child: const Text(
                              "Join Group",
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          height: joinGroup
                              ? MediaQuery.of(context).size.height / 5
                              : MediaQuery.of(context).size.height * 0,
                          padding: const EdgeInsets.all(5.0),
                          child: ListView(
                            controller: _scrol,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                height: MediaQuery.of(context).size.height / 12,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: TextField(
                                  enabled: joinGroup,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  cursorColor: Colors.amber,
                                  decoration: const InputDecoration(
                                      hintText: "Enter group id",
                                      border: InputBorder.none),
                                  controller: _joinGroupController,
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                    elevation: 0.0,
                                  ),
                                  onPressed: _joinGroupController.text.length <
                                          3
                                      ? null
                                      : () {
                                          setState(() {
                                            type = 1;
                                          });
                                          Navigator.of(context).push(
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .rightToLeftJoined,
                                                  childCurrent: widget,
                                                  child: ConfirmationScreen(
                                                    type: 1,
                                                    groupType: 'join',
                                                    group: _joinGroupController
                                                        .text,
                                                  )));
                                        },
                                  child: const Text("Proceed")),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Flexible(
                              child: Divider(
                                color: Colors.blueGrey,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "OR",
                                style: TextStyle(color: Colors.amber),
                              ),
                            ),
                            Flexible(
                              child: Divider(
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 37.0,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.amber),
                            onPressed: () {
                              setState(() {
                                creatGroup = !creatGroup;
                                joinGroup = false;
                              });

                              _scroll.animateTo(
                                _scroll.position.maxScrollExtent,
                                duration: const Duration(microseconds: 50),
                                curve: Curves.fastOutSlowIn,
                              );
                            },
                            child: const Text(
                              "Create Group",
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                          height: creatGroup
                              ? MediaQuery.of(context).size.height / 5
                              : MediaQuery.of(context).size.height * 0,
                          padding: const EdgeInsets.all(5.0),
                          child: ListView(
                            controller: _scroll,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                height: MediaQuery.of(context).size.height / 12,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: TextField(
                                  enabled: creatGroup,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                  cursorColor: Colors.amber,
                                  decoration: const InputDecoration(
                                      hintText: "Enter group name",
                                      border: InputBorder.none),
                                  controller: _createGroupController,
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueGrey,
                                    elevation: 0.0,
                                  ),
                                  onPressed:
                                      _createGroupController.text.length < 3
                                          ? null
                                          : () async {
                                              setState(() {
                                                type = 1;
                                              });

                                              Navigator.of(context).push(
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .rightToLeftJoined,
                                                      childCurrent: widget,
                                                      child: ConfirmationScreen(
                                                        type: 0,
                                                        groupType: 'create',
                                                        group:
                                                            _createGroupController
                                                                .text,
                                                      )));
                                            },
                                  child: const Text("Proceed"))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget headingBox(String text) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Text(text, style: const TextStyle(color: Colors.blueGrey)),
  );
}
