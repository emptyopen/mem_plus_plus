import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/card_test_screen.dart';
import 'package:flutter/services.dart';

class PAOPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOPracticeScreen({required this.callback, required this.globalKey});

  @override
  _PAOPracticeScreenState createState() => _PAOPracticeScreenState();
}

class _PAOPracticeScreenState extends State<PAOPracticeScreen> {
  List<PAOData> paoData = [];
  List<Widget> paoCards = [];
  bool dataReady = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoPracticeFirstHelpKey,
        PAOPracticeScreenHelp(callback: widget.callback));
    paoData = prefs.getSharedPrefs(paoKey) as List<PAOData>;
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
      paoData = shuffle(paoData) as List<PAOData>;
      dataReady = true;
    });
  }

  callback(bool success) {
    widget.callback();
  }

  void nextActivity() async {
    prefs.updateActivityState(paoPracticeKey, 'review');
    prefs.updateActivityVisible(paoMultipleChoiceTestKey, true);
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
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return PAOPracticeScreenHelp(callback: widget.callback);
                      }));
                },
              ),
            ]),
        body: dataReady
            ? CardTestScreen(
                cardData: paoData,
                cardType: 'FlashCard',
                globalKey: widget.globalKey,
                nextActivity: nextActivity,
                systemKey: paoKey,
                color: colorPAOStandard,
                lighterColor: colorPAOLighter,
                familiarityTotal: 10000,
              )
            : Container());
  }
}

class PAOPracticeScreenHelp extends StatelessWidget {
  final Function callback;
  PAOPracticeScreenHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'PAO - Practice',
      information: [
        '    Get perfect familiarities for each set of digits and '
            'the first test will be unlocked! Good luck!'
      ],
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoPracticeFirstHelpKey,
      callback: callback,
    );
  }
}
