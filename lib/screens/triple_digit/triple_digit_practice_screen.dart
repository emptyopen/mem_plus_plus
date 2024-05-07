import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class TripleDigitPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  TripleDigitPracticeScreen({required this.callback, required this.globalKey});

  @override
  _TripleDigitPracticeScreenState createState() =>
      _TripleDigitPracticeScreenState();
}

class _TripleDigitPracticeScreenState extends State<TripleDigitPracticeScreen> {
  List<TripleDigitData> tripleDigitData = [];
  List<Widget> tripleDigitCards = [];
  bool dataReady = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, tripleDigitPracticeFirstHelpKey,
        TripleDigitPracticeScreenHelp(callback: widget.callback));
    tripleDigitData =
        prefs.getSharedPrefs(tripleDigitKey) as List<TripleDigitData>;
    bool allComplete = true;
    for (int i = 0; i < tripleDigitData.length; i++) {
      if (tripleDigitData[i].familiarity < 100) {
        allComplete = false;
      }
    }
    if (!allComplete) {
      var tempTripleDigitData = tripleDigitData;
      tripleDigitData = [];
      tempTripleDigitData.forEach((s) {
        if (s.familiarity < 100) {
          tripleDigitData.add(s);
        }
      });
    }
    setState(() {
      tripleDigitData = shuffle(tripleDigitData) as List<TripleDigitData>;
      dataReady = true;
    });
  }

  callback() {
    widget.callback();
  }

  void nextActivity() async {
    prefs.updateActivityState(tripleDigitPracticeKey, 'review');
    prefs.updateActivityVisible(tripleDigitMultipleChoiceTestKey, true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Triple digit: practice'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return TripleDigitPracticeScreenHelp(
                        callback: widget.callback);
                  }));
            },
          ),
        ],
        backgroundColor: colorTripleDigitStandard,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: dataReady
          ? CardTestScreen(
              cardData: tripleDigitData,
              cardType: 'FlashCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: tripleDigitKey,
              color: colorTripleDigitStandard,
              lighterColor: colorTripleDigitLighter,
              familiarityTotal: 100000,
            )
          : Container(),
    );
  }
}

class TripleDigitPracticeScreenHelp extends StatelessWidget {
  final Function callback;
  TripleDigitPracticeScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Now that you have a complete set of triple digits mapped out, you\'re '
        'ready to get started with practice! \n    Here you will familiarize yourself '
        'with the digit-object mapping until you\'ve maxed out your '
        'familiarity with each digit, after which the first test will be unlocked! ',
    '    We\'ll only show cards that are still ranked less than 100% in familiarity (unless all are at 100% familiarity, '
        'in which case we\'ll show all of them). \n'
        '    Try to guess the object before even hitting the reveal button! It\'ll help you once you really get tested ;)'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Triple Digit - Practice',
      information: information,
      buttonColor: colorTripleDigitStandard,
      buttonSplashColor: colorTripleDigitDarker,
      firstHelpKey: tripleDigitPracticeFirstHelpKey,
      callback: callback,
    );
  }
}
