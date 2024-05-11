import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class SingleDigitMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  SingleDigitMultipleChoiceTestScreen(
      {required this.callback, required this.globalKey});

  @override
  _SingleDigitMultipleChoiceTestScreenState createState() =>
      _SingleDigitMultipleChoiceTestScreenState();
}

class _SingleDigitMultipleChoiceTestScreenState
    extends State<SingleDigitMultipleChoiceTestScreen> {
  List<SingleDigitData> singleDigitData = [];
  List fakeData = [];
  List<Widget> singleDigitCards = [];
  bool dataReady = false;
  late List<SingleDigitData> shuffledChoices;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, singleDigitMultipleChoiceTestFirstHelpKey,
        SingleDigitMultipleChoiceScreenHelp(callback: widget.callback));
    singleDigitData =
        prefs.getSharedPrefs(singleDigitKey) as List<SingleDigitData>;
    singleDigitData = shuffle(singleDigitData) as List<SingleDigitData>;

    singleDigitData.forEach((entry) {
      SingleDigitData? fakeChoice1;
      SingleDigitData? fakeChoice2;
      SingleDigitData? fakeChoice3;

      List<int> notAllowed = [entry.index];
      while (fakeChoice1 == null) {
        SingleDigitData candidate =
            singleDigitData[Random().nextInt(singleDigitData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice1 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice2 == null) {
        SingleDigitData candidate =
            singleDigitData[Random().nextInt(singleDigitData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice2 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice3 == null) {
        SingleDigitData candidate =
            singleDigitData[Random().nextInt(singleDigitData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice3 = candidate;
          notAllowed.add(candidate.index);
        }
      }

      shuffledChoices = [
        entry,
        fakeChoice1,
        fakeChoice2,
        fakeChoice3,
      ];
      shuffledChoices = shuffle(shuffledChoices) as List<SingleDigitData>;
      fakeData.add(shuffledChoices);
    });

    dataReady = true;
    setState(() {});
  }

  void nextActivity() async {
    if (prefs.getActivityState(singleDigitMultipleChoiceTestKey) == 'todo') {
      prefs.updateActivityState(singleDigitMultipleChoiceTestKey, 'review');
      prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
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
          title: Text('Single digit: multiple choice test',
              style: TextStyle(fontSize: 18)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: colorSingleDigitStandard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitMultipleChoiceScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: dataReady
          ? CardTestScreen(
              cardData: singleDigitData,
              cardType: 'MultipleChoiceCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: singleDigitKey,
              color: colorSingleDigitStandard,
              lighterColor: colorSingleDigitLighter,
              familiarityTotal: 1000,
              shuffledChoices: fakeData,
            )
          : Container(),
    );
  }
}

class SingleDigitMultipleChoiceScreenHelp extends StatelessWidget {
  final Function callback;
  SingleDigitMultipleChoiceScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Single Digit - Multiple Choice Test',
      information: [
        '    Welcome to your first multiple choice test! In this section, you will be tested on your familiarity with '
            'each digit. \n    Every time you load this page, the digits and objects will be scattered in a random order, '
            'and you simply have to choose the correct digit or object. If you get a perfect score, the next test will be unlocked! '
            '\n    Good luck!'
      ],
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: singleDigitMultipleChoiceTestFirstHelpKey,
      callback: callback,
    );
  }
}
