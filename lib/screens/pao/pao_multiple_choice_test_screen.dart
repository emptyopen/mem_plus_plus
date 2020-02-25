import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PAOMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOMultipleChoiceTestScreen({this.callback, this.globalKey});

  @override
  _PAOMultipleChoiceTestScreenState createState() =>
      _PAOMultipleChoiceTestScreenState();
}

class _PAOMultipleChoiceTestScreenState
    extends State<PAOMultipleChoiceTestScreen> {
  List<PAOData> paoData = [];
  List fakeData = [];
  List<Widget> paoCards = [];
  bool dataReady = false;
  List<PAOData> shuffledChoices = [
    PAOData(0, '0', 'nothing', 'nothing', 'nothing', 0),
    PAOData(1, '0', 'nothing', 'nothing', 'nothing', 0),
    PAOData(2, '0', 'nothing', 'nothing', 'nothing', 0),
    PAOData(3, '0', 'nothing', 'nothing', 'nothing', 0),
  ];
  var mapChoices = [
    'digitToPersonActionObject',
    'personActionObjectToDigit',
  ];
  var paoChoices = [
    'person',
    'action',
    'object',
  ];
  int isDigitToObject = 0; // 0 == digitToObject, 1 == objectToDigit

  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoMultipleChoiceTestFirstHelpKey, PAOMultipleChoiceScreenHelp());
    paoData = await prefs.getSharedPrefs(paoKey);
    paoData = shuffle(paoData);

    paoData.forEach((entry) {
      PAOData fakeSingleDigitChoice1;
      PAOData fakeSingleDigitChoice2;
      PAOData fakeSingleDigitChoice3;
      // randomly choose either digit -> object or object -> digit
      isDigitToObject = Random().nextInt(2);
      if (isDigitToObject == 0) {
        // loop until you find 3 random different objects
        List<String> notAllowed = [entry.object];
        while (fakeSingleDigitChoice1 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice1 = candidate;
            notAllowed.add(candidate.object);
          }
        }
        while (fakeSingleDigitChoice2 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice2 = candidate;
            notAllowed.add(candidate.object);
          }
        }
        while (fakeSingleDigitChoice3 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.object)) {
            fakeSingleDigitChoice3 = candidate;
            notAllowed.add(candidate.object);
          }
        }
      } else {
        // loop until you find 3 random different digits
        List<String> notAllowed = [entry.digits];
        while (fakeSingleDigitChoice1 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.digits)) {
            fakeSingleDigitChoice1 = candidate;
            notAllowed.add(candidate.digits);
          }
        }
        while (fakeSingleDigitChoice2 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.digits)) {
            fakeSingleDigitChoice2 = candidate;
            notAllowed.add(candidate.digits);
          }
        }
        while (fakeSingleDigitChoice3 == null) {
          PAOData candidate =
              paoData[Random().nextInt(paoData.length)];
          if (!notAllowed.contains(candidate.digits)) {
            fakeSingleDigitChoice3 = candidate;
            notAllowed.add(candidate.digits);
          }
        }
      }
      shuffledChoices = [
        entry,
        fakeSingleDigitChoice1,
        fakeSingleDigitChoice2,
        fakeSingleDigitChoice3,
      ];
      shuffledChoices = shuffle(shuffledChoices);
      fakeData.add(shuffledChoices);
    });

    dataReady = true;

    setState(() {});
  }

  void nextActivity() async {
    if (await prefs.getActivityState(paoMultipleChoiceTestKey) ==
        'todo') {
      await prefs.updateActivityState(
          paoMultipleChoiceTestKey, 'review');
      await prefs.updateActivityVisible(paoTimedTestPrepKey, true);
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
          title: Text('PAO: multiple choice test'),
        backgroundColor: Colors.pink[200],
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PAOMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
          body: dataReady
          ? CardTestScreen(
              cardData: paoData,
              cardType: 'MultipleChoiceCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: paoKey,
              color: colorPAOStandard,
              lighterColor: colorPAOLighter,
              familiarityTotal: 10000,
              shuffledChoices: fakeData,
            )
          : Container(),
    );
  }
}

class PAOMultipleChoiceScreenHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Multiple Choice Test',
      information: ['    Alright! Time for a test on your PAO system. If you get a perfect score, '
        'the next test will be unlocked! Good luck!'],
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
      firstHelpKey: paoMultipleChoiceTestFirstHelpKey,
    );
  }
}
