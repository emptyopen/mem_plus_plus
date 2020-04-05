import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:mem_plus_plus/services/services.dart';

import '../../constants/colors.dart';

class IrrationalGameScreen extends StatefulWidget {
  final int difficulty; // 0, 1, 2, 3, 4, 5 (3 levels for PI, 3 levels for e)
  final scaffoldKey;

  IrrationalGameScreen({Key key, this.difficulty, this.scaffoldKey})
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
  var prefs = PrefsUpdater();

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

  initializeSequence() async {
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
        await prefs.getString('irrational${widget.difficulty}SavedPosition');
    if (savedPositionString == null) {
      position = 0;
    } else {
      setState(() {
        position = int.parse(savedPositionString);
      });
    }
  }

  String fillToMultiple(String s, int multiple) {
    while (s.length % multiple != 0) {
      s += ' ';
    }
    return s;
  }

  updateActiveRow(int newPosition) async {
    await prefs.setString(
        'irrational${widget.difficulty}SavedPosition', newPosition.toString());
    setState(() {
      position = newPosition;
    });
  }

  checkAnswer(BuildContext context) async {
    if (textController.text.trim() == correctSequence) {
      if (await prefs.getBool('irrational${widget.difficulty}Complete') ==
          null) {
        showSnackBar(
          scaffoldState: widget.scaffoldKey.currentState,
          snackBarText: 'Congrats! You\'ve memorized $stageName!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.scaffoldKey.currentState,
          snackBarText: 'Awesome! You\'re amazing!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
        );
      }
      await prefs.setBool('irrational${widget.difficulty}Complete', true);
    } else {
      showSnackBar(
        scaffoldState: widget.scaffoldKey.currentState,
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
          FlatButton(
            color: tempRowRow == position
                ? Colors.lightBlue[500]
                : backgroundColor,
            onLongPress: () {
              HapticFeedback.heavyImpact();
              updateActiveRow(tempRowRow);
            },
            onPressed: null,
            highlightColor: Colors.lightBlue[100],
            splashColor: Color.fromRGBO(255, 0, 0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  tempRow.substring(0, 6),
                  style: TextStyle(
                    fontSize: 20,
                    color: backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  tempRow.substring(6, 12),
                  style: TextStyle(
                    fontSize: 20,
                    color: backgroundHighlightColor,
                    fontFamily: 'SpaceMono',
                  ),
                ),
                Text(
                  tempRow.substring(12, 18),
                  style: TextStyle(
                    fontSize: 20,
                    color: backgroundHighlightColor,
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
          height: 20,
        ),
        Text(
          '(Long press a row to save your position!)',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(height: 10),
        Text(
          intro,
          style: TextStyle(
            fontSize: 40,
            fontFamily: 'SpaceMono',
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
              padding: 15,
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
    print('${textController.text.length} == ${correctSequence.length}');
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
            autofocus: true,
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
                    padding: 10,
                    color: stateColor == Colors.red
                        ? Colors.red[100]
                        : Colors.green[100],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Irrational Game'),
          backgroundColor: colorGamesDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
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
    return HelpScreen(
      title: 'Irrational Game',
      information: [
        '    This is the IRRATIONAL game! This is an arena to really test the limits of how long a sequence you can memorize.\n\n'
            '    Take your time and create a wonderfully memorable story! Long press a row to keep track of your progress :)',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: irrationalGameFirstHelpKey,
    );
  }
}
