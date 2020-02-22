import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class SingleDigitMultipleChoiceCard extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(BuildContext, bool) callback;

  SingleDigitMultipleChoiceCard({this.singleDigitData, this.callback});

  @override
  _SingleDigitMultipleChoiceCardState createState() =>
      _SingleDigitMultipleChoiceCardState();
}

class _SingleDigitMultipleChoiceCardState
    extends State<SingleDigitMultipleChoiceCard> {
  bool done = false;
  int attempts = 0;
  SingleDigitData fakeSingleDigitChoice1;
  SingleDigitData fakeSingleDigitChoice2;
  SingleDigitData fakeSingleDigitChoice3;
  List<SingleDigitData> singleDigitDataList;
  List<SingleDigitData> shuffledOptions = [
    SingleDigitData(0, '0', 'nothing', 0),
    SingleDigitData(1, '0', 'nothing', 0),
    SingleDigitData(2, '0', 'nothing', 0),
    SingleDigitData(3, '0', 'nothing', 0),
  ];
  var prefs = PrefsUpdater();
  int isDigitToObject; // 0 == digitToObject, 1 == objectToDigit

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    singleDigitDataList = await prefs.getSharedPrefs(singleDigitKey);

    // randomly choose either digit -> object or object -> digit
    isDigitToObject = Random().nextInt(2);
    if (isDigitToObject == 0) {
      // loop until you find 3 random different objects
      List<String> notAllowed = [widget.singleDigitData.object];
      while (fakeSingleDigitChoice1 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeSingleDigitChoice1 = candidate;
          notAllowed.add(candidate.object);
        }
      }
      while (fakeSingleDigitChoice2 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeSingleDigitChoice2 = candidate;
          notAllowed.add(candidate.object);
        }
      }
      while (fakeSingleDigitChoice3 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.object)) {
          fakeSingleDigitChoice3 = candidate;
          notAllowed.add(candidate.object);
        }
      }
    } else {
      // loop until you find 3 random different digits
      List<String> notAllowed = [widget.singleDigitData.digits];
      while (fakeSingleDigitChoice1 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice1 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeSingleDigitChoice2 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice2 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeSingleDigitChoice3 == null) {
        SingleDigitData candidate =
            singleDigitDataList[Random().nextInt(singleDigitDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeSingleDigitChoice3 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
    }

    setState(() {
      shuffledOptions = [
        widget.singleDigitData,
        fakeSingleDigitChoice1,
        fakeSingleDigitChoice2,
        fakeSingleDigitChoice3
      ];
      shuffledOptions = shuffle(shuffledOptions);
    });
  }

  void checkResult(int index) {
    if (shuffledOptions[index].digits == widget.singleDigitData.digits) {
      showSnackBar(
          scaffoldState: Scaffold.of(context),
          snackBarText: 'Correct!',
          backgroundColor: Colors.green[200],
          durationSeconds: 1);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else {
      showSnackBar(
          scaffoldState: Scaffold.of(context),
          snackBarText:
              'Incorrect!   ${widget.singleDigitData.digits} = ${widget.singleDigitData.object}',
          backgroundColor: Colors.red[200],
          durationSeconds: 3);
      setState(() {
        widget.callback(context, false);
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return done
        ? Container()
        : Container(
              height: screenHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(
                    isDigitToObject == 0 ? 'Digit:' : 'Object:',
                    style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    isDigitToObject == 0
                        ? widget.singleDigitData.digits
                        : widget.singleDigitData.object,
                    style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                BasicFlatButton(
                  splashColor: Colors.amber[100],
                  color: colorSingleDigitStandard,
                  text: isDigitToObject == 0
                      ? shuffledOptions[0].object
                      : shuffledOptions[0].digits,
                  fontSize: 30,
                  padding: 5,
                  onPressed: () => checkResult(0),
                ),
                SizedBox(
                  height: 20,
                ),
                BasicFlatButton(
                  splashColor: Colors.amber[100],
                  color: colorSingleDigitStandard,
                  text: isDigitToObject == 0
                      ? shuffledOptions[1].object
                      : shuffledOptions[1].digits,
                  fontSize: 30,
                  padding: 5,
                  onPressed: () => checkResult(1),
                ),
                SizedBox(
                  height: 20,
                ),
                BasicFlatButton(
                  splashColor: Colors.amber[100],
                  color: colorSingleDigitStandard,
                  text: isDigitToObject == 0
                      ? shuffledOptions[2].object
                      : shuffledOptions[2].digits,
                  fontSize: 30,
                  padding: 5,
                  onPressed: () => checkResult(2),
                ),
                SizedBox(
                  height: 20,
                ),
                BasicFlatButton(
                  splashColor: Colors.amber[100],
                  color: colorSingleDigitStandard,
                  text: isDigitToObject == 0
                      ? shuffledOptions[3].object
                      : shuffledOptions[3].digits,
                  fontSize: 30,
                  padding: 5,
                  onPressed: () => checkResult(3),
                ),
                SizedBox(height: 60,)
              ],
            ),);
  }
}
