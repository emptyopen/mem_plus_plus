import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AlphabetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  AlphabetTimedTestPrepScreen({required this.callback});

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
  PrefsUpdater prefs = PrefsUpdater();
  List<String> possibleValues = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, 'AlphabetTimedTestPrepFirstHelp',
        AlphabetTimedTestPrepScreenHelp());
    // if digits are null, randomize values and store them,
    // then update DateTime available for alphabetTest
    bool? sdTestIsActive = prefs.getBool(alphabetTestActiveKey);
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
      char1 = (prefs.getString('alphabetTestChar1'))!;
      char2 = (prefs.getString('alphabetTestChar2'))!;
      char3 = (prefs.getString('alphabetTestChar3'))!;
      char4 = (prefs.getString('alphabetTestChar4'))!;
      char5 = (prefs.getString('alphabetTestChar5'))!;
      char6 = (prefs.getString('alphabetTestChar6'))!;
      char7 = (prefs.getString('alphabetTestChar7'))!;
      char8 = (prefs.getString('alphabetTestChar8'))!;
    }
    setState(() {});
  }

  void updateStatus() async {
    prefs.setBool(alphabetTestActiveKey, false);
    prefs.updateActivityState(alphabetTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(alphabetTimedTestPrepKey, false);
    prefs.updateActivityState(alphabetTimedTestKey, 'todo');
    prefs.updateActivityVisible(alphabetTimedTestKey, true);
    Duration testDuration = debugModeEnabled
        ? Duration(seconds: debugTestTime)
        : Duration(hours: 2);
    prefs.updateActivityVisibleAfter(
        alphabetTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (alphabet) is ready!',
        'Good luck!', alphabetTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Alphabet: timed test prep'),
          backgroundColor: Colors.blue[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AlphabetTimedTestPrepScreenHelp();
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
              color: colorAlphabetLighter,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Are you sure you\'d like to start this test? The sequences will no longer be available to view!',
                  confirmColor: colorAlphabetStandard),
              fontSize: 30,
              padding: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in two hours!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AlphabetTimedTestPrepScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Alphabet - Timed Test Preparation',
      information: [
        '    You guessed it! Two sequences this time. And we\'re throwing numbers into the mix as well!\n'
            '    As we start to use longer sequences, start to move the scene around. For example, say we have '
            'the sequences "GP3D" and "R5ZA". Let\'s say that translates to [GHOST, PANDA, BRA, DINOSAUR], and '
            '[ROOT, SNAKE, ZIPPER, APPLE]. ',
        '    [GHOST, PANDA, BRA, DINOSAUR] \n\n    Let\'s avoid starting with a ghost of a panda, because we might forget '
            'which order they come in. \n'
            '    Alright, let\'s get weird with a sample scene! You are a very friendly GHOST, and you always have been. '
            'Your ghostly self accidentally bumps into a morbidly obese PANDA. The panda is very startled, '
            'because she is trying on a BRA. The bra is a way too tight, though. \n     Ms. Panda sighs, today is just not her day. '
            'Suddenly she realizes she\'s late for her meeting with her DINOSAUR friend! And today is Dinosaur Day! He\'s going to be so sad if she doesn\'t '
            'show up.',
        '    [ROOT, SNAKE, ZIPPER, APPLE]\n\n    Ms. Panda runs over to see '
            'Mr. Brontasaurus, and upon seeing each other, ROOTS from the ground come slithering up, binding them both '
            'in place. What is this sorcery? Ah, it\'s simply the magical SNAKES using their root-technology who are out to get everyone. Drat! \n    And '
            'upon closer inspection, all of these snakes have ZIPPERS down their bodies. Let\'s pull on them to see what comes '
            'out! Ziiiiiiiip! Oh my word, APPLES keep gushing out! Where do these snakes keep all these apples in their bodies?',
        '    Simple combinations of letters and numbers will already become useful in your life to remember things like parking '
            'spots! Many parking garages or lots have designations like "A2" or "E9". \n    You can imagine an APPLE (my "A") being ferociously being '
            'eaten in the back seat of your car by an enourmous PIDGEON (my #2), or an ELEPHANT (my "E") stomping all over your car, with BALLOONS (my #9) being '
            'released from the car with every stomp. A million red balloons! Don\'t forget to really make these scenes wild.',
        '    Be sure not to confuse zero with the letter O! Zero will have a dot in the character.\n\n    Remember, WILD stories with LOTS of details!'
      ],
      buttonColor: Colors.blue[100]!,
      buttonSplashColor: Colors.blue[300]!,
      firstHelpKey: alphabetTimedTestPrepFirstHelpKey,
    );
  }
}
