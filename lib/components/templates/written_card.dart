import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:edit_distance/edit_distance.dart';

class WrittenCard extends StatefulWidget {
  final Key key;
  final String systemKey;
  final dynamic entry;
  final Function(bool) callback;
  final Function() nextActivityCallback;
  final Color color;
  final Color lighterColor;
  final bool isLastCard;
  final GlobalKey<ScaffoldState> globalKey;
  final List results;

  WrittenCard({
    this.key,
    this.systemKey,
    this.entry,
    this.callback,
    this.nextActivityCallback,
    this.color,
    this.lighterColor,
    this.globalKey,
    this.isLastCard = false,
    this.results,
  });

  @override
  _WrittenCardState createState() => _WrittenCardState();
}

class _WrittenCardState extends State<WrittenCard> {
  bool isErrorMessage = false;
  //static GlobalKey<FormState> _k1 = new GlobalKey<FormState>();
  final textController = TextEditingController();
  final prefs = PrefsUpdater();
  int attempts = 0;
  static var _formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
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
    Levenshtein d = new Levenshtein();
    String answer = widget.entry.object.toLowerCase();
    String guess = textController.text.toLowerCase().trim();
    if (textController.text == '') {
      setState(() {
        isErrorMessage = true;
      });
      return;
    }
    if (d.distance(answer, guess) == 0) {
      showSnackBar(
          scaffoldState: Scaffold.of(context),
          snackBarText: 'Correct!',
          backgroundColor: colorCorrect,
          durationSeconds: 1);
      widget.callback(true);
    } else if (d.distance(answer, guess) == 1) {
      showSnackBar(
          scaffoldState: Scaffold.of(context),
          snackBarText: 'Close enough!',
          backgroundColor: colorCorrect,
          durationSeconds: 1);
      widget.callback(true);
    } else {
      showSnackBar(
          scaffoldState: Scaffold.of(context),
          snackBarText: 'Incorrect!   ${widget.entry.letter} = ${widget.entry.object}',
          backgroundColor: colorIncorrect,
          durationSeconds: 2);
      widget.callback(false);
    }
    if (debugModeEnabled && attempts >= 2) {
      showSnackBar(
          scaffoldState: widget.globalKey.currentState,
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
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Congratulations, you aced it! Next up is a timed test!',
            backgroundColor: widget.color,
            durationSeconds: 3);
        widget.nextActivityCallback();
        Navigator.pop(context);
      } else {
        showSnackBar(
            scaffoldState: widget.globalKey.currentState,
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
    print('rebuilding');
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
                    style: TextStyle(
                        fontSize: 22, color: backgroundHighlightColor),
                    controller: textController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor)),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isErrorMessage ? Text('Can\'t be blank!', style: TextStyle(color: Colors.red, fontSize: 14),) : SizedBox(height: 14,),
                SizedBox(
                  height: 10,
                ),
                BasicFlatButton(
                  color: Colors.blue[200],
                  splashColor: Colors.blue[300],
                  text: 'Submit',
                  fontSize: 16,
                  onPressed: () => checkResult(),
                ),
              ],
            ));
  }
}
