import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class PAOPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOPracticeScreen({this.callback, this.globalKey});

  @override
  _PAOPracticeScreenState createState() => _PAOPracticeScreenState();
}

class _PAOPracticeScreenState extends State<PAOPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData = [];
  List<Widget> paoCards = [];
  bool dataReady = false;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoPracticeFirstHelpKey,
        PAOPracticeScreenHelp());
    paoData = await prefs.getSharedPrefs(paoKey);
    bool allComplete = true;
    for (int i = 0; i < paoData.length; i++) {
      if (paoData[i].familiarity < 100) {
        allComplete = false;
      }
    }
    if (!allComplete) {
      var tempPAOData = paoData;
      paoData = [];
      tempPAOData.forEach((s) {
        if (s.familiarity < 100) {
          paoData.add(s);
        }
      });
    }
    setState(() {
      paoData = shuffle(paoData);
      dataReady = true;
    });
  }

  callback(bool success) {
    widget.callback();
  }

  void nextActivity() async {
    await prefs.updateActivityState(paoPracticeKey, 'review');
    await prefs.updateActivityVisible(paoMultipleChoiceTestKey, true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('PAO: practice'),
            backgroundColor: colorPAOStandard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return PAOPracticeScreenHelp();
                      }));
                },
              ),
            ]),
        body: dataReady? CardTestScreen(
          cardData: paoData,
          cardType: 'FlashCard',
          globalKey: widget.globalKey,
          nextActivity: nextActivity,
          systemKey: paoKey,
          color: colorPAOStandard,
          lighterColor: colorPAOLighter,
          familiarityTotal: 10000,
        ) : Container());
  }
}

class PAOPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Practice',
      information: [
        '    Get perfect familiarities for each set of digits and '
            'the first test will be unlocked! Good luck!'
      ],
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoPracticeFirstHelpKey,
    );
  }
}
