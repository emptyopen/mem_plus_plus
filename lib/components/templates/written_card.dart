import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/levenshtein.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';

class WrittenCard extends StatefulWidget {
  final Key key;
  final String systemKey;
  final dynamic entry;
  final Function callback;
  final Function nextActivityCallback;
  final Color color;
  final Color lighterColor;
  final bool isLastCard;
  final List results;

  WrittenCard({
    required this.key,
    required this.systemKey,
    required this.entry,
    required this.callback,
    required this.nextActivityCallback,
    required this.color,
    required this.lighterColor,
    this.isLastCard = false,
    required this.results,
  });

  @override
  _WrittenCardState createState() => _WrittenCardState();
}

class _WrittenCardState extends State<WrittenCard> {
  bool isErrorMessage = false;
  //static GlobalKey<FormState> _k1 = new GlobalKey<FormState>();
  final textController = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();
  int attempts = 0;
  static var _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    setState(() {
      attempts = 0;
      widget.results.forEach((attempt) {
        if (attempt != null) {
          attempts += 1;
        }
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void checkResult() {
    String answer = widget.entry.object.toLowerCase();
    String guess = textController.text.toLowerCase().trim();
    if (textController.text == '') {
      setState(() {
        isErrorMessage = true;
      });
      return;
    }
    if (levenshtein(answer, guess) == 0) {
      showSnackBar(
          context: context,
          snackBarText: 'Correct!',
          backgroundColor: colorCorrect,
          durationSeconds: 1);
      widget.callback(true);
    } else if (levenshtein(answer, guess) == 1 && answer.length > 3) {
      showSnackBar(
          context: context,
          snackBarText: 'Close enough!',
          backgroundColor: colorCorrect,
          durationSeconds: 1);
      widget.callback(true);
    } else {
      showSnackBar(
          context: context,
          snackBarText:
              'Incorrect!   ${widget.entry.letter} = ${widget.entry.object}',
          backgroundColor: colorIncorrect,
          durationSeconds: 2);
      widget.callback(false);
    }
    if (debugModeEnabled && attempts >= 2) {
      showSnackBar(
          context: context,
          snackBarText:
              'Debug: Congratulations, you aced it! Next up is a timed test!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      widget.nextActivityCallback();
      Navigator.pop(context);
    }
    if (widget.isLastCard) {
      int score = 0;
      widget.results.forEach((v) {
        if (v) {
          score += 1;
        }
      });
      if (score == widget.results.length) {
        showSnackBar(
            context: context,
            snackBarText:
                'Congratulations, you aced it! Next up is a timed test!',
            backgroundColor: widget.color,
            durationSeconds: 3);
        widget.nextActivityCallback();
        Navigator.pop(context);
      } else {
        showSnackBar(
            context: context,
            snackBarText:
                'Try again! You got this. Score: $score/${widget.results.length}',
            backgroundColor: colorIncorrect,
            durationSeconds: 3);
        Navigator.pop(context);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: Center(
                  child: Text(
                widget.entry.letter,
                style: TextStyle(
                    fontSize: 30, color: backgroundSemiHighlightColor),
              )),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: screenWidth * 0.8,
              child: TextField(
                key: _formKey,
                //key: _k1,
                style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
                controller: textController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: backgroundHighlightColor)),
                  contentPadding: EdgeInsets.all(5),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            isErrorMessage
                ? Text(
                    'Can\'t be blank!',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  )
                : SizedBox(
                    height: 14,
                  ),
            SizedBox(
              height: 10,
            ),
            BasicFlatButton(
              color: Colors.blue[200]!,
              text: 'Submit',
              fontSize: 16,
              onPressed: () => checkResult(),
            ),
          ],
        ));
  }
}
