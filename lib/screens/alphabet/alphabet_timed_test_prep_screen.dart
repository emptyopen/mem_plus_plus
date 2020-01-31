import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';

class AlphabetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  AlphabetTimedTestPrepScreen({this.callback});

  @override
  _AlphabetTimedTestPrepScreenState createState() =>
      _AlphabetTimedTestPrepScreenState();
}

class _AlphabetTimedTestPrepScreenState
    extends State<AlphabetTimedTestPrepScreen> {
  String char1 = '';
  String char2 = '';
  String char3 = '';
  String char4 = '';
  String char5 = '';
  String char6 = '';
  String char7 = '';
  String char8 = '';
  String alphabetTestActiveKey = 'AlphabetTimedTestActive';
  String activityStatesKey = 'ActivityStates';
  PrefsUpdater prefs = PrefsUpdater();
  List<String> possibleValues = [
    'A', 'B', 'C', 'D', 'E', 'F',
    'G', 'H', 'I', 'J', 'K', 'L',
    'M', 'N', 'O', 'P', 'Q', 'R',
    'S', 'T', 'U', 'V', 'W', 'X',
    'Y', 'Z', '0', '1', '2', '3',
    '4', '5', '6', '7', '8', '9',
    '0',
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // if digits are null, randomize values and store them,
      // then update DateTime available for alphabetTest
      bool sdTestIsActive = prefs.getBool(alphabetTestActiveKey);
      if (sdTestIsActive == null || !sdTestIsActive) {
        print('no active test, setting new values');
        var random = new Random();
        char1 = possibleValues[random.nextInt(possibleValues.length)];
        char2 = possibleValues[random.nextInt(possibleValues.length)];
        char3 = possibleValues[random.nextInt(possibleValues.length)];
        char4 = possibleValues[random.nextInt(possibleValues.length)];
        char5 = possibleValues[random.nextInt(possibleValues.length)];
        char6 = possibleValues[random.nextInt(possibleValues.length)];
        char7 = possibleValues[random.nextInt(possibleValues.length)];
        char8 = possibleValues[random.nextInt(possibleValues.length)];
        prefs.setString('alphabetTestChar1', char1);
        prefs.setString('alphabetTestChar2', char2);
        prefs.setString('alphabetTestChar3', char3);
        prefs.setString('alphabetTestChar4', char4);
        prefs.setString('alphabetTestChar5', char5);
        prefs.setString('alphabetTestChar6', char6);
        prefs.setString('alphabetTestChar7', char7);
        prefs.setString('alphabetTestChar8', char8);
        prefs.setBool(alphabetTestActiveKey, true);
      } else {
        print('found active test, restoring values');
        char1 = prefs.getString('alphabetTestChar1');
        char2 = prefs.getString('alphabetTestChar2');
        char3 = prefs.getString('alphabetTestChar3');
        char4 = prefs.getString('alphabetTestChar4');
        char5 = prefs.getString('alphabetTestChar5');
        char6 = prefs.getString('alphabetTestChar6');
        char7 = prefs.getString('alphabetTestChar7');
        char8 = prefs.getString('alphabetTestChar8');
      }
    });
  }

  void updateStatus() async {
    await prefs.setBool(alphabetTestActiveKey, false);
    await prefs.updateActivityState('AlphabetTimedTestPrep', 'review');
    await prefs.updateActivityVisible('AlphabetTimedTestPrep', false);
    await prefs.updateActivityState('AlphabetTimedTest', 'todo');
    await prefs.updateActivityVisible('AlphabetTimedTest', true);
    await prefs.updateActivityFirstView('AlphabetTimedTest', true);
    await prefs.updateActivityVisibleAfter('AlphabetTimedTest', DateTime.now().add(Duration(seconds: 10)));
    Timer(Duration(seconds: 10), widget.callback);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Alphabet: timed test prep'), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return AlphabetTimedTestPrepScreenHelp();
                }));
          },
        ),
      ]),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
            'Your sequences are: ',
            style: TextStyle(fontSize: 34),
          )),
          SizedBox(
            height: 50,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char1,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char2,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char3,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char4,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char5,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char6,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue[200],
                borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char7,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: Center(
                child: Text(
                  char8,
                  style: TextStyle(fontSize: 44, fontFamily: 'SpaceMono'),
                ),
              ),
            ),
          ]),
          SizedBox(
            height: 70,
          ),
          BasicFlatButton(
            text: 'I\'m ready!',
            color: Theme.of(context).primaryColor,
            splashColor: Colors.blue[200],
            fontSize: 30,
            onPressed: () => updateStatus(),
            padding: 10,
          ),
          SizedBox(height: 20,),
          Container(
            child: Text('(You\'ll be quizzed on this in two hours!)',
            style: TextStyle(fontSize: 20),),
          )
        ],
      ),
    );
  }
}

class AlphabetTimedTestPrepScreenHelp extends StatelessWidget {
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
                        '    You guessed it! Two sequences this time. And now we\'re throwing numbers into the mix as well!\n'
                          '    As we start to use longer sequences, start to move the scene around. For example, say we have '
                          'the sequences "GP3D" and "R5ZA". Using default values that is [ghost, panda, bra, dinosaur], and '
                          '[root, snake, zipper, apple]. Let\'s avoid starting with a ghost of a panda, because we might forget '
                          'which order they come in (with the PAO system we will avoid this, and that\'s the next system). \n'
                          '    Alright, so a friendly ghost accidentally bumps into a panda, who is wearing a bra. It looks great! The panda is '
                          'startled but realizes it\'s late for its meeting with his dinosaur friend. Panda runs over to see '
                          'the dinosaur, and upon seeing each other, roots from the ground come slithering up, binding them both '
                          'in place. What is this sorcery? Ah, it\'s simply the magical snakes who are out to get everyone. Drat! And '
                          'upon closer inspection, all of these snakes have zippers down their bodies. Let\'s pull on them to see what comes '
                          'out! Ziiiiiiiip! Oh my word, apples keep gushing out! Where do these snakes keep all these apples in their bodies?\n'
                          '    Simple combinations of letters and numbers will already become useful in your life to remember things like parking '
                          'spots! Many parking garages or lots have designations like "A2" or "E9". You can imagine an apple being ferociously being '
                          'eaten in the back seat of your car by an enourmous pidgeon, or an elephant stomping all over your car, with balloons being '
                          'released from the car with every stomp. A million red balloons! Don\'t forget to really make these scenes wild.\n'
                          '    Be sure not to confuse zero with O! Zero will have a dot in the character.',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 13),
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
