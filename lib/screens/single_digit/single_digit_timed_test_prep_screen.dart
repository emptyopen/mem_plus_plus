import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/components/templates/help_screen.dart';

class SingleDigitTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  SingleDigitTimedTestPrepScreen({this.callback});

  @override
  _SingleDigitTimedTestPrepScreenState createState() =>
      _SingleDigitTimedTestPrepScreenState();
}

class _SingleDigitTimedTestPrepScreenState
    extends State<SingleDigitTimedTestPrepScreen> {
  String digit1 = '';
  String digit2 = '';
  String digit3 = '';
  String digit4 = '';
  String singleDigitTestActiveKey = 'SingleDigitTimedTestActive';
  String activityStatesKey = 'ActivityStates';
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefss = PrefsUpdater();
    prefss.checkFirstTime(context, 'SingleDigitTimedTestPrepFirstHelp', SingleDigitTimedTestPrepScreenHelp());
    setState(() {
      // if digits are null, randomize values and store them,
      // then update DateTime available for singleDigitTest
      bool sdTestIsActive = prefs.getBool(singleDigitTestActiveKey);
      if (sdTestIsActive == null || !sdTestIsActive) {
        print('no active test, setting new values');
        var random = new Random();
        digit1 = random.nextInt(9).toString();
        digit2 = random.nextInt(9).toString();
        digit3 = random.nextInt(9).toString();
        digit4 = random.nextInt(9).toString();
        prefs.setString('singleDigitTestDigit1', digit1);
        prefs.setString('singleDigitTestDigit2', digit2);
        prefs.setString('singleDigitTestDigit3', digit3);
        prefs.setString('singleDigitTestDigit4', digit4);
        prefs.setBool(singleDigitTestActiveKey, true);
      } else {
        print('found active test, restoring values');
        digit1 = prefs.getString('singleDigitTestDigit1');
        digit2 = prefs.getString('singleDigitTestDigit2');
        digit3 = prefs.getString('singleDigitTestDigit3');
        digit4 = prefs.getString('singleDigitTestDigit4');
      }
    });
  }

  void updateStatus() async {
    await prefs.setBool(singleDigitTestActiveKey, false);
    await prefs.updateActivityState('SingleDigitTimedTestPrep', 'review');
    await prefs.updateActivityVisible('SingleDigitTimedTestPrep', false);
    await prefs.updateActivityState('SingleDigitTimedTest', 'todo');
    await prefs.updateActivityVisible('SingleDigitTimedTest', true);
    await prefs.updateActivityFirstView('SingleDigitTimedTest', true);
    await prefs.updateActivityVisibleAfter(
        'SingleDigitTimedTest', DateTime.now().add(Duration(seconds: 10)));
    Timer(Duration(seconds: 10), widget.callback);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Single digit: timed test preparation'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitTimedTestPrepScreenHelp();
                    }));
              },
            ),
          ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            'Your number is: ',
            style: TextStyle(fontSize: 34),
          )),
          SizedBox(
            height: 50,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  digit1,
                  style: TextStyle(fontSize: 44),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  digit2,
                  style: TextStyle(fontSize: 44),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.amber[200],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  digit3,
                  style: TextStyle(fontSize: 44),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.amber[300],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  digit4,
                  style: TextStyle(fontSize: 44),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 100,
          ),
          BasicFlatButton(
            text: 'I\'m ready!',
            color: Theme.of(context).primaryColor,
            splashColor: Colors.amber[200],
            onPressed: () => updateStatus(),
            fontSize: 30,
            padding: 10,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              '(You\'ll be quizzed on this in one hour!)',
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }
}

class SingleDigitTimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to your first timed test! \n'
        '    Here we are going to present you with a 4 digit number. '
        'Your goal is to memorize the number by converting the 4 digits '
        'to their associated objects. Then imagine a scene where the objects '
        'are used in order. Once you feel confident, select "I\'m ready!" and the numbers will become unavailable. '
        'In a couple hours you will have to decode the scene back into numbers.',
    '    For example, let\'s look at the number 1234. Under the default '
        'system, that would translate to stick, bird, bra, and sailboat. We '
        'could imagine a stick falling out of the sky, landing and skewering a bird. Owch! '
        'The bird is in a lot of pain. Luckily, it find a bra and makes a tourniquet out of it. '
        'Now the bird can make it to the fancy dinner party on the sailboat tonight! Phew!',
    '    Really think about that scene in your mind, and make it really vivid. Is the bird a '
        'swan? How much does that swan squawk when it gets speared out of nowhere? '
        'And boy oh boy does that swan want to make it to that party. \n'
        '    Now let\'s attach that scene to this quiz. It\'s a timed test, so let\'s imagine '
        'you up in the clouds, about to take this test. A huge timer clock is above you... ah, '
        'yes, this is the place to take a timed test. And the first thing that happens is you '
        'drop your pencil, and it rockets towards the earth, skewering that swan...',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: information,
    );
  }
}
