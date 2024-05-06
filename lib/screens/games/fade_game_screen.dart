import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';

import 'package:mem_plus_plus/services/services.dart';

class FadeGameScreen extends StatefulWidget {
  final int difficulty; // 0, 1, 2, 3, 4

  FadeGameScreen({Key? key, required this.difficulty}) : super(key: key);

  @override
  _FadeGameScreenState createState() => _FadeGameScreenState();
}

class _FadeGameScreenState extends State<FadeGameScreen>
    with SingleTickerProviderStateMixin {
  String randomSequence = '';
  String easy = '0123456789';
  String hard = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890123456789';
  int sequenceLength = 0;
  String difficultyName = '';
  int duration = 0;
  int count = 0;
  bool started = false;
  bool complete = false;
  var textController = TextEditingController();
  late AnimationController animationController;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    initializeSequence();
  }

  @override
  void dispose() {
    textController.dispose();
    animationController.dispose();
    super.dispose();
  }

  initializeSequence() {
    prefs.checkFirstTime(context, fadeGameFirstHelpKey, FadeGameScreenHelp());
    Random random = new Random();
    randomSequence = '';
    switch (widget.difficulty) {
      case 0:
        sequenceLength = 6;
        duration = 30;
        difficultyName = 'Easy';
        for (var i = 0; i < sequenceLength; i += 1) {
          randomSequence += easy[random.nextInt(easy.length)];
        }
        break;
      case 1:
        sequenceLength = 10;
        duration = 20;
        difficultyName = 'Medium';
        for (var i = 0; i < sequenceLength; i += 1) {
          randomSequence += easy[random.nextInt(easy.length)];
        }
        break;
      case 2:
        sequenceLength = 15;
        duration = 25;
        difficultyName = 'Difficult';
        for (var i = 0; i < sequenceLength; i += 1) {
          randomSequence += easy[random.nextInt(easy.length)];
        }
        break;
      case 3:
        sequenceLength = 21;
        duration = 27;
        difficultyName = 'Master';
        for (var i = 0; i < sequenceLength; i += 1) {
          randomSequence += easy[random.nextInt(easy.length)];
        }
        break;
      case 4:
        sequenceLength = 30;
        duration = 20;
        difficultyName = 'Ancient God';
        for (var i = 0; i < sequenceLength; i += 1) {
          randomSequence += easy[random.nextInt(easy.length)];
        }
        break;
    }
    animationController = AnimationController(
      duration: Duration(
        seconds: duration,
      ),
      vsync: this,
    );
    print('seq: $randomSequence');
  }

  Widget getColumn() {
    List<Widget> characters = [];
    double fraction = 1 / (randomSequence.length + 8);
    characters.add(SizedBox(
      height: 20,
    ));
    for (int i = 0; i < randomSequence.length; i += 1) {
      characters.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAwayAnimation(
              widget: Text(
                randomSequence[i],
                style: TextStyle(
                  fontSize: 44,
                  fontFamily: 'SpaceMono',
                  color: backgroundHighlightColor,
                ),
              ),
              controller: animationController,
              begin: i * fraction, // count * (1 / seqLen) is one segment
              end: 8 * fraction +
                  i * fraction, // count * (1 / seqLen) + (1 / seqLen)
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
      );
    }
    return Stack(
      children: <Widget>[
        Column(
          children: characters,
        ),
        Container(
          height: 64 * randomSequence.length.toDouble(),
          width: 40,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: PercentageAnimation(
              controller: animationController,
              color: Colors.lightBlue,
              size: 64 * randomSequence.length.toDouble(),
              begin: 0,
              end: 0.95,
              widget: Text('test text'),
            ),
          ),
        ),
      ],
    );
  }

  checkAnswer(BuildContext context) async {
    if (textController.text.trim() == randomSequence) {
      if (!prefs.getBool('fade${widget.difficulty}Complete')) {
        showSnackBar(
          context: context,
          snackBarText: 'Congrats! You\'ve beaten $difficultyName difficulty!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congrats! You\'re a beast!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
        );
      }
      prefs.setBool("fade${widget.difficulty}Complete", true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Fade'),
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
                      return FadeGameScreenHelp();
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
              Stack(
                children: <Widget>[
                  complete
                      ? Container()
                      : started
                          ? Container()
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                  ),
                                  BasicFlatButton(
                                    text: 'GO!',
                                    color: colorGamesLighter,
                                    fontSize: 42,
                                    padding: 20,
                                    onPressed: () {
                                      animationController.reset();
                                      animationController.forward();
                                      setState(() {
                                        started = true;
                                      });
                                      Future.delayed(
                                          Duration(seconds: duration), () {
                                        setState(() {
                                          complete = true;
                                        });
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                  complete ? Container() : getColumn(),
                ],
              ),
              complete
                  ? Container()
                  : SizedBox(
                      height: 30,
                    ),
              complete
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 200,
                          child: TextFormField(
                              controller: textController,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SpaceMono',
                                  color: backgroundHighlightColor),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: backgroundHighlightColor)),
                                  border: OutlineInputBorder(),
                                  hintText: 'X' * randomSequence.length,
                                  hintStyle: TextStyle(
                                      fontSize: 20, color: Colors.grey))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                  complete = false;
                                  Navigator.pop(context);
                                  showSnackBar(
                                    context: context,
                                    snackBarText: 'Try again!',
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
                      ],
                    )
                  : Container(),
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

class FadeGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Fade Game',
      information: [
        '    This is the FADE game! When you\'re mentally ready, hit the GO button! A code will appear and '
            'disappear, and your job is to memorize the code before it turns to dust. \n    These are nuclear '
            'launch disarming codes by the way. Go save the world!',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: fadeGameFirstHelpKey,
    );
  }
}
