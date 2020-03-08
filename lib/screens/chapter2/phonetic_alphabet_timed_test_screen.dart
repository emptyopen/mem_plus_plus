import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:random_words/random_words.dart';

class PhoneticAlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PhoneticAlphabetTimedTestScreen({this.callback, this.globalKey});

  @override
  _PhoneticAlphabetTimedTestScreenState createState() =>
      _PhoneticAlphabetTimedTestScreenState();
}

class _PhoneticAlphabetTimedTestScreenState
    extends State<PhoneticAlphabetTimedTestScreen> {
  final text1Controller = TextEditingController();
  final text2Controller = TextEditingController();
  final text3Controller = TextEditingController();
  final text4Controller = TextEditingController();
  String randomLetter1;
  String randomLetter2;
  String randomLetter3;
  String encodeWord = '';
  String decodeWord = '';
  String morseGuess = '';
  bool showError = false;
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  bool showError5 = false;

  int morseButtonCounter = 0;
  bool buttonPressed = false;
  bool increaseLoopActive = false;
  int countdownCounter = 0;
  bool countdownLoopActive = false;
  int dashThreshold = 10;
  int initialCountdown = 20;
  int countdownThreshold = 20;
  int milliseconds = 50;
  int counterWidthRatio = 5;

  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    text1Controller.dispose();
    text2Controller.dispose();
    text3Controller.dispose();
    text4Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, phoneticAlphabetTimedTestFirstHelpKey,
        PhoneticAlphabetTimedTestScreenHelp());
    var random = Random();
    // test on three random letters -> phonetic
    List<String> alreadyHave = [];
    randomLetter1 = letters[random.nextInt(letters.length)];
    alreadyHave.add(randomLetter1);
    randomLetter2 = letters[random.nextInt(letters.length)];
    while (alreadyHave.contains(randomLetter2)) {
      randomLetter2 = letters[random.nextInt(letters.length)];
    }
    alreadyHave.add(randomLetter2);
    randomLetter3 = letters[random.nextInt(letters.length)];
    while (alreadyHave.contains(randomLetter3)) {
      randomLetter3 = letters[random.nextInt(letters.length)];
    }

    // generate random word
    generateNoun(maxSyllables: 3).take(1).forEach((word) {
      encodeWord = word.asLowerCase;
    });
    while (encodeWord.length > 5) {
      generateNoun(maxSyllables: 3).take(1).forEach((word) {
        encodeWord = word.asLowerCase;
      });
    }

    // generate random word, convert it to morse code
    generateNoun(maxSyllables: 3).take(1).forEach((word) {
      decodeWord = word.asLowerCase;
    });
    while (decodeWord.length > 5) {
      generateNoun(maxSyllables: 3).take(1).forEach((word) {
        decodeWord = word.asLowerCase;
      });
    }

    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError = false;
      showError1 = false;
      showError2 = false;
      showError3 = false;
      showError5 = false;
    });
    HapticFeedback.heavyImpact();
    if (text1Controller.text == '') {
      setState(() {
        showError1 = true;
      });
    }
    if (text2Controller.text == '') {
      setState(() {
        showError2 = true;
      });
    }
    if (text3Controller.text == '') {
      setState(() {
        showError3 = true;
      });
    }
    if (text4Controller.text == '') {
      setState(() {
        showError5 = true;
      });
    }
    if (showError1 || showError2 || showError3 || showError5) {
      showError = true;
      return;
    }
    int index1 = letters.indexWhere(
        (letter) => letter.toLowerCase() == randomLetter1.toLowerCase());
    var correct1 = (phoneticAlphabet[index1].toLowerCase());
    int index2 = letters.indexWhere(
        (letter) => letter.toLowerCase() == randomLetter2.toLowerCase());
    var correct2 = (phoneticAlphabet[index2].toLowerCase());
    int index3 = letters.indexWhere(
        (letter) => letter.toLowerCase() == randomLetter3.toLowerCase());
    var correct3 = (phoneticAlphabet[index3].toLowerCase());
    String encodeAnswer = '';
    encodeWord.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune).toLowerCase();
      var letters = 'abcdefghijklmnopqrstuvwxyz';
      encodeAnswer += morse[letters.indexOf(character)] + '/';
    });
    String encodeGuess = morseGuess;
    if (morseGuess[0] == '/') {
      encodeGuess = encodeGuess.substring(1);
    }
    String errors = '';
    bool firstCorrect = text1Controller.text.trim().toLowerCase() == correct1;
    if (!firstCorrect) {
      errors +=
          '${text1Controller.text.trim().toLowerCase()} should have been $correct1\n';
    }
    bool secondCorrect = text2Controller.text.trim().toLowerCase() == correct2;
    if (!secondCorrect) {
      errors +=
          '${text2Controller.text.trim().toLowerCase()} should have been $correct2\n';
    }
    bool thirdCorrect = text3Controller.text.trim().toLowerCase() == correct3;
    if (!thirdCorrect) {
      errors +=
          '${text3Controller.text.trim().toLowerCase()} should have been $correct3\n';
    }
    bool fourthCorrect =
        text4Controller.text.trim().toLowerCase() == decodeWord;
    if (!fourthCorrect) {
      errors +=
          '${text4Controller.text.trim().toLowerCase()} should have been $decodeWord\n';
    }
    bool fifthCorrect = encodeAnswer == encodeGuess;
    if (!fifthCorrect) {
      errors += '$encodeGuess should have been $encodeAnswer\n';
    }
    // print(
    //     '$firstCorrect, ${text1Controller.text.trim().toLowerCase()} | $correct1');
    // print(
    //     '$secondCorrect, ${text2Controller.text.trim().toLowerCase()} | $correct2');
    // print(
    //     '$thirdCorrect, ${text3Controller.text.trim().toLowerCase()} | $correct3');
    // print(
    //     '$fourthCorrect, ${text4Controller.text.trim().toLowerCase()} | $decodeWord');
    // print('$fifthCorrect, $encodeAnswer | $encodeGuess');
    if (firstCorrect &&
        secondCorrect &&
        thirdCorrect &&
        fourthCorrect &&
        fifthCorrect) {
      await prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
      await prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
      if (await prefs.getBool(phoneticAlphabetTimedTestCompleteKey) == null) {
        await prefs.setBool(phoneticAlphabetTimedTestCompleteKey, true);
        await prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
        if (await prefs.getBool(airportTimedTestCompleteKey) == null) {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Awesome job! Complete the Airport test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter2Darker,
            durationSeconds: 3,
          );
        } else {
          await prefs.updateActivityVisible(paoEditKey, true);
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'Congratulations! You\'ve unlocked the PAO system!',
            textColor: Colors.black,
            backgroundColor: colorPAODarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter2Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. \n${errors}Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 2 *
            ((firstCorrect ? 0 : 1) +
                (secondCorrect ? 0 : 1) +
                (thirdCorrect ? 0 : 1) +
                (fourthCorrect ? 0 : 1) +
                (fifthCorrect ? 0 : 1)),
      );
    }
    text1Controller.text = '';
    text2Controller.text = '';
    text3Controller.text = '';
    text4Controller.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.heavyImpact();
    await prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
    await prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
    await prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
    if (await prefs.getBool(phoneticAlphabetTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(phoneticAlphabetTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Head back to test prep to study up!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
    Navigator.pop(context);
    widget.callback();
  }

  morseCodeWord() {
    String morseString = '';
    decodeWord.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      int index = letters.indexWhere(
          (letter) => letter.toLowerCase() == character.toLowerCase());
      morseString += morse[index] + '  ';
    });
    return Text(
      morseString,
      style: TextStyle(fontSize: 24, fontFamily: 'SpaceMono'),
      textAlign: TextAlign.center,
    );
  }

  resetMorseGuess() {
    setState(() {
      morseGuess = '';
    });
  }

  void _increaseCounterWhilePressed() async {
    if (increaseLoopActive) return;
    increaseLoopActive = true;
    while (buttonPressed) {
      setState(() {
        countdownCounter = 0;
        morseButtonCounter++;
      });
      await Future.delayed(
        Duration(
          milliseconds: milliseconds,
        ),
      );
    }
    increaseLoopActive = false;
  }

  void _wordCountdown() async {
    if (countdownLoopActive) return;
    countdownLoopActive = true;
    while (countdownCounter < countdownThreshold) {
      setState(() {
        countdownCounter++;
      });
      await Future.delayed(
        Duration(
          milliseconds: milliseconds,
        ),
      );
    }
    morseGuess += '/';
    countdownCounter = 0;
    countdownLoopActive = false;
    setState(() {});
  }

  getMorseCounterText() {
    if (countdownLoopActive && !buttonPressed) {
      return 'Next letter!';
    } else if (morseButtonCounter == 0) {
      return 'Press the button!';
    }
    if (morseButtonCounter > dashThreshold) {
      return 'DASH';
    }
    return 'DOT';
  }

  getMorseState() {
    if (increaseLoopActive) {
      return Column(
        children: <Widget>[
          Container(
            height: 5,
            width: morseButtonCounter.toDouble() * counterWidthRatio,
            decoration: BoxDecoration(
              color: morseButtonCounter > dashThreshold
                  ? Colors.blue
                  : Colors.orange,
            ),
          ),
        ],
      );
    }
    return Container(
      height: 5,
    );

    // return Text(countdownCounter.toString());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Phonetic Alphabet: timed test'),
          backgroundColor: colorChapter2Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PhoneticAlphabetTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Write the NATO phonetic words for:',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                PhoneticWordGuess(
                  letter: randomLetter1,
                  textEditingController: text1Controller,
                ),
                showError1
                    ? Text(
                        'Your guess can\'t be blank!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                PhoneticWordGuess(
                  letter: randomLetter2,
                  textEditingController: text2Controller,
                ),
                showError2
                    ? Text(
                        'Your guess can\'t be blank!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 10),
                PhoneticWordGuess(
                  letter: randomLetter3,
                  textEditingController: text3Controller,
                ),
                showError3
                    ? Text(
                        'Your guess can\'t be blank!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(height: 30),
                Text(
                  'Encode this word into Morse code:',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  encodeWord,
                  style:
                      TextStyle(fontSize: 24, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: backgroundSemiColor,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                morseGuess,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          countdownLoopActive
                              ? Container(
                                  width: 5,
                                  height: initialCountdown * 2 -
                                      countdownCounter.toDouble() * 2,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                  ),
                                )
                              : Container(
                                  width: 5,
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(getMorseCounterText()),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Column(
                        children: <Widget>[
                          getMorseState(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 2,
                                height: 4,
                                decoration: BoxDecoration(color: Colors.blue),
                              ),
                              SizedBox(
                                width: dashThreshold.toDouble() * 5,
                              ),
                              Container(
                                width: 2,
                                height: 4,
                                decoration: BoxDecoration(color: Colors.blue),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Listener(
                            onPointerUp: (details) {
                              HapticFeedback.heavyImpact();
                              resetMorseGuess();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Text('Reset'),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Listener(
                            onPointerDown: (details) {
                              buttonPressed = true;
                              countdownCounter = 0;
                              _increaseCounterWhilePressed();
                            },
                            onPointerUp: (details) {
                              HapticFeedback.heavyImpact();
                              buttonPressed = false;
                              if (morseButtonCounter > dashThreshold) {
                                morseGuess += '-';
                              } else {
                                morseGuess += '•';
                              }
                              morseButtonCounter = 0;
                              setState(() {});
                              _wordCountdown();
                            },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: colorChapter2Lighter,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(),
                              ),
                              padding: EdgeInsets.all(10.0),
                              child: Center(child: Text('Press')),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Decode this Morse code word:',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: morseCodeWord(),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    controller: text4Controller,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        border: OutlineInputBorder(),
                        hintText: 'X' * decodeWord.length,
                        hintStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  ),
                ),
                showError3
                    ? Text(
                        'Your guess can\'t be blank!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200],
                      splashColor: Colors.grey,
                      padding: 10,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorChapter2Standard,
                      splashColor: colorChapter2Darker,
                      padding: 10,
                      fontSize: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                showError
                    ? Text(
                        'Your answer has errors!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(
                        height: 16,
                      ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneticWordGuess extends StatelessWidget {
  final String letter;
  final TextEditingController textEditingController;

  PhoneticWordGuess({this.letter, this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          letter,
          style: TextStyle(
            fontSize: 26,
            color: backgroundHighlightColor,
            fontFamily: 'SpaceMono',
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(width: 30),
        Container(
          width: 200,
          height: 50,
          child: Center(
            child: TextFormField(
              controller: textEditingController,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'SpaceMono',
                  color: backgroundHighlightColor),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: backgroundHighlightColor)),
                  border: OutlineInputBorder(),
                  hintText: 'XXXXX',
                  hintStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontFamily: 'SpaceMono',
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class PhoneticAlphabetTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Phonetic Alphabet Timed Test',
      information: [
        '    Time to recall your story! Now, which old apartment was that again...\n'
            '    When pressing the button, you will see graphically when it is being registered '
            'as a dot or a dash. There will also be a timer that indicates how much time you '
            'have left to start the next dot or dash before the letter is locked. A slash is a letter separator!',
        '    Here are the rules for Morse, if you were curious: \n'
            '  - The length of a dot is 1 time unit. \n  - A dash is 3 time units.\n'
            '  - The space between symbols (dots and dashes) of the same letter is 1 time unit.\n'
            '  - The space between letters is 3 time units.\n'
            '  - The space between words is 7 time units.'
      ],
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: phoneticAlphabetTimedTestFirstHelpKey,
    );
  }
}
