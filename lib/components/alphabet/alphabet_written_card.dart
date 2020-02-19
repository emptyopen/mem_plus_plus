import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:edit_distance/edit_distance.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class AlphabetWrittenCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function(BuildContext, bool) callback;

  AlphabetWrittenCard({this.alphabetData, this.callback});

  @override
  _AlphabetWrittenCardState createState() => _AlphabetWrittenCardState();
}

class _AlphabetWrittenCardState extends State<AlphabetWrittenCard> {
  bool done = false;
  List<AlphabetData> alphabetDataList;
  String alphabetKey = 'Alphabet';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alphabetDataList = (json.decode(prefs.getString(alphabetKey)) as List)
          .map((i) => AlphabetData.fromJson(i))
          .toList();
      alphabetDataList = shuffle(alphabetDataList);
    });
  }

  List shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  void checkResult() {
    Levenshtein d = new Levenshtein();
    String answer = widget.alphabetData.object.toLowerCase();
    String guess = textController.text.toLowerCase().trim();
    if (d.distance(answer, guess) == 0) {
      showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: 'Correct!',
        backgroundColor: colorCorrect,
        durationSeconds: 1);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else if (d.distance(answer, guess) == 1) {
      showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: 'Close enough!',
        backgroundColor: colorCorrect,
        durationSeconds: 1);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else {
      showSnackBar(
        scaffoldState: Scaffold.of(context),
        snackBarText: 'Incorrect! The correct answer is: ${widget.alphabetData.object}',
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
      setState(() {
        widget.callback(context, false);
        done = true;
      });
    }
    textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Container()
        : Container(
              height: 500,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text(
                    widget.alphabetData.letter,
                    style: TextStyle(fontSize: 30, color: backgroundSemiHighlightColor),
                  )),
                ),
                SizedBox(height: 30,),
                Container(
                  width: 250,
                  child: TextField(
                    style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
                      controller: textController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                      )),
                ),
                SizedBox(height: 30,),
                BasicFlatButton(
                  splashColor: Colors.blue[200],
                  text: 'Submit',
                  fontSize: 16,
                  onPressed: () => checkResult(),
                ),
              ],
            ));
  }
}
