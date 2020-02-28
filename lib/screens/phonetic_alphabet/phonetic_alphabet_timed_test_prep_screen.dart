import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PhoneticAlphabetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PhoneticAlphabetTimedTestPrepScreen({this.callback});

  @override
  _PhoneticAlphabetTimedTestPrepScreenState createState() =>
      _PhoneticAlphabetTimedTestPrepScreenState();
}

class _PhoneticAlphabetTimedTestPrepScreenState
    extends State<PhoneticAlphabetTimedTestPrepScreen> {
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: 5) : Duration(hours: 3);

  @override
  void initState() {
    super.initState();
  }

  void updateStatus() async {
    await prefs.setBool(phoneticAlphabetTestActiveKey, false);
    await prefs.updateActivityState(phoneticAlphabetTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, false);
    await prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'todo');
    await prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, true);
    await prefs.updateActivityFirstView(phoneticAlphabetTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
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
    List letters = [
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
      'Z'
    ];
    List phoneticAlphabet = [
      'Alpha',
      'Bravo',
      'Charlie',
      'Delta',
      'Echo',
      'Foxtrot',
      'Golf',
      'Hotel',
      'India',
      'Juliett',
      'Kilo',
      'Lima',
      'Mike',
      'November',
      'Oscar',
      'Papa',
      'Quebec',
      'Romeo',
      'Sierra',
      'Tango',
      'Uniform',
      'Victor',
      'Whiskey',
      'X-ray',
      'Yankee',
      'Zulu',
    ];
    List morse = [
      '•-',
      '-•••',
      '-•-•',
      '-••',
      '•',
      '••-•',
      '--•',
      '••••',
      '••',
      '•---',
      '-•-',
      '•-••',
      '--',
      '-•',
      '---',
      '•--•',
      '--•-',
      '•-•',
      '•••',
      '-',
      '••-',
      '•••-',
      '•--',
      '-••-',
      '-•--',
      '--••',
    ];
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
          backgroundColor: Colors.green[200],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
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
                color: colorLessonDarker,
                splashColor: colorLessonStandard,
                onPressed: () => showConfirmDialog(
                    context: context,
                    function: updateStatus,
                    confirmText:
                        'Are you sure you\'d like to start this test? The number will no longer be available to view! (unless you check online xD)',
                    confirmColor: colorLessonStandard),
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
    '    OK! Let\'s get right down to using the Memory Palace. We\'re going to memorize the NATO phonetic alphabet!'
        'Pick a place, like your current home, or an '
        'old apartment. Start at your front door, and move along a wall around your apartment, visiting different '
        'rooms or objects. Maybe it\'s the front door, the fridge in your kitchen, the sink, the kitchen table, the '
        'living room sofa, the stairs to the annex, the annex itself, on and on, a total of 26 sub-locations.',
    'Now assign the phonetic word for A (Alpha) and the Morse code '
        'for A (dot dash) to the font door. Maybe Alpha reminds you of an apex predator, and you could have a shark '
        'smashing your front door over a grizzly bear\'s head. Or maybe Alpha reminds you of transparency, so the door\'s opacity '
        'is wildly fluctuating. Then, for the Morse we can ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Phonetic Alphabet Timed Test Prep',
      information: information,
      buttonColor: colorLessonStandard,
      buttonSplashColor: colorLessonDarker,
      firstHelpKey: phoneticAlphabetTimedTestPrepFirstHelpKey,
    );
  }
}
