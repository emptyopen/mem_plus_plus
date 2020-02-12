import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';

class PAOMultipleChoiceCard extends StatefulWidget {
  final PAOData paoData;
  final Function(BuildContext, bool) callback;

  PAOMultipleChoiceCard({this.paoData, this.callback});

  @override
  _PAOMultipleChoiceCardState createState() => _PAOMultipleChoiceCardState();
}

class _PAOMultipleChoiceCardState extends State<PAOMultipleChoiceCard> {
  bool done = false;
  int attempts = 0;
  PAOData fakePAOChoice1;
  PAOData fakePAOChoice2;
  PAOData fakePAOChoice3;
  List<PAOData> paoDataList;
  List<PAOData> shuffledOptions = [
    PAOData(0, '0', 'nobody', 'does nothing', 'nothing', 0),
    PAOData(1, '0', 'nobody', 'does nothing', 'nothing', 0),
    PAOData(2, '0', 'nobody', 'does nothing', 'nothing', 0),
    PAOData(3, '0', 'nobody', 'does nothing', 'nothing', 0),
  ];
  String paoKey = 'PAO';
  String mapChoice;
  var mapChoices = [
    'digitToPersonActionObject',
    'personActionObjectToDigit',
  ];
  var paoChoices = [
    'person',
    'action',
    'object',
  ];
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  randomPAOChoice(paoEntry) {
    var paoChoice = paoChoices[Random().nextInt(paoChoices.length)];
    switch (paoChoice) {
      case 'person':
        return paoEntry.person;
        break;
      case 'action':
        return paoEntry.action;
        break;
      default:
        return paoEntry.object;
        break;
    }
  }

  Future<Null> getSharedPrefs() async {
    paoDataList = await prefs.getSharedPrefs(paoKey);

    mapChoice = mapChoices[Random().nextInt(mapChoices.length)];

    if (mapChoice == 'digitToPersonActionObject') {
      List<int> notAllowed = [widget.paoData.index];
      while (fakePAOChoice1 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakePAOChoice1 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakePAOChoice2 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakePAOChoice2 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakePAOChoice3 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakePAOChoice3 = candidate;
          notAllowed.add(candidate.index);
        }
      }
    } else {
      List<String> notAllowed = [widget.paoData.digits];
      while (fakePAOChoice1 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakePAOChoice1 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakePAOChoice2 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakePAOChoice2 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakePAOChoice3 == null) {
        PAOData candidate = paoDataList[Random().nextInt(paoDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakePAOChoice3 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
    }

    setState(() {
      shuffledOptions = [
        widget.paoData,
        fakePAOChoice1,
        fakePAOChoice2,
        fakePAOChoice3
      ];
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

  void checkResult(int index) {
    if (shuffledOptions[index].digits == widget.paoData.digits) {
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
        widget.callback(context, true);
        done = true;
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect! ${widget.paoData.digits}: ${widget.paoData.object}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
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
                    mapChoice == 'digitToPersonActionObject' ? widget.paoData.digits : randomPAOChoice(widget.paoData),
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
                          splashColor: Colors.pink[100],
                          color: Theme.of(context).primaryColor,
                          text: mapChoice == 'digitToPersonActionObject' ? randomPAOChoice(shuffledOptions[0]) : shuffledOptions[0].digits,
                          fontSize: 14,
                          onPressed: () => checkResult(0),
                        ),
                        top: 5,
                        left: 5,
                      ),
                      Positioned(
                        child: BasicFlatButton(
                          splashColor: Colors.pink[100],
                          color: Theme.of(context).primaryColor,
                          text: mapChoice == 'digitToPersonActionObject' ? randomPAOChoice(shuffledOptions[1]) : shuffledOptions[1].digits,
                          fontSize: 14,
                          onPressed: () => checkResult(1),
                        ),
                        top: 5,
                        right: 5,
                      ),
                      Positioned(
                        child: BasicFlatButton(
                          splashColor: Colors.pink[100],
                          color: Theme.of(context).primaryColor,
                          text: mapChoice == 'digitToPersonActionObject' ? randomPAOChoice(shuffledOptions[2]) : shuffledOptions[2].digits,
                          fontSize: 14,
                          onPressed: () => checkResult(2),
                        ),
                        bottom: 5,
                        left: 5,
                      ),
                      Positioned(
                        child: BasicFlatButton(
                          splashColor: Colors.pink[100],
                          color: Theme.of(context).primaryColor,
                          text: mapChoice == 'digitToPersonActionObject' ? randomPAOChoice(shuffledOptions[3]) : shuffledOptions[3].digits,
                          fontSize: 14,
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
