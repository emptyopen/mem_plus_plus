import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'standard.dart';
import 'dart:math';

class SingleDigitFlashCard extends StatefulWidget {
  final SingleDigitData singleDigitData;

  SingleDigitFlashCard({this.singleDigitData});

  @override
  _SingleDigitFlashCardState createState() => _SingleDigitFlashCardState();
}

class _SingleDigitFlashCardState extends State<SingleDigitFlashCard> {
  bool done = false;
  bool guessed = true;
  String singleDigitKey = 'singleDigit';
  SharedPreferences sharedPreferences;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.singleDigitData.digits,
                  style: TextStyle(fontSize: 34),
                ),
                guessed
                    ? FlatButton(
                        onPressed: () {
                          setState(() {
                            guessed = false;
                          });
                        },
                        child: BasicContainer(
                          text: 'Reveal',
                          color: Colors.amber[50],
                          fontSize: 18,
                        ))
                    : Container(),
                guessed
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Text(
                            widget.singleDigitData.object,
                            style: TextStyle(fontSize: 24),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    // TODO: add message on the bottom for information regarding familiarity
                                    print(
                                        'increasing familiarity for ${widget.singleDigitData.digits}');
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var singleDigitData = (json.decode(
                                                prefs.getString(singleDigitKey))
                                            as List)
                                        .map((i) => SingleDigitData.fromJson(i))
                                        .toList();
                                    int currIndex = int.parse(
                                        widget.singleDigitData.digits);
                                    SingleDigitData updatedSingleDigitEntry =
                                        singleDigitData[currIndex];
                                    if (updatedSingleDigitEntry.familiarity + 10 <= 100) {
                                      updatedSingleDigitEntry.familiarity += 10;
                                    } else {
                                      updatedSingleDigitEntry.familiarity = 100;
                                    }
                                    singleDigitData[currIndex] =
                                        updatedSingleDigitEntry;
                                    prefs.setString(singleDigitKey,
                                        json.encode(singleDigitData));
                                    setState(() {
                                      done = true;
                                    });
                                  },
                                  child: BasicContainer(
                                    text: 'Got it',
                                    color: Colors.green[50],
                                    fontSize: 18,
                                  )),
                              FlatButton(
                                  onPressed: () async {
                                    // TODO: add message on the bottom for information regarding familiarity
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    print(
                                      'decreasing familiarity for ${widget.singleDigitData.digits}');
                                    var singleDigitData = (json.decode(
                                                prefs.getString(singleDigitKey))
                                            as List)
                                        .map((i) => SingleDigitData.fromJson(i))
                                        .toList();
                                    int currIndex = int.parse(
                                        widget.singleDigitData.digits);
                                    SingleDigitData updatedSingleDigitEntry =
                                        singleDigitData[currIndex];
                                    if (updatedSingleDigitEntry.familiarity - 5 >= 0) {
                                      updatedSingleDigitEntry.familiarity -= 5;
                                    } else {
                                      updatedSingleDigitEntry.familiarity = 0;
                                    }
                                    singleDigitData[currIndex] =
                                        updatedSingleDigitEntry;
                                    prefs.setString(singleDigitKey,
                                        json.encode(singleDigitData));
                                    setState(() {
                                      done = true;
                                    });
                                  },
                                  child: BasicContainer(
                                    text: 'Didn\'t got it',
                                    color: Colors.red[50],
                                    fontSize: 18,
                                  ))
                            ],
                          ),
                        ],
                      )
              ],
            ),
          );
  }
}

class SingleDigitView extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(List<SingleDigitData>) callback;

  SingleDigitView({this.singleDigitData, this.callback});

  @override
  _SingleDigitViewState createState() => _SingleDigitViewState();
}

class _SingleDigitViewState extends State<SingleDigitView> {
  final objectTextController = TextEditingController();
  final String singleDigitKey = 'singleDigit';
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
    objectTextController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 350.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Object'),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                textAlign: TextAlign.center,
                controller: objectTextController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: '${widget.singleDigitData.object}'),
              ),
            ),
            Container(
              width: 5,
              height: 10,
            ),
            FlatButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  var singleDigitData =
                      (json.decode(prefs.getString(singleDigitKey)) as List)
                          .map((i) => SingleDigitData.fromJson(i))
                          .toList();
                  int currIndex = int.parse(widget.singleDigitData.digits);
                  SingleDigitData updatedSingleDigitEntry =
                      singleDigitData[currIndex];
                  if (objectTextController.text != '') {
                    updatedSingleDigitEntry.object = objectTextController.text;
                    updatedSingleDigitEntry.familiarity = 0;
                    objectTextController.text = '';
                    print(
                        'will update $currIndex to: ${updatedSingleDigitEntry.object}');
                  }
                  singleDigitData[currIndex] = updatedSingleDigitEntry;
                  prefs.setString(singleDigitKey, json.encode(singleDigitData));
                  widget.callback(singleDigitData);
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ))
          ],
        ),
      ),
    );

    Color getColorFromFamiliarity(int familiarity) {
      if (familiarity < 25) {
        return Colors.red;
      } else if (familiarity < 50) {
        return Colors.orange;
      } else if (familiarity < 75) {
        return Colors.blue;
      } else if (familiarity < 100) {
        return Colors.green;
      }
      return Colors.grey;
    }

    return Center(
      child: Card(
          child: Stack(
        children: <Widget>[
          ListTile(
            leading: Text(
              '${widget.singleDigitData.digits}',
              style: TextStyle(fontSize: 26),
            ),
            title: Text('${widget.singleDigitData.object}',
                style: TextStyle(fontSize: 20)),
            trailing: FlatButton(
                child: Text('Edit', style: TextStyle(color: Colors.cyan)),
                onPressed: () {
                  showDialog(context: context, child: dialog);
                }),
          ),
          Positioned(
            child: Container(
              child: Center(
                child: Text(
                  '${widget.singleDigitData.familiarity}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: getColorFromFamiliarity(widget.singleDigitData.familiarity)
                  ),
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(
                color: Colors.grey,
                    width: 0.5
              )),
              height: 25,
              width: 25,
            ),
            right: 8,
            bottom: 15,
          )
        ],
      )),
    );
  }
}

class SingleDigitData {
  String digits;
  String object;
  int familiarity;

  SingleDigitData(this.digits, this.object, this.familiarity);

  Map<String, dynamic> toJson() => {
        'digits': digits,
        'object': object,
        'familiarity': familiarity,
      };

  factory SingleDigitData.fromJson(Map<String, dynamic> json) {
    return new SingleDigitData(
        json['digits'], json['object'], json['familiarity']);
  }
}

var defaultSingleDigitData = [
  SingleDigitData('0', 'ball', 0),
  SingleDigitData('1', 'stick', 0),
  SingleDigitData('2', 'bird', 0),
  SingleDigitData('3', 'bra', 0),
  SingleDigitData('4', 'sailboat', 0),
  SingleDigitData('5', 'snake', 0),
  SingleDigitData('6', 'golf club', 0),
  SingleDigitData('7', 'boomerang', 0),
  SingleDigitData('8', 'snowman', 0),
  SingleDigitData('9', 'balloon', 0),
];
