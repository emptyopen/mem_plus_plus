import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class AlphabetWrittenTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetWrittenTestScreen({this.callback, this.globalKey});

  @override
  _AlphabetWrittenTestScreenState createState() =>
      _AlphabetWrittenTestScreenState();
}

class _AlphabetWrittenTestScreenState extends State<AlphabetWrittenTestScreen> {
  List<AlphabetData> alphabetData;
  bool dataReady = false;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, alphabetWrittenTestFirstHelpKey, AlphabetWrittenTestScreenHelp());
    alphabetData = await prefs.getSharedPrefs(alphabetKey);
    alphabetData = shuffle(alphabetData);
    dataReady = true;
    setState(() {});
  }

  void nextActivity() async {
    if (await prefs.getActivityState(alphabetWrittenTestKey) == 'todo') {
      await prefs.updateActivityState(alphabetWrittenTestKey, 'review');
      await prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
    }
    widget.callback();
  }

  callback() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Alphabet: written test'),
            backgroundColor: Colors.blue[200],
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return AlphabetWrittenTestScreenHelp();
                      }));
                },
              ),
            ]),
        body: dataReady
          ? CardTestScreen(
              cardData: alphabetData,
              cardType: 'WrittenCard',
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

class AlphabetWrittenTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Written Test',
      information: [
        '    Welcome to your first written test! In this section, you will be tested on your familiarity with '
            'each letter. Every time you load this page, the letters will be scattered in a random order, '
            'and you simply have to write in the correct object. If you get a perfect score, '
            'the next test will be unlocked! Good luck!\n\n    Small typos are allowed!'
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetWrittenTestFirstHelpKey,
    );
  }
}
