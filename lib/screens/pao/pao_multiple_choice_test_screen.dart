import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
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

  PAOMultipleChoiceTestScreen(
      {required this.callback, required this.globalKey});

  @override
  _PAOMultipleChoiceTestScreenState createState() =>
      _PAOMultipleChoiceTestScreenState();
}

class _PAOMultipleChoiceTestScreenState
    extends State<PAOMultipleChoiceTestScreen> {
  List<PAOData> paoData = [];
  List<Widget> paoCards = [];
  bool dataReady = false;
  late List<PAOData> shuffledChoices;
  List fakeData = [];

  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoMultipleChoiceTestFirstHelpKey,
        PAOMultipleChoiceScreenHelp());
    paoData = prefs.getSharedPrefs(paoKey) as List<PAOData>;
    paoData = shuffle(paoData);

    paoData.forEach((entry) {
      PAOData? fakeChoice1;
      PAOData? fakeChoice2;
      PAOData? fakeChoice3;

      List<String> notAllowed = [entry.object];
      while (fakeChoice1 == null) {
        PAOData candidate = paoData[Random().nextInt(paoData.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeChoice1 = candidate;
          notAllowed.add(candidate.object);
        }
      }
      while (fakeChoice2 == null) {
        PAOData candidate = paoData[Random().nextInt(paoData.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeChoice2 = candidate;
          notAllowed.add(candidate.object);
        }
      }
      while (fakeChoice3 == null) {
        PAOData candidate = paoData[Random().nextInt(paoData.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeChoice3 = candidate;
          notAllowed.add(candidate.object);
        }
      }
      shuffledChoices = [
        entry,
        fakeChoice1,
        fakeChoice2,
        fakeChoice3,
      ];
      shuffledChoices = shuffle(shuffledChoices);
      fakeData.add(shuffledChoices);
    });

    dataReady = true;

    setState(() {});
  }

  void nextActivity() async {
    if (prefs.getActivityState(paoMultipleChoiceTestKey) == 'todo') {
      prefs.updateActivityState(paoMultipleChoiceTestKey, 'review');
      prefs.updateActivityVisible(paoTimedTestPrepKey, true);
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
          backgroundColor: colorPAOStandard,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
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
      information: [
        '    Alright! Time for a test on your PAO system. If you get a perfect score, '
            'the next test will be unlocked! Good luck!'
      ],
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoMultipleChoiceTestFirstHelpKey,
    );
  }
}
