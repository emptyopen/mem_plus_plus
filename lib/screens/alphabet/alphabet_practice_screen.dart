import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
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

  AlphabetPracticeScreen({required this.callback, required this.globalKey});

  @override
  _AlphabetPracticeScreenState createState() => _AlphabetPracticeScreenState();
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  late SharedPreferences sharedPreferences;
  late List<AlphabetData> alphabetData;
  List<Widget> alphabetCards = [];
  bool dataReady = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    alphabetData = prefs.getSharedPrefs(alphabetKey) as List<AlphabetData>;
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
      alphabetData = shuffle(alphabetData) as List<AlphabetData>;
      dataReady = true;
    });
  }

  callback(bool success) {
    widget.callback();
  }

  void nextActivity() async {
    prefs.updateActivityState(alphabetPracticeKey, 'review');
    prefs.updateActivityVisible(alphabetWrittenTestKey, true);
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
              HapticFeedback.lightImpact();
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
            HapticFeedback.lightImpact();
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
        '    If you find that you can\'t remember your word because other words starting with that letter keep '
            'bubbling up in your mind, consider using one of those words instead! \n    You can always go back to the edit page and update your '
            'letters :) ',
      ],
      buttonColor: Colors.blue[100]!,
      buttonSplashColor: Colors.blue[300]!,
      firstHelpKey: alphabetPracticeFirstHelpKey,
    );
  }
}
