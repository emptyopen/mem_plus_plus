import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AlphabetEditScreen extends StatefulWidget {
  final Function callback;

  AlphabetEditScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _AlphabetEditScreenState createState() => _AlphabetEditScreenState();
}

class _AlphabetEditScreenState extends State<AlphabetEditScreen> {
  late SharedPreferences sharedPreferences;
  late List<AlphabetData> alphabetData;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    await prefs.checkFirstTime(
        context, alphabetEditFirstHelpKey, AlphabetEditScreenHelp());
    if (prefs.getString(alphabetKey) == '') {
      alphabetData =
          debugModeEnabled ? defaultAlphabetData3 : defaultAlphabetData1;
      prefs.setString(alphabetKey, json.encode(alphabetData));
    } else {
      alphabetData = prefs.getSharedPrefs(alphabetKey) as List<AlphabetData>;
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
    bool completedOnce = prefs.getActivityVisible(alphabetPracticeKey);
    if (entriesComplete && !completedOnce) {
      prefs.updateActivityVisible(alphabetPracticeKey, true);
      prefs.updateActivityState(alphabetEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style:
              TextStyle(color: Colors.white, fontFamily: 'Viga', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorAlphabetDarker,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getAlphabetEditCards() {
    List<EditCard> alphabetViews = [];
    for (int i = 0; i < alphabetData.length; i++) {
      EditCard alphabetEditCard = EditCard(
        entry: AlphabetData(alphabetData[i].index, alphabetData[i].letter,
            alphabetData[i].object, alphabetData[i].familiarity),
        callback: callback,
        activityKey: alphabetKey,
      );
      alphabetViews.add(alphabetEditCard);
    }
    return alphabetViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
    return HelpDialog(
      title: 'The Alphabet System',
      information: [
        '    OK! Welcome to the 2nd system, the Alphabet system! I\'m getting very excited for you!\n    '
            'What we\'re going to do here is just like last time, except now with letters of '
            'the alphabet!\n    Remember, we want to attach objects that are unique, and easy to attach to stories!'
      ],
      buttonColor: Colors.blue[100]!,
      buttonSplashColor: Colors.blue[300]!,
      firstHelpKey: alphabetEditFirstHelpKey,
    );
  }
}
