import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/components/standard.dart';

class SettingsScreen extends StatefulWidget {
  final Function callback;
  final Function resetAll;
  final Function resetActivities;
  final Function maxOutKeys;

  SettingsScreen({Key key, this.callback, this.resetAll, this.resetActivities, this.maxOutKeys}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map customMemories = {};
  Column customMemoriesColumn = Column();
  List<bool> isSelected = [true, false];
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();

    if (await prefs.getBool(darkModeKey) == null || !(await prefs.getBool(darkModeKey))) {
      isSelected = [true, false];
    } else {
      isSelected = [false, true];
    }
    setState(() {});
  }

  setDarkMode(bool setDarkMode) async {
    await prefs.setBool(darkModeKey, setDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Colors.grey[300],
        ),
        body: Container(
          decoration: BoxDecoration(color: backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: Text('Toggle dark mode', style: TextStyle(color: backgroundHighlightColor, fontSize: 20),)),
              SizedBox(height: 20,),
              ToggleButtons(
                children: <Widget>[
                  Icon(Icons.brightness_5),
                  Icon(Icons.brightness_3),
                ],
                borderColor: backgroundHighlightColor,
                selectedBorderColor: backgroundHighlightColor,
                selectedColor: Colors.greenAccent,
                color: backgroundHighlightColor,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        backgroundColor = Colors.grey[800];
                        backgroundHighlightColor = Colors.white;
                        backgroundSemiColor = Colors.grey[600];
                        backgroundSemiHighlightColor = Colors.grey[200];
                        isSelected[buttonIndex] = true;
                        setDarkMode(true);
                      } else {
                        backgroundColor = Colors.white;
                        backgroundHighlightColor = Colors.black;
                        backgroundSemiColor = Colors.grey[200];
                        backgroundSemiHighlightColor = Colors.grey[800];
                        isSelected[buttonIndex] = false;
                        setDarkMode(false);
                      }
                    }
                  });
                },
                isSelected: isSelected,
              ),
              SizedBox(height: 40,),
              Text('Developer options:   (dangerous!)', style: TextStyle(fontSize: 18, color: backgroundHighlightColor),),
              SizedBox(height: 20,),
                    BasicFlatButton(
                      onPressed: () => widget.resetActivities(),
                      text: 'reset activity states, but not data',
                    ),
                    BasicFlatButton(
                      onPressed: () => widget.maxOutKeys(),
                      text: 'max out everything',
                    ),
                    BasicFlatButton(
                      onPressed: () => widget.resetAll(),
                      text: 'reset everything',
                    ),
            ],
          ),
        ));
  }
}
