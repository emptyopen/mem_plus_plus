import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class AlphabetPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetPracticeScreen({this.callback, this.globalKey});

  @override
  _AlphabetPracticeScreenState createState() => _AlphabetPracticeScreenState();
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  List<Widget> alphabetCards = [];
  bool dataReady = false;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    alphabetData = await prefs.getSharedPrefs(alphabetKey);
    bool allComplete = true;
    for (int i = 0; i < alphabetData.length; i++) {
      if (alphabetData[i].familiarity < 100) {
        allComplete = false;
      }
    }
    if (!allComplete) {
      var tempAlphabetData = alphabetData;
      alphabetData = [];
      tempAlphabetData.forEach((data) {
        if (data.familiarity < 100) {
          alphabetData.add(data);
        }
      });
    }
    setState(() {
      alphabetData = shuffle(alphabetData);
      dataReady = true;
    });
  }

  callback(bool success) {
    widget.callback();
  }

  void nextActivity() async {
    await prefs.updateActivityState(alphabetPracticeKey, 'review');
    await prefs.updateActivityVisible(alphabetWrittenTestKey, true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Alphabet: practice'),
        backgroundColor: Colors.blue[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return AlphabetPracticeScreenHelp();
                  }));
            },
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            HapticFeedback.heavyImpact();
            Navigator.of(context).pop('test');
          },
        ),
      ),
      body: dataReady
          ? CardTestScreen(
              cardData: alphabetData,
              cardType: 'FlashCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: alphabetKey,
              color: colorAlphabetStandard,
              lighterColor: colorAlphabetLighter,
              familiarityTotal: 2600,
            )
          : Container(),
    );
  }
}

class AlphabetPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Practice',
      information: [
        '    You know the drill, get cracking :) ',
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetPracticeFirstHelpKey,
    );
  }
}
