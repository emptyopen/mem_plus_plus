import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/components/standard.dart';

class PAOTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PAOTimedTestPrepScreen({this.callback});

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
  Duration testDuration = debugModeEnabled ? Duration(seconds: 5) : Duration(hours: 4);
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
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, paoTimedTestPrepFirstHelpKey, PAOTimedTestPrepScreenHelp());
    // if digits are null, randomize values and store them,
    // then update DateTime available for paoTest
    bool sdTestIsActive = await prefs.getBool(paoTestActiveKey);
    if (sdTestIsActive == null || !sdTestIsActive) {
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
      await prefs.setString('paoTestDigits1', digits1);
      await prefs.setString('paoTestDigits2', digits2);
      await prefs.setString('paoTestDigits3', digits3);
      await prefs.setString('paoTestDigits4', digits4);
      await prefs.setString('paoTestDigits5', digits5);
      await prefs.setString('paoTestDigits6', digits6);
      await prefs.setString('paoTestDigits7', digits7);
      await prefs.setString('paoTestDigits8', digits8);
      await prefs.setString('paoTestDigits9', digits9);
      await prefs.setBool(paoTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      digits1 = await prefs.getString('paoTestDigits1');
      digits2 = await prefs.getString('paoTestDigits2');
      digits3 = await prefs.getString('paoTestDigits3');
      digits4 = await prefs.getString('paoTestDigits4');
      digits5 = await prefs.getString('paoTestDigits5');
      digits6 = await prefs.getString('paoTestDigits6');
      digits7 = await prefs.getString('paoTestDigits7');
      digits8 = await prefs.getString('paoTestDigits8');
      digits9 = await prefs.getString('paoTestDigits9');
    }
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(paoTestActiveKey, false);
    await prefs.updateActivityState(paoTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(paoTimedTestPrepKey, false);
    await prefs.updateActivityState(paoTimedTestKey, 'todo');
    await prefs.updateActivityVisible(paoTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
        paoTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (PAO) is ready!', 'Good luck!', paoTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('PAO: timed test prep'),
        backgroundColor: Colors.pink[200],
        actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return PAOTimedTestPrepScreenHelp();
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
                color: Colors.pink[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits2,
                color: Colors.pink[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits3,
                color: Colors.pink[200],
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits4,
                color: Colors.pink[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits5,
                color: Colors.pink[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits6,
                color: Colors.pink[200],
              ),
            ]),
            SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TimedTestPrepRowContainer(
                digits: digits7,
                color: Colors.pink[50],
              ),
              TimedTestPrepRowContainer(
                digits: digits8,
                color: Colors.pink[100],
              ),
              TimedTestPrepRowContainer(
                digits: digits9,
                color: Colors.pink[200],
              ),
            ]),
            SizedBox(
              height: 50,
            ),
            BasicFlatButton(
              text: 'I\'m ready!',
              color: colorPAOLighter,
              splashColor: colorPAOStandard,
              onPressed: () => showConfirmDialog(
                context: context,
                function: updateStatus,
                confirmText: 'Are you sure you\'d like to start this test? The sequences will no longer be available to view!',
                confirmColor: colorPAOStandard
              ),
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
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Timed Test Preparation',
      information: [
        '    Alright! Now you\'re going to convert these three sets of six digits into three scenes, '
            'and link the scenes together. Remember, person-action-object, and really create a connection '
            'between scenes. ',
        '    If the first scene is Galileo fervently cooking with a paintbrush, and the second scene '
            'is Sandra Bullock slam-dunking some poker chips, maybe Galileo finishes cooking the dish (full of paint), '
            'and Sandra takes a big gulp of it, now paint is all around her mouth! What a messy eater Sandra is. '
            'Now she\'s mad about the paint so she\'s going to go dunk some poker chips to cool off.'
      ],
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
      firstHelpKey: paoTimedTestPrepFirstHelpKey,
    );
  }
}

class TimedTestPrepRowContainer extends StatelessWidget {
  final String digits;
  final Color color;

  TimedTestPrepRowContainer({this.digits, this.color});

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
