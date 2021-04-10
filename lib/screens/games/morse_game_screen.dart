import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:math';
import 'dart:async';

import 'package:mem_plus_plus/services/services.dart';

import '../../constants/colors.dart';

class MorseGameScreen extends StatefulWidget {
  final int difficulty; // 0, 1, 2, 3 - beginner, medium, expert, ancient god
  final scaffoldKey;

  MorseGameScreen({Key key, this.difficulty, this.scaffoldKey})
      : super(key: key);

  @override
  _MorseGameScreenState createState() => _MorseGameScreenState();
}

class _MorseGameScreenState extends State<MorseGameScreen>
    with SingleTickerProviderStateMixin {
  String instructions = '';
  String easyInstructions =
      '    Welcome, soldier. The year is 2021 and the Apocalypse has driven humanity underground. We are sheltered '
      'in a bunker with 250 citizens, but we are running low on supplies. We were supposed to get a supply drop yesterday, '
      'but we believe it was intercepted by the Robot faction. \n    Main communications are down, but we were able to connect '
      'to HQ implementing a rudimentary Morse code system. We need you to intrepret the Captcha message and return the '
      'correct response. That will notify them that we need another drop.\n    But hurry!'
      ' The Robot faction is inbound and we only have 5 minutes before they decipher the code and '
      'intercept the supply drop!';
  String mediumInstructions =
      '    It\'s the 5th day since we crash-landed on the island. You are the leader of the rag-tag survivors, '
      'and you learned a couple days ago that one of them might be able to engineer a simple communication '
      'mechanism. \n    Oh, here he comes now. Bartholomew hands you a device with a grin.\n    "Here you go \'cap. '
      'Careful though, you probably only have a couple minutes with the charge it\'s gonna take to send that to space."'
      '\n    "Morse code?", you sigh.\n    "Morse code," he laughs. "We need to make a handshake with the satellite '
      'and it has NASA\'s patented Captcha system to make sure the Robot faction doesn\'t intercept the message."';
  String masterInstructions =
      '    "Sergeant, there\'s no time to explain. We got the all clear to launch Tango-November-Bravo at the '
      'alien virus manufacturing plant. We need you to give the all clear to launch as well, please complete '
      'these three Captchas!"\n    "We believe in you, Sergeant!"\n    "You got this Sergeant!"';
  String ancientGodInstructions =
      '    Tod woke with a start. Rubbing his eyes, he walked down the stairs to the smell of bacon. His mom was pouring his '
      'dad some coffee as he read the news.\n    "Morning Tod, sleep well?" his mom asked.\n    "I had the weirdest dream, actually." '
      'Tod paused to think. "There were aliens, in like a war... some people got stranded on an island, and I\'m pretty sure some  '
      'nukes were launched."\n    "Wow honey, maybe no more scary movies before bedtime, yeah?"\n    "Listen to your mother, Tod." '
      'Tod\'s dad adjusted his glasses and looked at Tod. "And do you mind taking care of these four Captchas before the universe '
      'blows up?"';
  String failureMessage = 'Fail.';
  String buttonText = '';
  String easyButtonText = 'Take me to the machine';
  String mediumButtonText = 'Turn the device on';
  String masterButtonText = 'Launch the... nukes?';
  String ancientGodButtonText = 'It is my duty, father';
  List<String> alreadyClues = [];
  List<String> clues = [
    '',
    '',
    '',
    '',
  ];
  List<String> guesses = [
    '',
    '',
    '',
    '',
  ];
  Timer timer;
  int countdown = 300;
  int duration = 5;
  bool loaded = false;
  bool started = false;
  String difficultyName = '';
  var textController = TextEditingController();
  AnimationController animationController;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    initializeSequence();
  }

  @override
  void dispose() {
    textController.dispose();
    animationController.dispose();
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  initializeSequence() {
    prefs.checkFirstTime(context, morseGameFirstHelpKey, MorseGameScreenHelp());
    Random random = new Random();
    alreadyClues = [];
    if (widget.difficulty >= 0) {
      instructions = easyInstructions;
      buttonText = easyButtonText;
      var keys = morseQuiz.keys.toList();
      clues[0] = keys[random.nextInt(keys.length)];
      alreadyClues.add(clues[0]);
      difficultyName = 'Easy';
      countdown = 300;
      failureMessage = 'Supply drop intercepted!';
    }
    if (widget.difficulty >= 1) {
      instructions = mediumInstructions;
      buttonText = mediumButtonText;
      var keys = morseQuiz.keys.toList();
      clues[1] = keys[random.nextInt(keys.length)];
      while (alreadyClues.contains(clues[1])) {
        var keys = morseQuiz.keys.toList();
        clues[1] = keys[random.nextInt(keys.length)];
      }
      difficultyName = 'Medium';
      countdown = 200;
      failureMessage = 'Aw man, now we have to use smoke signals.';
    }
    if (widget.difficulty >= 2) {
      instructions = masterInstructions;
      buttonText = masterButtonText;
      var keys = morseQuiz.keys.toList();
      clues[2] = keys[random.nextInt(keys.length)];
      while (alreadyClues.contains(clues[2])) {
        var keys = morseQuiz.keys.toList();
        clues[2] = keys[random.nextInt(keys.length)];
      }
      difficultyName = 'Master';
      countdown = 170;
      failureMessage = 'It\'s OK Sergeant, we\'ll get \'em next time.';
    }
    if (widget.difficulty >= 3) {
      instructions = ancientGodInstructions;
      buttonText = ancientGodButtonText;
      var keys = morseQuiz.keys.toList();
      clues[3] = keys[random.nextInt(keys.length)];
      while (alreadyClues.contains(clues[3])) {
        var keys = morseQuiz.keys.toList();
        clues[3] = keys[random.nextInt(keys.length)];
      }
      difficultyName = 'Ancient God';
      countdown = 140;
      failureMessage = '* sound of the universe exploding *';
    }
    print('${clues[0]} | ${clues[1]} | ${clues[2]} | ${clues[3]}');
    animationController = AnimationController(
      duration: Duration(
        seconds: duration,
      ),
      vsync: this,
    );
    setState(() {
      loaded = true;
    });
  }

  sanitizeString(String string) {
    if (string == '') {
      return string;
    }
    if (string[0] == '/') {
      string = string.substring(1);
    }
    return string;
  }

  checkAnswer(BuildContext context) async {
    bool correct = true;
    guesses[0] = sanitizeString(guesses[0]);
    guesses[1] = sanitizeString(guesses[1]);
    guesses[2] = sanitizeString(guesses[2]);
    guesses[3] = sanitizeString(guesses[3]);
    if (guesses[0] != stringToMorse(morseQuiz[clues[0]], false)) {
      print('1 incorrect');
      difficultyName = 'Easy';
      correct = false;
    }
    if (widget.difficulty == 1 &&
        guesses[1] != stringToMorse(morseQuiz[clues[1]], false)) {
      print('2 incorrect');
      difficultyName = 'Medium';
      correct = false;
    }
    if (widget.difficulty == 2 &&
        guesses[2] != stringToMorse(morseQuiz[clues[2]], false)) {
      print('3 incorrect');
      difficultyName = 'Expert';
      correct = false;
    }
    if (widget.difficulty == 3 &&
        guesses[3] != stringToMorse(morseQuiz[clues[3]], false)) {
      print('4 incorrect');
      difficultyName = 'Ancient God';
      correct = false;
    }
    if (correct) {
      if (await prefs.getBool('morse${widget.difficulty}Complete') == null) {
        showSnackBar(
          scaffoldState: widget.scaffoldKey.currentState,
          snackBarText: 'Congrats! You\'ve beaten $difficultyName difficulty!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.scaffoldKey.currentState,
          snackBarText: 'Congrats! You\'re a beast!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
        );
      }
      await prefs.setBool("morse${widget.difficulty}Complete", true);
    } else {
      showSnackBar(
        scaffoldState: widget.scaffoldKey.currentState,
        snackBarText: failureMessage,
        backgroundColor: colorIncorrect,
        textColor: Colors.black,
      );
    }
    Navigator.pop(context);
    // Navigator.pop(context);
  }

  updateMorseGuess0(String guess) {
    setState(() {
      guesses[0] = guess;
    });
  }

  updateMorseGuess1(String guess) {
    setState(() {
      guesses[1] = guess;
    });
  }

  updateMorseGuess2(String guess) {
    setState(() {
      guesses[2] = guess;
    });
  }

  updateMorseGuess3(String guess) {
    setState(() {
      guesses[3] = guess;
    });
  }

  morseCodeWord(String word) {
    String morseString = stringToMorse(word, true);
    return Padding(
      padding: EdgeInsets.all(15),
      child: Text(
        morseString,
        style: TextStyle(
          fontSize: 24,
          fontFamily: 'SpaceMono',
          color: backgroundHighlightColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getPrompt() {
    List<Widget> widgets = [];
    if (widget.difficulty >= 0) {
      widgets.add(
        Column(children: <Widget>[
          Container(
            height: 3,
            width: 280,
            decoration: BoxDecoration(
              color: backgroundHighlightColor,
              border: Border.all(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          morseCodeWord(clues[0]),
          Text(
            '(${morseQuiz[clues[0]].length} letters long!)',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          MorseTest(
            callback: updateMorseGuess0,
            morseAnswer: clues[0],
            color: colorGamesStandard,
          ),
        ]),
      );
    }
    if (widget.difficulty >= 1) {
      widgets.add(
        Column(children: <Widget>[
          Container(
            height: 3,
            width: 280,
            decoration: BoxDecoration(
              color: backgroundHighlightColor,
              border: Border.all(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          morseCodeWord(clues[1]),
          Text(
            '(${morseQuiz[clues[1]].length} letters long!)',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          MorseTest(
            callback: updateMorseGuess1,
            morseAnswer: clues[1],
            color: colorGamesStandard,
          ),
        ]),
      );
    }
    if (widget.difficulty >= 2) {
      widgets.add(
        Column(children: <Widget>[
          Container(
            height: 3,
            width: 280,
            decoration: BoxDecoration(
              color: backgroundHighlightColor,
              border: Border.all(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          morseCodeWord(clues[2]),
          Text(
            '(${morseQuiz[clues[2]].length} letters long!)',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          MorseTest(
            callback: updateMorseGuess2,
            morseAnswer: clues[2],
            color: colorGamesStandard,
          ),
        ]),
      );
    }
    if (widget.difficulty >= 3) {
      widgets.add(
        Column(children: <Widget>[
          Container(
            height: 3,
            width: 280,
            decoration: BoxDecoration(
              color: backgroundHighlightColor,
              border: Border.all(),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          morseCodeWord(clues[3]),
          Text(
            '(${morseQuiz[clues[3]].length} letters long!)',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          MorseTest(
            callback: updateMorseGuess3,
            morseAnswer: clues[3],
            color: colorGamesStandard,
          ),
        ]),
      );
    }
    return Column(children: widgets);
  }

  getTimer() {
    String minutes = (countdown ~/ 60).toString();
    String seconds = (countdown % 60).toString().padLeft(
          2,
          '0',
        );
    return Container(
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        color: colorGamesLighter,
        border: Border.all(),
        borderRadius: BorderRadius.circular(
          5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Center(
        child: Text(
          '$minutes:$seconds',
          style: TextStyle(
            color: countdown < 20 ? Colors.red : Colors.black,
            fontSize: 26,
            fontFamily: 'SpaceMono',
          ),
        ),
      ),
    );
  }

  checkTimer() {
    if (countdown == 0) {
      showSnackBar(
        scaffoldState: widget.scaffoldKey.currentState,
        snackBarText: 'Out of time! ' + failureMessage,
        backgroundColor: colorIncorrect,
        textColor: Colors.black,
      );
      Navigator.pop(context);
    }
    if (countdown < 10) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Morse Survival'),
          backgroundColor: colorGamesDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return MorseGameScreenHelp();
                    },
                  ),
                );
              },
            ),
          ]),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                started
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          instructions,
                          style: TextStyle(
                            color: backgroundHighlightColor,
                            fontSize: 20,
                          ),
                        ),
                      ),
                started
                    ? Container()
                    : BasicFlatButton(
                        text: buttonText,
                        fontSize: 22,
                        padding: 15,
                        color: colorGamesDarker,
                        textColor: Colors.white,
                        onPressed: () => {
                          // start countdown
                          setState(() {
                            started = true;
                            timer = new Timer.periodic(
                              Duration(seconds: 1),
                              (Timer timer) => setState(
                                () {
                                  checkTimer();
                                  if (countdown < 1) {
                                    timer.cancel();
                                  } else {
                                    countdown = countdown - 1;
                                  }
                                },
                              ),
                            );
                          })
                        },
                      ),
                started
                    ? Column(
                        children: <Widget>[
                          SizedBox(height: 80),
                          ScreenDivider(),
                          SizedBox(height: 20),
                          Text(
                            'Solve the puzzles below!',
                            style: TextStyle(
                                fontSize: 20, color: backgroundHighlightColor),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '(Each answer will be one word)',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          getPrompt(),
                          ScreenDivider(),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              BasicFlatButton(
                                text: 'Give up',
                                color: Colors.grey,
                                fontSize: 20,
                                padding: 10,
                                onPressed: () {
                                  setState(() {
                                    started = false;
                                    Navigator.pop(context);
                                    showSnackBar(
                                      scaffoldState:
                                          widget.scaffoldKey.currentState,
                                      snackBarText: failureMessage,
                                      backgroundColor: colorIncorrect,
                                    );
                                  });
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              BasicFlatButton(
                                text: 'Submit',
                                color: colorGamesStandard,
                                fontSize: 20,
                                padding: 10,
                                onPressed: () => checkAnswer(context),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          started
              ? Positioned(
                  child: getTimer(),
                  right: 15,
                  top: 15,
                )
              : Container(),
        ],
      ),
    );
  }
}

class MorseGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Morse Survival Game',
      information: [
        '    Oh no! If you don\'t decode the Morse message and do what it says, the world is going to end! '
            'It\'s time to be the hero! \n    The > symbol denotes a new word (careful on line wrapping).',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: morseGameFirstHelpKey,
    );
  }
}
