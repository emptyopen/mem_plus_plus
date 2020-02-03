import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';

class SingleDigitMultipleChoiceCard extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(BuildContext, bool) callback;

  SingleDigitMultipleChoiceCard({this.singleDigitData, this.callback});

  @override
  _SingleDigitMultipleChoiceCardState createState() => _SingleDigitMultipleChoiceCardState();
}

class _SingleDigitMultipleChoiceCardState extends State<SingleDigitMultipleChoiceCard> {
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
  String singleDigitKey = 'SingleDigit';
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    singleDigitDataList = await prefs.getSharedPrefs(singleDigitKey);
    setState(() {
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
      showSnackBar(context, 'Correct!', Colors.black, Colors.green[200], 1);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else {
      showSnackBar(context, 'Incorrect!', Colors.black, Colors.red[200], 2);
      setState(() {
        widget.callback(context, false);
        done = true;
      });
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
            child: Center(
              child: Text(
                widget.singleDigitData.digits,
                style: TextStyle(fontSize: 30),
              )),
          ),
          Container(
            width: 350,
            height: 100,
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: BasicFlatButton(
                    splashColor: Colors.amber[100],
                    color: Theme.of(context).primaryColor,
                    text: shuffledOptions[0].object,
                    fontSize: 18,
                    onPressed: () => checkResult(0),
                  ),
                  top: 5,
                  left: 5,
                ),
                Positioned(
                  child: BasicFlatButton(
                    splashColor: Colors.amber[100],
                    color: Theme.of(context).primaryColor,
                    text: shuffledOptions[1].object,
                    fontSize: 18,
                    onPressed: () => checkResult(1),
                  ),
                  top: 5,
                  right: 5,
                ),
                Positioned(
                  child: BasicFlatButton(
                    splashColor: Colors.amber[100],
                    color: Theme.of(context).primaryColor,
                    text: shuffledOptions[2].object,
                    fontSize: 18,
                    onPressed: () => checkResult(2),
                  ),
                  bottom: 5,
                  left: 5,
                ),
                Positioned(
                  child: BasicFlatButton(
                    splashColor: Colors.amber[100],
                    color: Theme.of(context).primaryColor,
                    text: shuffledOptions[3].object,
                    fontSize: 18,
                    onPressed: () => checkResult(3),
                  ),
                  bottom: 5,
                  right: 5,
                ),
              ],
            ),
          ),
        ],
      ));
  }
}