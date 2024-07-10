import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';

class IrrationalGameScreen extends StatefulWidget {
  final int difficulty; // 0, 1, 2, 3, 4, 5 (3 levels for PI, 3 levels for e)
  final scaffoldKey;

  IrrationalGameScreen({Key? key, required this.difficulty, this.scaffoldKey})
      : super(key: key);

  @override
  _IrrationalGameScreenState createState() => _IrrationalGameScreenState();
}

class _IrrationalGameScreenState extends State<IrrationalGameScreen> {
  bool ready = false;
  bool complete = false;
  String stageName = '';
  String correctSequence = '';
  String viewCorrectSequence = '';
  String intro = '';
  int position = 0;
  String guessedText = '';
  String verifyGuess = '';
  String guessedText2 = '';
  String latestGuess = ' ';
  String shouldHaveBeen = '';
  Color stateColor = Colors.green;
  var textController = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initializeSequence();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  initializeSequence() {
    prefs.checkFirstTime(
        context, irrationalGameFirstHelpKey, IrrationalGameScreenHelp());
    switch (widget.difficulty) {
      case 0:
        stageName = '200 digits of pi';
        intro = 'π ≈ 3.';
        correctSequence = piValue.substring(2, 202);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    3.';
        updateValues('');
        break;
      case 1:
        stageName = '500 digits of pi';
        intro = 'π ≈ 3.';
        correctSequence = piValue.substring(2, 502);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    3.';
        updateValues('');
        break;
      case 2:
        stageName = '1000 digits of pi';
        intro = 'π ≈ 3.';
        correctSequence = piValue.substring(2, 1002);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    3.';
        updateValues('');
        break;
      case 3:
        stageName = '200 digits of e';
        intro = 'e ≈ 2.';
        correctSequence = eValue.substring(2, 202);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    2.';
        updateValues('');
        break;
      case 4:
        stageName = '500 digits of e';
        intro = 'e ≈ 2.';
        correctSequence = eValue.substring(2, 502);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    2.';
        updateValues('');
        break;
      case 5:
        stageName = '1000 digits of e';
        intro = 'e ≈ 2.';
        correctSequence = eValue.substring(2, 1002);
        viewCorrectSequence = fillToMultiple(correctSequence, 18);
        guessedText = '    2.';
        updateValues('');
        break;
    }
    String savedPositionString =
        prefs.getString('irrational${widget.difficulty}SavedPosition');
    setState(() {
      position = int.parse(savedPositionString);
    });
  }

  String fillToMultiple(String s, int multiple) {
    while (s.length % multiple != 0) {
      s += ' ';
    }
    return s;
  }

  updateActiveRow(int newPosition) {
    prefs.setString(
        'irrational${widget.difficulty}SavedPosition', newPosition.toString());
    setState(() {
      position = newPosition;
    });
  }

  checkAnswer(BuildContext context) {
    if (textController.text.trim() == correctSequence) {
      if (!prefs.getBool('irrational${widget.difficulty}Complete')) {
        showSnackBar(
          context: context,
          snackBarText: 'Congrats! You\'ve memorized $stageName!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Awesome! You\'re amazing!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
        );
      }
      prefs.setBool('irrational${widget.difficulty}Complete', true);
    } else {
      showSnackBar(
        context: context,
        snackBarText: 'Incorrect. Try again sometime!',
        backgroundColor: colorIncorrect,
        textColor: Colors.black,
      );
    }
    Navigator.pop(context);
  }

  Widget getColumn() {
    List<Widget> rows = [];
    int count = 1;
    String tempRow = '';
    viewCorrectSequence.runes.forEach((int rune) {
      var character = new String.fromCharCode(rune);
      tempRow += character;
      if (count % 18 == 0) {
        int tempRowRow = count ~/ 18;
        rows.add(
          ElevatedButton(
            onLongPress: () {
              HapticFeedback.mediumImpact();
              updateActiveRow(tempRowRow);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tempRowRow == position
                  ? Colors.lightBlue[500]
                  : backgroundColor,
            ),
            onPressed: null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  tempRow.substring(0, 6),
                  style: TextStyle(
                    fontSize: 20,
                    color: tempRowRow == position
                        ? Colors.white
                        : backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  tempRow.substring(6, 12),
                  style: TextStyle(
                    fontSize: 20,
                    color: tempRowRow == position
                        ? Colors.white
                        : backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  tempRow.substring(12, 18),
                  style: TextStyle(
                    fontSize: 20,
                    color: tempRowRow == position
                        ? Colors.white
                        : backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
          ),
        );
        tempRow = '';
      }
      count += 1;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Text(
          'Long press a row to save your position!',
          style: TextStyle(
            fontSize: 14,
            color: backgroundHighlightColor,
          ),
        ),
        Text(
          intro,
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'SpaceMono',
            color: backgroundHighlightColor,
          ),
        ),
        SizedBox(height: 10),
        Column(
          children: rows,
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BasicFlatButton(
              text: 'Let\'s do this',
              fontSize: 26,
              color: colorGamesStandard,
              onPressed: () {
                setState(() {
                  ready = true;
                });
              },
            )
          ],
        )
      ],
    );
  }

  updateValues(String allText) {
    allText = '3.' + allText;
    allText = allText.padLeft(15, ' ');
    setState(() {
      guessedText = allText.substring(allText.length - 15, allText.length - 4);
      verifyGuess = allText.substring(allText.length - 4, allText.length - 3);
      guessedText2 = allText.substring(allText.length - 3, allText.length - 1);
      latestGuess = allText.substring(allText.length - 1, allText.length);
    });
    // check if value is correct
    int guessLength = textController.text.length;
    if (guessLength > 3 &&
        verifyGuess !=
            correctSequence.substring(guessLength - 4, guessLength - 3)) {
      setState(() {
        stateColor = Colors.red;
        complete = true;
        FocusScope.of(context).unfocus();
        shouldHaveBeen =
            correctSequence.substring(guessLength - 4, guessLength - 3);
      });
    }
    // check if value is complete
    if (textController.text.length == correctSequence.length) {
      complete = true;
      FocusScope.of(context).unfocus();
      checkAnswer(context);
    }
  }

  Widget getGuess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  guessedText,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                SizedBox(width: 5),
                Column(
                  children: <Widget>[
                    SizedBox(height: 24),
                    Container(
                      width: 40,
                      height: 60,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 60,
                              width: 40,
                              decoration: BoxDecoration(
                                color:
                                    Color.fromRGBO(0, 0, 0, 0), // transparent
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(width: 5, color: stateColor),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              verifyGuess,
                              style: TextStyle(
                                fontSize: 38,
                                fontFamily: 'SpaceMono',
                                color: stateColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3),
                    stateColor == Colors.red
                        ? Icon(MdiIcons.closeOutline, color: stateColor)
                        : Icon(
                            MdiIcons.checkOutline,
                            color: stateColor,
                          ),
                  ],
                ),
                SizedBox(width: 5),
                Text(
                  guessedText2,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  latestGuess,
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: 'SpaceMono',
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    colors: [
                      backgroundColor.withOpacity(1),
                      backgroundColor.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          width: 1,
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.phone,
            onChanged: (text) => updateValues(text),
            // autofocus: true,
            focusNode: focusNode,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        complete
            ? Column(
                children: <Widget>[
                  stateColor == Colors.red
                      ? Text(
                          'Should have been: $shouldHaveBeen',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        )
                      : Text(
                          'Awesome job! You did it!',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                  SizedBox(height: 15),
                  BasicFlatButton(
                    text: 'Back to menu',
                    fontSize: 24,
                    color: stateColor == Colors.red
                        ? Colors.red[100]!
                        : Colors.green[100]!,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : Text(
                '${textController.text.length}/${correctSequence.length} entered',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
        MediaQuery.of(context).viewInsets.bottom > 10
            ? Container()
            : Column(
                children: [
                  SizedBox(height: 20),
                  BasicFlatButton(
                    color: Colors.pink[200]!,
                    text: 'Keyboard ran away? Tap here to show it.',
                    fontSize: 12,
                    textColor: Colors.black,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Timer(const Duration(milliseconds: 1), () {
                        FocusScope.of(context).requestFocus(focusNode);
                      });
                    },
                  ),
                ],
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Irrational Game', style: TextStyle(fontSize: 18)),
          backgroundColor: colorGamesDarker,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return IrrationalGameScreenHelp();
                    },
                  ),
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              ready ? getGuess() : getColumn(),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IrrationalGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Irrational Game',
      information: [
        '    This is the IRRATIONAL game! This is an arena to really test the limits of how long a sequence you can memorize.\n\n'
            '    Take your time and create a wonderfully memorable story! Long press a row to keep track of your progress.',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: irrationalGameFirstHelpKey,
      callback: () {},
    );
  }
}
