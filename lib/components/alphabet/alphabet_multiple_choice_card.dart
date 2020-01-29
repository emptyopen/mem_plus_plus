import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class AlphabetMultipleChoiceCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function(BuildContext, bool) callback;

  AlphabetMultipleChoiceCard({this.alphabetData, this.callback});

  @override
  _AlphabetMultipleChoiceCardState createState() =>
      _AlphabetMultipleChoiceCardState();
}

class _AlphabetMultipleChoiceCardState
    extends State<AlphabetMultipleChoiceCard> {
  bool done = false;
  int attempts = 0;
  AlphabetData fakeAlphabetChoice1;
  AlphabetData fakeAlphabetChoice2;
  AlphabetData fakeAlphabetChoice3;
  List<AlphabetData> alphabetDataList;
  List<AlphabetData> shuffledOptions = [
    AlphabetData('0', 'ball', 0),
    AlphabetData('0', 'ball', 0),
    AlphabetData('0', 'ball', 0),
    AlphabetData('0', 'ball', 0),
  ];
  String alphabetKey = 'Alphabet';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alphabetDataList =
          (json.decode(prefs.getString(alphabetKey)) as List)
              .map((i) => AlphabetData.fromJson(i))
              .toList();
      // loop until you find 3 random different numbers
      List<String> notAllowed = [widget.alphabetData.digits];
      while (fakeAlphabetChoice1 == null) {
        AlphabetData candidate =
            alphabetDataList[Random().nextInt(alphabetDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeAlphabetChoice1 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeAlphabetChoice2 == null) {
        AlphabetData candidate =
            alphabetDataList[Random().nextInt(alphabetDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeAlphabetChoice2 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      while (fakeAlphabetChoice3 == null) {
        AlphabetData candidate =
            alphabetDataList[Random().nextInt(alphabetDataList.length)];
        if (!notAllowed.contains(candidate.digits)) {
          fakeAlphabetChoice3 = candidate;
          notAllowed.add(candidate.digits);
        }
      }
      shuffledOptions = [
        widget.alphabetData,
        fakeAlphabetChoice1,
        fakeAlphabetChoice2,
        fakeAlphabetChoice3
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
    if (shuffledOptions[index].digits == widget.alphabetData.digits) {
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
          'Incorrect! ${widget.alphabetData.digits}: ${widget.alphabetData.object}',
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
                    widget.alphabetData.digits,
                    style: TextStyle(fontSize: 30),
                  )),
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
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            shuffledOptions[0].object,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(1),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            shuffledOptions[1].object,
                            style: TextStyle(fontSize: 20),
                          ),
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
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            shuffledOptions[2].object,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: FlatButton(
                        onPressed: () => checkResult(3),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: Text(
                            shuffledOptions[3].object,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }
}
