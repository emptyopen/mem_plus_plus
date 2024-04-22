import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PhoneticAlphabetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PhoneticAlphabetTimedTestPrepScreen({required this.callback});

  @override
  _PhoneticAlphabetTimedTestPrepScreenState createState() =>
      _PhoneticAlphabetTimedTestPrepScreenState();
}

class _PhoneticAlphabetTimedTestPrepScreenState
    extends State<PhoneticAlphabetTimedTestPrepScreen> {
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: debugTestTime) : Duration(hours: 3);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
    prefs.checkFirstTime(context, phoneticAlphabetTimedTestPrepFirstHelpKey,
        PhoneticAlphabetTimedTestPrepScreenHelp());
  }

  void updateStatus() async {
    prefs.setBool(phoneticAlphabetTestActiveKey, false);
    prefs.updateActivityState(phoneticAlphabetTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, false);
    prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'todo');
    prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, true);
    prefs.updateActivityFirstView(phoneticAlphabetTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        phoneticAlphabetTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (phonetic alphabet) is ready!',
        'Good luck!', phoneticAlphabetTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  getPhoneticAlphabetMorse() {
    List<Widget> lettersList = [];
    List<Widget> phoneticsList = [];
    List<Widget> morseList = [];
    for (int i = 0; i < morse.length; i++) {
      lettersList.add(Text(
        letters[i],
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'SpaceMono',
          color: backgroundHighlightColor,
        ),
      ));
      phoneticsList.add(Text(
        phoneticAlphabet[i],
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'SpaceMono',
          color: backgroundHighlightColor,
        ),
      ));
      morseList.add(Text(
        morse[i],
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'SpaceMono',
          color: backgroundHighlightColor,
        ),
      ));
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: lettersList,
      ),
      Column(
        children: phoneticsList,
      ),
      Column(
        children: morseList,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Phonetic alphabet: timed test prep'),
          backgroundColor: colorChapter2Darker,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PhoneticAlphabetTimedTestPrepScreenHelp();
                    }));
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(color: backgroundColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  'The NATO phonetic alphabet and Morse code: ',
                  style: TextStyle(
                    fontSize: 22,
                    color: backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              getPhoneticAlphabetMorse(),
              SizedBox(
                height: 60,
              ),
              BasicFlatButton(
                text: 'I\'m ready!',
                color: colorChapter2Darker,
                onPressed: () => showConfirmDialog(
                    context: context,
                    function: updateStatus,
                    confirmText:
                        'Are you sure you\'d like to start this test? The number will no longer be available to view! (unless you check online xD)',
                    confirmColor: colorChapter2Standard),
                fontSize: 30,
                padding: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  '(You\'ll be quizzed on this in six hours!)',
                  style:
                      TextStyle(fontSize: 18, color: backgroundHighlightColor),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneticAlphabetTimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    OK! Let\'s get right down to using the Memory Palace. We\'re going to memorize the NATO phonetic alphabet and Morse code. '
        'Now if you get stranded on an island and there\'s a Morse code machine there, you can communicate with the world and be the hero!'
        '\n    Pick a place, like your current home, or an '
        'old apartment. Start at your front door, and move along a wall around your apartment, visiting different '
        'rooms or objects. ',
    '    Before you really get started, make sure to pace yourself! You\'re going to want to fit 26 sublocations here, so if it\'s a smaller apartment, '
        'count out 26 sublocations before you start.\n\n    Maybe it\'s the front door, the fridge in your kitchen, the sink, the kitchen table, the '
        'living room sofa, the stairs to the second floor, your younger brother\'s bedroom, the hallway closet, '
        'your bedroom, on and on.',
    '    Now assign the phonetic word for A ("Alpha") and the Morse code '
        'for A (dot dash) to the font door.\n    Maybe "alpha" reminds you of an apex predator, and you could have a shark '
        'smashing your front door over a grizzly bear\'s head. Or maybe "alpha" reminds you of transparency, so the door\'s opacity '
        'is wildly fluctuating. ',
    '    Then, for the Morse we can add to that scene thin objects (dashes) and round objects (dots). '
        'Maybe the shark smashes the door over the grizzly\'s head, '
        'and feels really bad about it so he brings the grizzly a vintage GLOBE (dot) that has a retractable TELESCOPE (dash) that pops out of '
        'the top. Close your eyes and imagine the smell of a grandfather\'s office and hear the popping '
        'sound of the telescope. \n\n    Now we\'ve encoded "alpha" and "•-", woohoo!',
    '    Really mash the scene and your real life sublocation together!\n\n    Is blood spurting out of the '
        'faucets? So gross! Billowing flames when you open the bathroom door? Close your eyes and feel the searing flames on your face! '
        'Smell the stench of the rotting zombies chasing you down the hallway! \n    Really let your imagination run wild!',
    '        Don\'t worry about having to imagine these uncomfortably weird scenes forever. If you practice enough, '
        'eventually these zany images will fade into the background as the words, dots, and dashes become second nature.',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Phonetic Alphabet Timed Test Prep',
      information: information,
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: phoneticAlphabetTimedTestPrepFirstHelpKey,
    );
  }
}
