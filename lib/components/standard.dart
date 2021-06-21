import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';

class BasicFlatButton extends StatelessWidget {
  final Color color;
  final Color splashColor;
  final String text;
  final double fontSize;
  final Function onPressed;
  final double padding;
  final Color textColor;
  final String fontFamily;

  BasicFlatButton({
    this.color = Colors.white,
    this.splashColor,
    this.text,
    this.fontSize,
    this.onPressed,
    this.padding = 0,
    this.textColor = Colors.black,
    this.fontFamily = 'CabinSketch',
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      splashColor: splashColor,
      highlightColor: Colors.transparent,
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), side: BorderSide()),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class BigButton extends StatelessWidget {
  final String title;
  final Function function;
  final Color color1;
  final Color color2;

  BigButton({this.title, this.function, this.color1, this.color2});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: FlatButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          function();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 2.5),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class MainMenuOption extends StatelessWidget {
  final Activity activity;
  final Icon icon;
  final String text;
  final Color color;
  final Color splashColor;
  final Widget route;
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;
  final bool isCustomTest;
  final bool isButton;
  final function;
  final Color textColor;
  final prefs = PrefsUpdater();

  MainMenuOption({
    Key key,
    this.activity,
    this.icon,
    this.text,
    this.color,
    this.splashColor,
    this.route,
    this.callback,
    this.globalKey,
    this.isCustomTest = false,
    this.isButton = false,
    this.textColor = Colors.black,
    this.function,
  });

  String generateTimeRemaining() {
    return durationToString(
        activity.visibleAfterTime.difference(DateTime.now()));
  }

  String getActivityName() {
    return text;
  }

  cancelActivity() async {
    print('canceling ${activity.name}');
    switch (activity.name) {
      case singleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(singleDigitTimedTestKey, 'review');
        await prefs.updateActivityVisible(singleDigitTimedTestKey, false);
        await prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
        if (await prefs.getBool(singleDigitTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
        }
        break;
      case faceTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(faceTimedTestKey, 'review');
        await prefs.updateActivityVisible(faceTimedTestKey, false);
        await prefs.updateActivityVisible(faceTimedTestPrepKey, true);
        if (await prefs.getBool(faceTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(faceTimedTestPrepKey, 'todo');
        }
        break;
      case planetTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(planetTimedTestKey, 'review');
        await prefs.updateActivityVisible(planetTimedTestKey, false);
        await prefs.updateActivityVisible(planetTimedTestPrepKey, true);
        if (await prefs.getBool(planetTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(planetTimedTestPrepKey, 'todo');
        }
        break;
      case alphabetTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(alphabetTimedTestKey, 'review');
        await prefs.updateActivityVisible(alphabetTimedTestKey, false);
        await prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
        if (await prefs.getBool(alphabetTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(alphabetTimedTestPrepKey, 'todo');
        }
        break;
      case phoneticAlphabetTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
        await prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
        await prefs.updateActivityVisible(
            phoneticAlphabetTimedTestPrepKey, true);
        if (await prefs.getBool(phoneticAlphabetTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(
              phoneticAlphabetTimedTestPrepKey, 'todo');
        }
        break;
      case airportTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(airportTimedTestKey, 'review');
        await prefs.updateActivityVisible(airportTimedTestKey, false);
        await prefs.updateActivityVisible(airportTimedTestPrepKey, true);
        if (await prefs.getBool(airportTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(airportTimedTestPrepKey, 'todo');
        }
        break;
      case paoTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(paoTimedTestKey, 'review');
        await prefs.updateActivityVisible(paoTimedTestKey, false);
        await prefs.updateActivityVisible(paoTimedTestPrepKey, true);
        if (await prefs.getBool(paoTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(paoTimedTestPrepKey, 'todo');
        }
        break;
      case face2TimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(face2TimedTestKey, 'review');
        await prefs.updateActivityVisible(face2TimedTestKey, false);
        await prefs.updateActivityVisible(face2TimedTestPrepKey, true);
        if (await prefs.getBool(face2TimedTestCompleteKey) == null) {
          await prefs.updateActivityState(face2TimedTestPrepKey, 'todo');
        }
        break;
      case piTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(piTimedTestKey, 'review');
        await prefs.updateActivityVisible(piTimedTestKey, false);
        await prefs.updateActivityVisible(piTimedTestPrepKey, true);
        if (await prefs.getBool(piTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(piTimedTestPrepKey, 'todo');
        }
        break;
      case deckTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(deckTimedTestKey, 'review');
        await prefs.updateActivityVisible(deckTimedTestKey, false);
        await prefs.updateActivityVisible(deckTimedTestPrepKey, true);
        if (await prefs.getBool(deckTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(deckTimedTestPrepKey, 'todo');
        }
        break;
      case tripleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        await prefs.updateActivityState(tripleDigitTimedTestKey, 'review');
        await prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
        await prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
        if (await prefs.getBool(tripleDigitTimedTestCompleteKey) == null) {
          await prefs.updateActivityState(tripleDigitTimedTestPrepKey, 'todo');
        }
        break;
    }
    callback();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (isButton) {
      return Container(
        height: 50,
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth * 0.85,
              height: 46,
              decoration: BoxDecoration(
                  color: color,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                height: 46,
                child: FlatButton(
                  onPressed: () {
                    function();
                  },
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: (TextStyle(color: textColor)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 50,
      width: screenWidth * 0.85,
      child: Stack(
        children: <Widget>[
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: splashColor,
              borderRadius: BorderRadius.circular(5),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  splashColor,
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: FlatButton(
              splashColor: splashColor,
              highlightColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(),
                borderRadius: BorderRadius.circular(5),
              ),
              onPressed: () async {
                HapticFeedback.lightImpact();
                globalKey.currentState.hideCurrentSnackBar();
                if (activity.visibleAfterTime.compareTo(DateTime.now()) > 0) {
                  return null;
                }
                if (activity.firstView) {
                  await prefs.updateActivityFirstView(activity.name, false);
                  callback();
                }
                slideTransition(context, route);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  icon,
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth * .65,
                        maxWidth: screenWidth * .65,
                        minHeight: 46,
                        maxHeight: 46,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AutoSizeText(
                            text,
                            style: TextStyle(fontSize: 41),
                            maxLines: 1,
                            maxFontSize: 24,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          activity.firstView
              ? Positioned(
                  child: Container(
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Color.fromRGBO(255, 255, 255, 0.85),
                    ),
                    child: Shimmer.fromColors(
                      period: Duration(seconds: 3),
                      baseColor: Colors.black,
                      highlightColor: Colors.greenAccent,
                      child: Center(
                          child: Text(
                        'new!',
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      )),
                    ),
                  ),
                  left: 3,
                  top: 4)
              : Container(),
          activity.visibleAfterTime.compareTo(DateTime.now()) < 0
              ? Container()
              : Container(
                  width: screenWidth * 0.85,
                  height: 46,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.85),
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5)),
                  child: isCustomTest
                      ? Center(
                          child: Text(
                            '${getActivityName()} in ${generateTimeRemaining()}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Center(
                              child: Text(
                                '${getActivityName().contains('[Timed Test]') ? getActivityName().replaceAll('[Timed Test]', 'Test') : getActivityName()} in ${generateTimeRemaining()}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 75,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: BasicFlatButton(
                                text: 'Cancel',
                                onPressed: () => showConfirmDialog(
                                  context: context,
                                  function: cancelActivity,
                                  confirmText:
                                      'Are you sure you want to give up?',
                                  confirmColor: splashColor,
                                ),
                                textColor: Colors.white,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                            ),
                          ],
                        ),
                ),
        ],
      ),
    );
  }
}

class CondensedMainMenuButtons extends StatelessWidget {
  final Activity editActivity;
  final Activity practiceActivity;
  final Activity testActivity;
  final Activity timedTestPrepActivity;
  final Icon testIcon;
  final String text;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonSplashColor;
  final Widget editRoute;
  final Widget practiceRoute;
  final Widget testRoute;
  final Widget timedTestPrepRoute;
  final Function() callback;
  final prefs = PrefsUpdater();

  CondensedMainMenuButtons({
    Key key,
    this.editActivity,
    this.practiceActivity,
    this.testActivity,
    this.timedTestPrepActivity,
    this.testIcon,
    this.text,
    this.backgroundColor,
    this.buttonColor,
    this.buttonSplashColor,
    this.editRoute,
    this.practiceRoute,
    this.testRoute,
    this.timedTestPrepRoute,
    this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: screenWidth * 0.85,
          decoration: BoxDecoration(
              border: Border.all(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [backgroundColor, buttonSplashColor], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(text,
                    style: TextStyle(fontSize: 24), textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CondensedMenuButton(
                    activity: editActivity,
                    callback: callback,
                    route: editRoute,
                    icon: editIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: practiceActivity,
                    callback: callback,
                    route: practiceRoute,
                    icon: practiceIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: testActivity,
                    callback: callback,
                    route: testRoute,
                    icon: testIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: timedTestPrepActivity,
                    callback: callback,
                    route: timedTestPrepRoute,
                    icon: timedTestPrepIcon,
                    color: backgroundColor,
                    testPrepAvailable: timedTestPrepActivity.visible,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 3,
        )
      ],
    );
  }
}

class CondensedMainMenuChapterButtons extends StatelessWidget {
  final Activity lesson;
  final Activity activity1;
  final Activity activity2;
  final Icon activity1Icon;
  final Icon activity2Icon;
  final String text;
  final Color standardColor;
  final Color darkerColor;
  final Widget lessonRoute;
  final Widget activity1Route;
  final Widget activity2Route;
  final Function() callback;
  final prefs = PrefsUpdater();

  CondensedMainMenuChapterButtons({
    Key key,
    this.lesson,
    this.activity1,
    this.activity2,
    this.activity1Icon,
    this.activity2Icon,
    this.text,
    this.standardColor,
    this.darkerColor,
    this.lessonRoute,
    this.activity1Route,
    this.activity2Route,
    this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: screenWidth * 0.85,
          decoration: BoxDecoration(
              border: Border.all(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [standardColor, darkerColor], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(text,
                    style: TextStyle(fontSize: text.length > 24 ? 22 : 24),
                    textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CondensedMenuButton(
                    activity: lesson,
                    callback: callback,
                    route: lessonRoute,
                    icon: lessonIcon,
                    color: standardColor,
                  ),
                  CondensedMenuButton(
                    activity: activity1,
                    callback: callback,
                    route: activity1Route,
                    icon: activity1Icon,
                    color: standardColor,
                    testPrepAvailable: activity1.visible,
                  ),
                  CondensedMenuButton(
                    activity: activity2,
                    callback: callback,
                    route: activity2Route,
                    icon: activity2Icon,
                    color: standardColor,
                    testPrepAvailable: activity2.visible,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 3,
        )
      ],
    );
  }
}

class CondensedMenuButton extends StatelessWidget {
  final Activity activity;
  final Function callback;
  final Widget route;
  final Icon icon;
  final Color color;
  final bool testPrepAvailable;
  final prefs = PrefsUpdater();

  CondensedMenuButton(
      {this.activity,
      this.callback,
      this.route,
      this.icon,
      this.color,
      this.testPrepAvailable = true});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 10,
      child: RaisedButton(
        child: icon,
        onPressed: testPrepAvailable
            ? () async {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) =>
                        route,
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) =>
                        SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                );
              }
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(),
        ),
        color: color,
      ),
    );
  }
}

class OKPopButton extends StatelessWidget {
  final Color color;
  final Color splashColor;

  OKPopButton(
      {Key key, this.color = Colors.white, this.splashColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      text: 'OK',
      color: color,
      splashColor: splashColor,
      fontSize: 20,
      padding: 10,
    );
  }
}

class MorseTest extends StatefulWidget {
  final Function callback;
  final String morseAnswer;
  final Color color;

  MorseTest({this.callback, this.morseAnswer, this.color});

  @override
  _MorseTestState createState() => _MorseTestState();
}

class _MorseTestState extends State<MorseTest> {
  String morseGuess = '';

  int morseButtonCounter = 0;
  bool buttonPressed = false;
  bool increaseLoopActive = false;
  int countdownCounter = 0;
  bool countdownLoopActive = false;
  int dashThreshold = 15;
  int initialCountdown = 30;
  int countdownThreshold = 30;
  int milliseconds = 25;
  int counterWidthRatio = 5;

  double textboxHeight = 30;

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
    checkNewHeight();
    countdownCounter = 0;
    countdownLoopActive = false;
    widget.callback(morseGuess);
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

  resetMorseGuess() {
    setState(() {
      morseGuess = '';
    });
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

  checkNewHeight() {
    textboxHeight = 30 * (morseGuess.length ~/ 18 + 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: SizedBox(
                  width: 270,
                  height: textboxHeight,
                  child: Text(
                    morseGuess,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SpaceMono',
                      color: backgroundHighlightColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            countdownLoopActive
                ? Container(
                    width: 5,
                    height:
                        initialCountdown * 1 - countdownCounter.toDouble() * 1,
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
                HapticFeedback.lightImpact();
                resetMorseGuess();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                ),
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Reset',
                  style: TextStyle(fontSize: 18),
                ),
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
                HapticFeedback.lightImpact();
                buttonPressed = false;
                if (morseButtonCounter > dashThreshold) {
                  morseGuess += '-';
                } else {
                  morseGuess += '•';
                }
                morseButtonCounter = 0;
                widget.callback(morseGuess);
                setState(() {});
                _wordCountdown();
              },
              child: Container(
                width: 80,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(),
                ),
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'Press',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class ScreenDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: 280,
      decoration: BoxDecoration(
        color: backgroundHighlightColor,
        border: Border.all(),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class KeyboardListener extends StatefulWidget {
  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();

  @override
  initState() {
    super.initState();
  }

  handleKey(RawKeyEventDataAndroid key) {
    print('KeyCode: ${key.keyCode}, CodePoint: ${key.codePoint}, '
        'Flags: ${key.flags}, MetaState: ${key.metaState}, '
        'ScanCode: ${key.scanCode}');
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _textNode,
      onKey: (key) => handleKey(key.data),
      child: TextField(
        controller: _controller,
        focusNode: _textNode,
      ),
    );
  }
}

class NewTag extends StatelessWidget {
  final double left;
  final double top;

  NewTag({this.left = 10, this.top = 5});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          //color: Color.fromRGBO(255, 105, 180, 1),
          color: Color.fromRGBO(255, 255, 255, 0.85),
        ),
        child: Shimmer.fromColors(
          period: Duration(seconds: 3),
          baseColor: Colors.black,
          highlightColor: Colors.greenAccent,
          child: Center(
              child: Text(
            'new!',
            style: TextStyle(fontSize: 14, color: Colors.red),
          )),
        ),
      ),
      left: left,
      top: top,
    );
  }
}
