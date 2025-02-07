import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class TripleDigitMultipleChoiceTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  TripleDigitMultipleChoiceTestScreen(
      {required this.callback, required this.globalKey});

  @override
  _TripleDigitMultipleChoiceTestScreenState createState() =>
      _TripleDigitMultipleChoiceTestScreenState();
}

class _TripleDigitMultipleChoiceTestScreenState
    extends State<TripleDigitMultipleChoiceTestScreen> {
  List<TripleDigitData> tripleDigitData = [];
  List fakeData = [];
  List<Widget> tripleDigitCards = [];
  bool dataReady = false;
  late List<TripleDigitData> shuffledChoices;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, tripleDigitMultipleChoiceTestFirstHelpKey,
        TripleDigitMultipleChoiceScreenHelp(callback: widget.callback));
    tripleDigitData =
        prefs.getSharedPrefs(tripleDigitKey) as List<TripleDigitData>;
    tripleDigitData = shuffle(tripleDigitData) as List<TripleDigitData>;

    tripleDigitData.forEach((entry) {
      TripleDigitData? fakeChoice1;
      TripleDigitData? fakeChoice2;
      TripleDigitData? fakeChoice3;

      List<int> notAllowed = [entry.index];
      while (fakeChoice1 == null) {
        TripleDigitData candidate =
            tripleDigitData[Random().nextInt(tripleDigitData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice1 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice2 == null) {
        TripleDigitData candidate =
            tripleDigitData[Random().nextInt(tripleDigitData.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeChoice2 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeChoice3 == null) {
        TripleDigitData candidate =
            tripleDigitData[Random().nextInt(tripleDigitData.length)];
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
      shuffledChoices = shuffle(shuffledChoices) as List<TripleDigitData>;
      fakeData.add(shuffledChoices);
    });

    dataReady = true;
    setState(() {});
  }

  nextActivity() {
    if (prefs.getActivityState(tripleDigitMultipleChoiceTestKey) == 'todo') {
      prefs.updateActivityState(tripleDigitMultipleChoiceTestKey, 'review');
      prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
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
          title: Text('Triple digit: multiple choice test',
              style: TextStyle(fontSize: 18)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: colorTripleDigitStandard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return TripleDigitMultipleChoiceScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: dataReady
          ? CardTestScreen(
              cardData: tripleDigitData,
              cardType: 'MultipleChoiceCard',
              globalKey: widget.globalKey,
              nextActivity: nextActivity,
              systemKey: tripleDigitKey,
              color: colorTripleDigitStandard,
              lighterColor: colorTripleDigitLighter,
              familiarityTotal: 100000,
              shuffledChoices: fakeData,
            )
          : Container(),
    );
  }
}

class TripleDigitMultipleChoiceScreenHelp extends StatelessWidget {
  final Function callback;
  TripleDigitMultipleChoiceScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Triple Digit - Multiple Choice Test',
      information: [
        '    You\'re standing on top of a mountain. Let\'s lock this skill down.'
      ],
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: tripleDigitMultipleChoiceTestFirstHelpKey,
      callback: callback,
    );
  }
}
