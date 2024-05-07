import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/components/standard/morse_test.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:word_generator/word_generator.dart';

class PhoneticAlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PhoneticAlphabetTimedTestScreen(
      {required this.callback, required this.globalKey});

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
  late String randomLetter1;
  late String randomLetter2;
  late String randomLetter3;
  String encodeWord = '';
  String decodeWord = '';
  String morseGuess = '';
  bool showError = false;
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
  bool showError5 = false;
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
        PhoneticAlphabetTimedTestScreenHelp(callback: widget.callback));
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
    final wordGenerator = WordGenerator();
    encodeWord = wordGenerator.randomNoun().toLowerCase();
    while (encodeWord.length > 8) {
      encodeWord = wordGenerator.randomNoun().toLowerCase();
    }

    // generate random word, convert it to morse code
    decodeWord = wordGenerator.randomNoun().toLowerCase();
    while (decodeWord.length > 8) {
      decodeWord = wordGenerator.randomNoun().toLowerCase();
    }

    setState(() {});
  }

  updateMorseGuess(String guess) {
    setState(() {
      morseGuess = guess;
    });
  }

  void checkAnswer() async {
    setState(() {
      showError = false;
      showError1 = false;
      showError2 = false;
      showError3 = false;
      showError5 = false;
    });
    HapticFeedback.lightImpact();
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
    var correct1 = (phoneticAlphabet[index1].toLowerCase().replaceAll('-', ''));
    int index2 = letters.indexWhere(
        (letter) => letter.toLowerCase() == randomLetter2.toLowerCase());
    var correct2 = (phoneticAlphabet[index2].toLowerCase().replaceAll('-', ''));
    int index3 = letters.indexWhere(
        (letter) => letter.toLowerCase() == randomLetter3.toLowerCase());
    var correct3 = (phoneticAlphabet[index3].toLowerCase().replaceAll('-', ''));
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
    if (firstCorrect &&
        secondCorrect &&
        thirdCorrect &&
        fourthCorrect &&
        fifthCorrect) {
      prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
      prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
      prefs.setBool(morseGameAvailableKey, true);
      if (!prefs.getBool(morseGameFirstViewKey)) {
        prefs.setBool(newGamesAvailableKey, true);
        prefs.setBool(morseGameFirstViewKey, true);
      }
      if (!prefs.getBool(phoneticAlphabetTimedTestCompleteKey)) {
        prefs.setBool(phoneticAlphabetTimedTestCompleteKey, true);
        prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
        if (!prefs.getBool(airportTimedTestCompleteKey)) {
          showSnackBar(
            context: context,
            snackBarText:
                'Awesome job! Complete the Airport test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter2Darker,
            durationSeconds: 3,
          );
        } else {
          prefs.updateActivityVisible(paoEditKey, true);
          showSnackBar(
            context: context,
            snackBarText: 'Congratulations! You\'ve unlocked the PAO system!',
            textColor: Colors.white,
            backgroundColor: colorPAODarker,
            durationSeconds: 3,
            isSuper: true,
          );
          showSnackBar(
            context: context,
            snackBarText: 'Congratulations! You\'ve unlocked the Morse game!',
            textColor: Colors.white,
            backgroundColor: colorGamesDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter2Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
        snackBarText:
            'Incorrect. \n${errors}Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: ((firstCorrect ? 0 : 2) +
            (secondCorrect ? 0 : 2) +
            (thirdCorrect ? 0 : 2) +
            (fourthCorrect ? 0 : 2) +
            (fifthCorrect ? 0 : 4)),
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
    HapticFeedback.lightImpact();
    prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
    prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
    prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
    if (!prefs.getBool(phoneticAlphabetTimedTestCompleteKey)) {
      prefs.updateActivityState(phoneticAlphabetTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        context: context,
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
      style: TextStyle(
        fontSize: 24,
        fontFamily: 'SpaceMono',
        color: backgroundHighlightColor,
      ),
      textAlign: TextAlign.center,
    );
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
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PhoneticAlphabetTimedTestScreenHelp(
                          callback: widget.callback);
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
                  child: MorseTest(
                    callback: updateMorseGuess,
                    morseAnswer: encodeWord,
                    color: colorChapter2Standard,
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
                      color: Colors.grey[200]!,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorChapter2Standard,
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

  PhoneticWordGuess(
      {required this.letter, required this.textEditingController});

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
  final Function callback;
  PhoneticAlphabetTimedTestScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Phonetic Alphabet Timed Test',
      information: [
        '    Time to recall your story! Now, which old apartment was that again...',
        '    When pressing the Morse button, you will see graphically when it is being registered '
            'as a dot or a dash. There will also be a timer that indicates how much time you '
            'have left to start the next dot or dash before the letter is locked. A slash is a letter separator!',
        '    Here are the rules for Morse, if you were curious: \n'
            '  - The length of a dot is 1 time unit. \n  - A dash is 3 time units.\n'
            '  - The space between symbols (dots and dashes) of the same letter is 1 time unit.\n'
            '  - The space between letters is 3 time units.\n'
            '  - The space between words is 7 time units.\n\n    Don\'t worry about getting it exactly right! :) '
      ],
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: phoneticAlphabetTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
