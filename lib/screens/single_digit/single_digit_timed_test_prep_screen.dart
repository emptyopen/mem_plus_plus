import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'dart:convert';

class SingleDigitTimedTestPrepScreen extends StatefulWidget {
  final Function(int) callback;

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
  String singleDigitTestActiveKey = 'SingleDigitTestActive';
  String activityStatesKey = 'ActivityStates';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool(singleDigitTestActiveKey, false);

      // get activities
      var rawMap =
      json.decode(prefs.getString(activityStatesKey)) as Map<String, dynamic>;
      Map<String, Activity> activityStates =
      rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));

      // update activity for singleDigitTimedTestPrep to be invisible and in review
      Activity singleDigitTimedTestPrep = activityStates['SingleDigitTimedTestPrep'];
      singleDigitTimedTestPrep.state = 'review';
      singleDigitTimedTestPrep.visible = false;
      activityStates['SingleDigitTimedTestPrep'] = singleDigitTimedTestPrep;

      // update activity for singleDigitTimedTest to be visible, but after a few hours
      Activity singleDigitTimedTest = activityStates['SingleDigitTimedTest'];
      singleDigitTimedTest.state = 'todo';
      singleDigitTimedTest.visible = true;
      // singleDigitTimedTest.visibleAfter = DateTime.now().add(Duration(seconds: 30));
      activityStates['SingleDigitTimedTest'] = singleDigitTimedTest;

      // set activities
      prefs.setString(
        activityStatesKey,
        json.encode(
          activityStates.map((k, v) => MapEntry(k, v.toJson())),
        ));
    });
    widget.callback(null);
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
                  color: Colors.grey[200],
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
                  color: Colors.grey[300],
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
                  color: Colors.grey[400],
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
                  color: Colors.grey[500],
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
          Container(
            width: 200,
            decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Center(
              child: FlatButton(onPressed: () => updateStatus(), child: Text('I\'m ready!',
              style: TextStyle(fontSize: 30),)),
            ),
          )
        ],
      ),
    );
  }
}

class SingleDigitTimedTestPrepScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Text(
                        '    Welcome to your first timed test! \n\n'
                        '    Here we are going to present you with a 4 digit number. '
                        'Your goal is to memorize the number by converting the 4 digits '
                        'to their associated objects. Then imagine a scene where the objects '
                        'are used in order. Once you feel confident, select "I\'m ready!" and the numbers will become unavailable. '
                        'In a couple hours you will have to decode the scene back into numbers. \n'
                        '    For example, let\'s look at the number 1234. Under the default '
                        'system, that would translate to stick, bird, bra, and sailboat. We '
                        'could imagine a stick falling out of the sky, landing and skewering a bird. Owch! '
                        'The bird is in a lot of pain. Luckily, it find a bra and makes a tourniquet out of it. '
                        'Now the bird can make it to the fancy dinner party on the sailboat tonight! Phew! \n'
                        '    Really think about that scene in your mind, and make it really vivid. Is the bird a '
                        'swan? How much does that swan squawk when it gets speared out of nowhere? '
                        'And boy oh boy does that swan want to make it to that party. \n'
                        '    Now let\'s attach that scene to this quiz. It\'s a timed test, so let\'s imagine '
                        'you up in the clouds, about to take this test. A huge timer clock is above you... ah, '
                        'yes, this is the place to take a timed test. And the first thing that happens is you '
                        'drop your pencil, and it rockets towards the earth, skewering that swan...',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  PopButton(
                    widget: Text('OK'),
                    color: Colors.amber[300],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
