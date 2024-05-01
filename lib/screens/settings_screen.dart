import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';

import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final Function resetAll;
  final Function resetActivities;
  final Function maxOutKeys;

  SettingsScreen(
      {Key? key,
      required this.resetAll,
      required this.resetActivities,
      required this.maxOutKeys})
      : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map customMemories = {};
  Column customMemoriesColumn = Column();
  List<bool> isSelected = [true, false];
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    if (prefs.getBool(darkModeKey) == null || !(prefs.getBool(darkModeKey))!) {
      isSelected = [true, false];
    } else {
      isSelected = [false, true];
    }
    setState(() {});
  }

  setDarkMode(bool setDarkMode) {
    prefs.setBool(darkModeKey, setDarkMode);
  }

  resetNotifications(BuildContext context) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancelAll();
    final snackBar = SnackBar(
      content: Text(
        'Notifications nuked!',
        style: TextStyle(color: Colors.black, fontFamily: 'Viga', fontSize: 18),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.orange,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            backgroundColor: Colors.grey[300],
            bottom: TabBar(
              tabs: [
                Tab(text: 'Settings', icon: Icon(Icons.settings)),
                Tab(text: 'About the Developer', icon: Icon(Icons.person)),
              ],
            )),
        body: TabBarView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: backgroundColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                      child: Text(
                    'Dark mode:',
                    style: TextStyle(
                        color: backgroundHighlightColor, fontSize: 20),
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  ToggleButtons(
                    children: <Widget>[
                      Icon(Icons.brightness_7),
                      Icon(Icons.brightness_3),
                    ],
                    borderColor: backgroundHighlightColor,
                    selectedBorderColor: backgroundHighlightColor,
                    selectedColor: Colors.amber,
                    color: backgroundHighlightColor,
                    onPressed: (int index) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            backgroundColor = darkBackgroundColorPermanent;
                            backgroundHighlightColor =
                                darkBackgroundHighlightColorPermanent;
                            backgroundSemiColor =
                                darkBackgroundSemiColorPermanent;
                            backgroundSemiHighlightColor =
                                darkBackgroundSemiHighlightColorPermanent;
                            isSelected[buttonIndex] = true;
                            setDarkMode(true);
                          } else {
                            backgroundColor = lightBackgroundColorPermanent;
                            backgroundHighlightColor =
                                lightBackgroundHighlightColorPermanent;
                            backgroundSemiColor =
                                lightBackgroundSemiColorPermanent;
                            backgroundSemiHighlightColor =
                                lightBackgroundSemiHighlightColorPermanent;
                            isSelected[buttonIndex] = false;
                            setDarkMode(false);
                          }
                        }
                      });
                    },
                    isSelected: isSelected,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Other options:',
                    style: TextStyle(
                        fontSize: 18, color: backgroundHighlightColor),
                  ),
                  SizedBox(height: 20),
                  BasicFlatButton(
                    color: Colors.red[400]!,
                    textColor: Colors.white,
                    fontSize: 20,
                    padding: 10,
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      showConfirmDialog(
                          context: context,
                          function: widget.resetAll,
                          confirmColor: Colors.red,
                          confirmText:
                              "Are you sure you want to reset everything? All data will be lost! There\'s no recovery!!");
                    },
                    text: 'Reset everything',
                  ),
                  debugModeEnabled
                      ? Column(
                          children: <Widget>[
                            // BasicFlatButton(
                            //   onPressed: () {
                            //     HapticFeedback.lightImpact();
                            //     resetNotifications(context);
                            //   },
                            //   text: 'Nuke notifications',
                            // ),
                            BasicFlatButton(
                              onPressed: () {
                                widget.maxOutKeys(2);
                              },
                              text: 'complete chapter 2',
                            ),
                            BasicFlatButton(
                              onPressed: () {
                                widget.maxOutKeys(3);
                              },
                              text: 'complete chapter 3',
                            ),
                            BasicFlatButton(
                              onPressed: () {
                                widget.maxOutKeys(4);
                              },
                              text: 'complete chapter 4',
                            ),
                            BasicFlatButton(
                              onPressed: () {
                                widget.maxOutKeys(5);
                              },
                              text: 'max out everything',
                            ),
                            BasicFlatButton(
                              onPressed: () {
                                notify();
                              },
                              text: 'test notification',
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: backgroundSemiHighlightColor),
                          borderRadius: BorderRadius.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(19),
                        child: Image(
                          height: 200,
                          image: AssetImage(
                            'assets/images/matt_aki.jpg',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '    Matt has a cute wife Asya and a cute dog Aki. They all live in LA and are always having a good time.',
                      style: TextStyle(color: backgroundHighlightColor),
                    ),
                    defaultTargetPlatform == TargetPlatform.android
                        ? Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                height: 40,
                                width: 190,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: backgroundHighlightColor),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.yellow[200]!,
                                      Colors.yellow[700]!,
                                    ], // whitish to gray
                                    tileMode: TileMode
                                        .repeated, // repeats the gradient over the canvas
                                  ),
                                ),
                                child: Center(
                                  child: InkWell(
                                    child: AutoSizeText(
                                      'Give Matt coffee money!',
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onTap: () =>
                                        launch('http://paypal.me/takaomatt'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Donating does not unlock any\nadditional features or functionality.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
