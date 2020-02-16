import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class SingleDigitEditScreen extends StatefulWidget {
  final Function callback;

  SingleDigitEditScreen({Key key, this.callback}) : super(key: key);

  @override
  _SingleDigitEditScreenState createState() => _SingleDigitEditScreenState();
}

class _SingleDigitEditScreenState extends State<SingleDigitEditScreen> {
  SharedPreferences sharedPreferences;
  List<SingleDigitData> singleDigitData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, singleDigitEditFirstHelpKey, SingleDigitEditScreenHelp());
    if (await prefs.getString(singleDigitKey) == null) {
      singleDigitData =
          debugModeEnabled ? defaultSingleDigitData3 : defaultSingleDigitData1;
      await prefs.setString(singleDigitKey, json.encode(singleDigitData));
    } else {
      singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    }
    setState(() {});
  }

  callback(newSingleDigitData) async {
    // check if all data is complete
    setState(() {
      singleDigitData = newSingleDigitData;
    });
    bool entriesComplete = true;
    for (int i = 0; i < singleDigitData.length; i++) {
      if (singleDigitData[i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = await prefs.getBool(singleDigitEditCompleteKey);
    if (entriesComplete && completedOnce == null) {
      await prefs.updateActivityVisible('SingleDigitPractice', true);
      await prefs.updateActivityState('SingleDigitEdit', 'review');
      showSnackBar(
          scaffoldState: _scaffoldKey.currentState,
          snackBarText:
              'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          backgroundColor: colorSingleDigitDarker,
          durationSeconds: 5);
      await prefs.setBool(singleDigitEditCompleteKey, true);
      widget.callback();
    }
  }

  List<EditCard> getSingleDigitEditCards() {
    List<EditCard> singleDigitViews = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        EditCard singleDigitEditCard = EditCard(
          entry: SingleDigitData(
              singleDigitData[i].index,
              singleDigitData[i].digits,
              singleDigitData[i].object,
              singleDigitData[i].familiarity),
          callback: callback,
          activityKey: 'SingleDigit',
        );
        singleDigitViews.add(singleDigitEditCard);
      }
    }
    return singleDigitViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Single digit: view/edit'),
          backgroundColor: Colors.amber[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitEditScreenHelp();
                    }));
              },
            ),
          ]),
      body: Center(
          child: ListView(
        children: getSingleDigitEditCards(),
      )),
    );
  }
}

class SingleDigitEditScreenHelp extends StatelessWidget {

  final information = [
    '    Welcome to your first system, the single digit system! '
        'The idea behind this system is to link the nine digits (0-9) to different objects. \n'
        '    Numbers are abstract and difficult to remember, but if we '
        'convert them to images, especially strange and vivid images, they suddenly '
        'becomes much easier to remember. For sequences of numbers, we simply string them together '
        'into the scenes of a strange story. ',
    '    The example values I\'ve inserted here uses the '
        'idea of a "shape" pattern. That is, each object corresponds to what the '
        'actual digit it represents is shaped like. For example, 1 looks like a '
        'stick, 4 like a sailboat. \n    Another pattern could be "rhyming". 2 could be '
        'shoe, 5 could be a bee hive. Or maybe you just have a a strong association with a certain '
        'object for particular digits! ',
    '    You can really assign anything '
        'to any digit, it just makes it easier to remember (initially) if you have some kind of pattern. '
        'Make sure that the objects don\'t overlap conceptually, as much as possible! \n    It\'s totally '
        'ok to change digit associations as you progress, but don\'t forget that '
        'when you edit a digit it will reset your familiarity for that object back to zero! '
        'Familiarity is listed on the right side of the tiles. ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Single Digit Edit/View',
      information: information,
      buttonColor: Colors.amber[100],
      buttonSplashColor: Colors.amber[300],
      firstHelpKey: singleDigitEditFirstHelpKey,
    );
  }
}
