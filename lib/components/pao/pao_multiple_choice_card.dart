import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
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

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paoDataList = (json.decode(prefs.getString(paoKey)) as List)
          .map((i) => PAOData.fromJson(i))
          .toList();
      // loop until you find 3 random different numbers
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
                    widget.paoData.digits,
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
                          text: shuffledOptions[0].object,
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
                          text: shuffledOptions[1].object,
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
                          text: shuffledOptions[2].object,
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
                          text: shuffledOptions[3].object,
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
