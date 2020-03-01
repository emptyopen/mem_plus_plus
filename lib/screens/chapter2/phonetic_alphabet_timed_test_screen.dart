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
  String randomWord = '';
  bool showError1 = false;
  bool showError2 = false;
  bool showError3 = false;
  bool showError4 = false;
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

    // generate random word, convert it to morse code
    generateNoun(maxSyllables: 5).take(1).forEach((word) {
      randomWord = word.asLowerCase;
    });
    print(randomWord);
    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError1 = false;
      showError2 = false;
      showError3 = false;
      showError4 = false;
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
        showError4 = true;
      });
    }
    if (showError1 || showError2 || showError3 || showError4) {
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
    if (text1Controller.text.trim().toLowerCase() == correct1 &&
        text2Controller.text.trim().toLowerCase() == correct2 && 
        text3Controller.text.trim().toLowerCase() == correct3 && 
        text4Controller.text.trim().toLowerCase() == randomWord) {
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
            snackBarText:
                'Congratulations! You\'ve unlocked the PAO system!',
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
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
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
    randomWord.runes.forEach((int rune) {
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

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      randomLetter1,
                      style: TextStyle(
                          fontSize: 26, color: backgroundHighlightColor, 
                            fontFamily: 'SpaceMono',),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextFormField(
                        controller: text1Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SpaceMono',
                            color: backgroundHighlightColor),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: backgroundSemiColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: backgroundHighlightColor)),
                            border: OutlineInputBorder(),
                            hintText: 'XXXXX',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'SpaceMono',
                            )),
                      ),
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      randomLetter2,
                      style: TextStyle(
                          fontSize: 26, color: backgroundHighlightColor, fontFamily: 'SpaceMono',),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(width: 30),
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextFormField(
                        controller: text2Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SpaceMono',
                            color: backgroundHighlightColor),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: backgroundSemiColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: backgroundHighlightColor)),
                            border: OutlineInputBorder(),
                            hintText: 'XXXXX',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'SpaceMono',
                            )),
                      ),
                    ),
                  ],
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      randomLetter3,
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: TextFormField(
                        controller: text3Controller,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'SpaceMono',
                            color: backgroundHighlightColor),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: backgroundSemiColor)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: backgroundHighlightColor)),
                            border: OutlineInputBorder(),
                            hintText: 'XXXXX',
                            hintStyle:
                                TextStyle(fontSize: 14, color: Colors.grey)),
                      ),
                    ),
                  ],
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
                  'Decode this Morse code word:',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: morseCodeWord(),
                ),
                SizedBox(
                  height: 30,
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
                        fontSize: 14,
                        fontFamily: 'SpaceMono',
                        color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXX',
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey)),
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
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhoneticAlphabetTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Phonetic Alphabet Timed Test',
      information: [
        '    Time to recall your story! Now, which old apartment was that again...'
      ],
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: phoneticAlphabetTimedTestFirstHelpKey,
    );
  }
}
