import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class MorseTest extends StatefulWidget {
  final Function callback;
  final String morseAnswer;
  final Color color;

  MorseTest(
      {required this.callback, required this.morseAnswer, required this.color});

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
