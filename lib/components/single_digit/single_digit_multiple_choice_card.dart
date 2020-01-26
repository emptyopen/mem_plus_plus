import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class SingleDigitMultipleChoiceCard extends StatefulWidget {
  final SingleDigitData singleDigitData;

  SingleDigitMultipleChoiceCard({this.singleDigitData});

  @override
  _SingleDigitMultipleChoiceCardState createState() =>
      _SingleDigitMultipleChoiceCardState();
}

class _SingleDigitMultipleChoiceCardState
    extends State<SingleDigitMultipleChoiceCard> {
  bool done = false;
  int score = 0;
  int attempts = 0;
  SingleDigitData fakeSingleDigitChoice1;
  SingleDigitData fakeSingleDigitChoice2;
  SingleDigitData fakeSingleDigitChoice3;
  List<SingleDigitData> singleDigitDataList;
  List<SingleDigitData> shuffledOptions = [
    SingleDigitData('0', 'ball', 0),
    SingleDigitData('0', 'ball', 0),
    SingleDigitData('0', 'ball', 0),
    SingleDigitData('0', 'ball', 0),
  ];
  String singleDigitKey = 'singleDigit';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('setting to 0');
      singleDigitDataList = (json.decode(prefs.getString(singleDigitKey)) as List)
        .map((i) => SingleDigitData.fromJson(i))
        .toList();
      // loop until you find 3 random different numbers
      List<String> notAllowed = [widget.singleDigitData.digits];
      while (fakeSingleDigitChoice1 == null) {
        SingleDigitData candidate = singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice1 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeSingleDigitChoice2 == null) {
        SingleDigitData candidate = singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice2 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeSingleDigitChoice3 == null) {
        SingleDigitData candidate = singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice3 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      shuffledOptions = [widget.singleDigitData, fakeSingleDigitChoice1, fakeSingleDigitChoice2, fakeSingleDigitChoice3];
      shuffledOptions = shuffle(shuffledOptions);
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

  void checkResult (int index) {
    if (shuffledOptions[index].digits == widget.singleDigitData.digits) {
      final snackBar = SnackBar(
        content: Text(
          'Correct!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        print(score);
        score = score + 1;
        print(score);
        done = true;
        if (score == 10) {
          final snackBar = SnackBar(
            content: Text(
              'You aced it! Head to the main menu to see what you\'ve unlocked!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.black,
          );
          Scaffold.of(context).showSnackBar(snackBar);
        }
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect! ${widget.singleDigitData.digits}: ${widget.singleDigitData.object}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        done = true;
      });
    }
    attempts += 1;
    if (attempts == 10) {
      final snackBar = SnackBar(
        content: Text(
          'Try again! You got this. Score: $score/10',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // TODO: add action here for quick redo
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Container()
        : Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(child: Text(widget.singleDigitData.digits,
                  style: TextStyle(fontSize: 30),)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(0),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Text(shuffledOptions[0].object,
                          style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(1),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Text(shuffledOptions[1].object,
                            style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(2),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Text(shuffledOptions[2].object,
                            style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(3),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.all(Radius.circular(5))),
                          child: Text(shuffledOptions[3].object,
                            style: TextStyle(fontSize: 20),),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
