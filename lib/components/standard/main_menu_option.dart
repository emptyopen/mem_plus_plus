import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:shimmer/shimmer.dart';

// TODO: separate isbutton as separate widget
class MainMenuOption extends StatelessWidget {
  final Activity? activity;
  final IconData? icon;
  final String text;
  final Color color;
  final Color? splashColor;
  final Widget? route;
  final Function? callback;
  final bool isCustomTest;
  final bool isButton;
  final function;
  final Color textColor;
  final PrefsUpdater prefs = PrefsUpdater();

  MainMenuOption({
    Key? key,
    required this.text,
    required this.color,
    this.activity,
    this.icon,
    this.splashColor,
    this.route,
    this.callback,
    this.isCustomTest = false,
    this.isButton = false,
    this.textColor = Colors.black,
    this.function,
  });

  String generateTimeRemaining() {
    return durationToString(
        activity!.visibleAfterTime.difference(DateTime.now()));
  }

  String getActivityName() {
    return text;
  }

  cancelActivity() async {
    print('canceling ${activity!.name}');
    switch (activity!.name) {
      case singleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(singleDigitTimedTestKey, 'review');
        prefs.updateActivityVisible(singleDigitTimedTestKey, false);
        prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
        if (!prefs.getBool(singleDigitTimedTestCompleteKey)) {
          prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
        }
        break;
      case faceTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(faceTimedTestKey, 'review');
        prefs.updateActivityVisible(faceTimedTestKey, false);
        prefs.updateActivityVisible(faceTimedTestPrepKey, true);
        if (!prefs.getBool(faceTimedTestCompleteKey)) {
          prefs.updateActivityState(faceTimedTestPrepKey, 'todo');
        }
        break;
      case planetTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(planetTimedTestKey, 'review');
        prefs.updateActivityVisible(planetTimedTestKey, false);
        prefs.updateActivityVisible(planetTimedTestPrepKey, true);
        if (!prefs.getBool(planetTimedTestCompleteKey)) {
          prefs.updateActivityState(planetTimedTestPrepKey, 'todo');
        }
        break;
      case alphabetTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(alphabetTimedTestKey, 'review');
        prefs.updateActivityVisible(alphabetTimedTestKey, false);
        prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
        if (!prefs.getBool(alphabetTimedTestCompleteKey)) {
          prefs.updateActivityState(alphabetTimedTestPrepKey, 'todo');
        }
        break;
      case phoneticAlphabetTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(phoneticAlphabetTimedTestKey, 'review');
        prefs.updateActivityVisible(phoneticAlphabetTimedTestKey, false);
        prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
        if (!prefs.getBool(phoneticAlphabetTimedTestCompleteKey)) {
          prefs.updateActivityState(phoneticAlphabetTimedTestPrepKey, 'todo');
        }
        break;
      case airportTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(airportTimedTestKey, 'review');
        prefs.updateActivityVisible(airportTimedTestKey, false);
        prefs.updateActivityVisible(airportTimedTestPrepKey, true);
        if (!prefs.getBool(airportTimedTestCompleteKey)) {
          prefs.updateActivityState(airportTimedTestPrepKey, 'todo');
        }
        break;
      case paoTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(paoTimedTestKey, 'review');
        prefs.updateActivityVisible(paoTimedTestKey, false);
        prefs.updateActivityVisible(paoTimedTestPrepKey, true);
        if (!prefs.getBool(paoTimedTestCompleteKey)) {
          prefs.updateActivityState(paoTimedTestPrepKey, 'todo');
        }
        break;
      case face2TimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(face2TimedTestKey, 'review');
        prefs.updateActivityVisible(face2TimedTestKey, false);
        prefs.updateActivityVisible(face2TimedTestPrepKey, true);
        if (!prefs.getBool(face2TimedTestCompleteKey)) {
          prefs.updateActivityState(face2TimedTestPrepKey, 'todo');
        }
        break;
      case piTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(piTimedTestKey, 'review');
        prefs.updateActivityVisible(piTimedTestKey, false);
        prefs.updateActivityVisible(piTimedTestPrepKey, true);
        if (!prefs.getBool(piTimedTestCompleteKey)) {
          prefs.updateActivityState(piTimedTestPrepKey, 'todo');
        }
        break;
      case deckTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(deckTimedTestKey, 'review');
        prefs.updateActivityVisible(deckTimedTestKey, false);
        prefs.updateActivityVisible(deckTimedTestPrepKey, true);
        if (!prefs.getBool(deckTimedTestCompleteKey)) {
          prefs.updateActivityState(deckTimedTestPrepKey, 'todo');
        }
        break;
      case tripleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(tripleDigitTimedTestKey, 'review');
        prefs.updateActivityVisible(tripleDigitTimedTestKey, false);
        prefs.updateActivityVisible(tripleDigitTimedTestPrepKey, true);
        if (!prefs.getBool(tripleDigitTimedTestCompleteKey)) {
          prefs.updateActivityState(tripleDigitTimedTestPrepKey, 'todo');
        }
        break;
    }
    callback!();
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
                child: ElevatedButton(
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(100),
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  splashColor!,
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: GestureDetector(
              onTap: () async {
                if (activity!.visibleAfterTime.compareTo(DateTime.now()) > 0) {
                  return null;
                }
                HapticFeedback.lightImpact();
                // TODO (2024): hide snackbar
                prefs.updateActivityFirstView(activity!.name, false);
                callback!();
                slideTransition(context, route!);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(icon),
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
                            style: TextStyle(fontSize: 20),
                            maxLines: 1,
                            maxFontSize: 24,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          activity!.firstView
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
          activity!.visibleAfterTime.compareTo(DateTime.now()) < 0
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
                                '${getActivityName().contains('System - Timed Test') ? getActivityName().replaceAll('System - Timed Test', 'test') : getActivityName()} in ${generateTimeRemaining()}',
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
                                  confirmColor: splashColor!,
                                ),
                                textColor: Colors.white,
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                fontSize: 13,
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
