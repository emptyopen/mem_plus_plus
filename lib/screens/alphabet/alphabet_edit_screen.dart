import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AlphabetEditScreen extends StatefulWidget {
  final Function callback;

  AlphabetEditScreen({Key key, this.callback}) : super(key: key);

  @override
  _AlphabetEditScreenState createState() => _AlphabetEditScreenState();
}

class _AlphabetEditScreenState extends State<AlphabetEditScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    await prefs.checkFirstTime(
        context, alphabetEditFirstHelpKey, AlphabetEditScreenHelp());
    if (await prefs.getString(alphabetKey) == null) {
      alphabetData =
          debugModeEnabled ? defaultAlphabetData3 : defaultAlphabetData1;
      prefs.setString(alphabetKey, json.encode(alphabetData));
    } else {
      alphabetData = await prefs.getSharedPrefs(alphabetKey);
    }
    setState(() {});
  }

  callback(newAlphabetData) async {
    setState(() {
      alphabetData = newAlphabetData;
    });
    // check if all data is complete
    bool entriesComplete = true;
    for (int i = 0; i < alphabetData.length; i++) {
      if (alphabetData[i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = await prefs.getActivityVisible(alphabetPracticeKey);
    if (entriesComplete && !completedOnce) {
      await prefs.updateActivityVisible(alphabetPracticeKey, true);
      await prefs.updateActivityState(alphabetEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CabinSketch', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorAlphabetDarker,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getAlphabetEditCards() {
    List<EditCard> alphabetViews = [];
    if (alphabetData != null) {
      for (int i = 0; i < alphabetData.length; i++) {
        EditCard alphabetEditCard = EditCard(
          entry: AlphabetData(alphabetData[i].index, alphabetData[i].letter,
              alphabetData[i].object, alphabetData[i].familiarity),
          callback: callback,
          activityKey: alphabetKey,
        );
        alphabetViews.add(alphabetEditCard);
      }
    }
    return alphabetViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Alphabet: view/edit'),
          backgroundColor: Colors.blue[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AlphabetEditScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
            child: ListView(
          children: getAlphabetEditCards(),
        )),
      ),
    );
  }
}

class AlphabetEditScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet View/Edit',
      information: [
        '    OK! Welcome to the 2nd system, the Alphabet system! I\'m getting very excited for you!\n    '
            'What we\'re going to do here is just like last time, except now with letters of '
            'the alphabet!\n    Remember, we want to attach objects that are unique, and easy to attach to stories!'
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetEditFirstHelpKey,
    );
  }
}
