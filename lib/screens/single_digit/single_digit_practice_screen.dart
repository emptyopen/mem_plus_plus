import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class SingleDigitPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitPracticeScreen({required this.callback, required this.globalKey});

  @override
  _SingleDigitPracticeScreenState createState() =>
      _SingleDigitPracticeScreenState();
}

class _SingleDigitPracticeScreenState extends State<SingleDigitPracticeScreen> {
  List<SingleDigitData> singleDigitData = [];
  List<Widget> singleDigitCards = [];
  bool dataReady = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, singleDigitPracticeFirstHelpKey,
        SingleDigitPracticeScreenHelp(callback: widget.callback));
    singleDigitData =
        prefs.getSharedPrefs(singleDigitKey) as List<SingleDigitData>;
    bool allComplete = true;
    for (int i = 0; i < singleDigitData.length; i++) {
      if (singleDigitData[i].familiarity < 100) {
        allComplete = false;
      }
    }
    if (!allComplete) {
      var tempSingleDigitData = singleDigitData;
      singleDigitData = [];
      tempSingleDigitData.forEach((s) {
        if (s.familiarity < 100) {
          singleDigitData.add(s);
        }
      });
    }
    setState(() {
      singleDigitData = shuffle(singleDigitData) as List<SingleDigitData>;
      dataReady = true;
    });
  }

  callback() {
    widget.callback();
  }

  void nextActivity() async {
    prefs.updateActivityState(singleDigitPracticeKey, 'review');
    prefs.updateActivityVisible(singleDigitMultipleChoiceTestKey, true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Single digit: practice', style: TextStyle(fontSize: 18)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return SingleDigitPracticeScreenHelp(
                        callback: widget.callback);
                  }));
            },
          ),
        ],
        backgroundColor: Colors.amber[200],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: dataReady
          ? CardTestScreen(
              cardData: singleDigitData,
              cardType: 'FlashCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: singleDigitKey,
              color: colorSingleDigitStandard,
              lighterColor: colorSingleDigitLighter,
              familiarityTotal: 1000,
            )
          : Container(),
    );
  }
}

class SingleDigitPracticeScreenHelp extends StatelessWidget {
  final Function callback;
  SingleDigitPracticeScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Now that you have a complete set of single digits mapped out, you\'re '
        'ready to get started with practice! \n    Here you will familiarize yourself '
        'with the digit-object mapping until you\'ve maxed out your '
        'familiarity with each digit, after which the first test will be unlocked! ',
    '    We\'ll only show cards that are still ranked less than 100% in familiarity (unless all are at 100% familiarity, '
        'in which case we\'ll show all of them). \n'
        '    Try to guess the object before even hitting the reveal button! It\'ll help you once you really get tested.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Single Digit - Practice',
      information: information,
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: singleDigitPracticeFirstHelpKey,
      callback: callback,
    );
  }
}
