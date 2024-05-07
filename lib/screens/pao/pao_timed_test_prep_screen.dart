import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';

import 'package:flutter/services.dart';

class PAOTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PAOTimedTestPrepScreen({required this.callback});

  @override
  _PAOTimedTestPrepScreenState createState() => _PAOTimedTestPrepScreenState();
}

class _PAOTimedTestPrepScreenState extends State<PAOTimedTestPrepScreen> {
  String digits1 = '';
  String digits2 = '';
  String digits3 = '';
  String digits4 = '';
  String digits5 = '';
  String digits6 = '';
  String digits7 = '';
  String digits8 = '';
  String digits9 = '';
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: debugTestTime) : Duration(hours: 4);
  List<String> possibleValues = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59',
    '60',
    '61',
    '62',
    '63',
    '64',
    '65',
    '66',
    '67',
    '68',
    '69',
    '70',
    '71',
    '72',
    '73',
    '74',
    '75',
    '76',
    '77',
    '78',
    '79',
    '80',
    '81',
    '82',
    '83',
    '84',
    '85',
    '86',
    '87',
    '88',
    '89',
    '90',
    '91',
    '92',
    '93',
    '94',
    '95',
    '96',
    '97',
    '98',
    '99',
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoTimedTestPrepFirstHelpKey,
        PAOTimedTestPrepScreenHelp(callback: widget.callback));
    // if digits are null, randomize values and store them,
    // then update DateTime available for paoTest
    if (!prefs.getBool(paoTestActiveKey)) {
      print('no active test, setting new values');
      var random = new Random();
      digits1 = possibleValues[random.nextInt(possibleValues.length)];
      digits2 = possibleValues[random.nextInt(possibleValues.length)];
      digits3 = possibleValues[random.nextInt(possibleValues.length)];
      digits4 = possibleValues[random.nextInt(possibleValues.length)];
      digits5 = possibleValues[random.nextInt(possibleValues.length)];
      digits6 = possibleValues[random.nextInt(possibleValues.length)];
      digits7 = possibleValues[random.nextInt(possibleValues.length)];
      digits8 = possibleValues[random.nextInt(possibleValues.length)];
      digits9 = possibleValues[random.nextInt(possibleValues.length)];
      prefs.setString('paoTestDigits1', digits1);
      prefs.setString('paoTestDigits2', digits2);
      prefs.setString('paoTestDigits3', digits3);
      prefs.setString('paoTestDigits4', digits4);
      prefs.setString('paoTestDigits5', digits5);
      prefs.setString('paoTestDigits6', digits6);
      prefs.setString('paoTestDigits7', digits7);
      prefs.setString('paoTestDigits8', digits8);
      prefs.setString('paoTestDigits9', digits9);
      prefs.setBool(paoTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = prefs.getString('paoTestDigits1');
      digits2 = prefs.getString('paoTestDigits2');
      digits3 = prefs.getString('paoTestDigits3');
      digits4 = prefs.getString('paoTestDigits4');
      digits5 = prefs.getString('paoTestDigits5');
      digits6 = prefs.getString('paoTestDigits6');
      digits7 = prefs.getString('paoTestDigits7');
      digits8 = prefs.getString('paoTestDigits8');
      digits9 = prefs.getString('paoTestDigits9');
    }
    setState(() {});
  }

  void updateStatus() async {
    prefs.setBool(paoTestActiveKey, false);
    prefs.updateActivityState(paoTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(paoTimedTestPrepKey, false);
    prefs.updateActivityState(paoTimedTestKey, 'todo');
    prefs.updateActivityVisible(paoTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        paoTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (PAO) is ready!', 'Good luck!',
        paoTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('PAO: timed test prep'),
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
                      return PAOTimedTestPrepScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              'Your sequences are: ',
              style: TextStyle(fontSize: 34, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 50,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits1,
                color: Colors.pink[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits2,
                color: Colors.pink[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits3,
                color: Colors.pink[200]!,
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits4,
                color: Colors.pink[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits5,
                color: Colors.pink[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits6,
                color: Colors.pink[200]!,
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits7,
                color: Colors.pink[50]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits8,
                color: Colors.pink[100]!,
              ),
              TimedTestPrepRowContainer(
                digits: digits9,
                color: Colors.pink[200]!,
              ),
            ]),
            SizedBox(
              height: 50,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorPAOLighter,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The sequences will no longer be available to view!',
                  confirmColor: colorPAOStandard),
              fontSize: 30,
              padding: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in four hours!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PAOTimedTestPrepScreenHelp extends StatelessWidget {
  final Function callback;
  PAOTimedTestPrepScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'PAO - Timed Test Preparation',
      information: [
        '    Alright! Now you\'re going to convert these three sets of six digits into three scenes, '
            'and link the scenes together. Remember, person-action-object, and really create a connection '
            'between scenes. ',
        '    Say your first scene is (1) Galileo fervently (2) cooking with a (3) paintbrush, and your second scene '
            'is (4) Sandra Bullock (5) slam-dunking some (6) poker chips. To thread the scenes, we simply connect '
            'something from the first scene to the beginning of the second scene.\n\n    Maybe Galileo (with a chef\'s hat) finishes cooking the dish (full of hot pink paint), '
            'Sandra takes a big gulp of it, and now paint is all around her mouth! What a messy eater Sandra is. ',
        '    Close your eyes if you have to, but really picture in your mind\'s eye Sandra Bullock giving you a big smile with PINK PAINT all around her mouth. Freaky!'
            '\n\n    And of course the only way Sandra Bullock knows how to celebrate her favorite pink paint soup is to grab her hot pink poker chips, '
            'jump out the window, and dunk the poker chips out in the driveway.\n\nSMASH!!! Some of the poker chips start rolling away, to the foot of your next character!',
        '    And I know sound like a broken record, but I promise that as you practice this process you will get really, really fast at putting stories together and finding creative '
            'ways to link the crazy scenes.'
      ],
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoTimedTestPrepFirstHelpKey,
      callback: callback,
    );
  }
}

class TimedTestPrepRowContainer extends StatelessWidget {
  final String digits;
  final Color color;

  TimedTestPrepRowContainer({required this.digits, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(5))),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Center(
        child: Text(
          digits,
          style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
        ),
      ),
    );
  }
}
