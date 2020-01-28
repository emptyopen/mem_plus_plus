import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pao_data.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';

class PAOFlashCard extends StatefulWidget {
  final PAOData paoData;

  PAOFlashCard({this.paoData});

  @override
  _PAOFlashCardState createState() => _PAOFlashCardState();
}

class _PAOFlashCardState extends State<PAOFlashCard> {
  bool done = false;
  bool guessed = true;
  String paoKey = 'pao';
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
                  widget.paoData.digits,
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
                            widget.paoData.person,
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            '${widget.paoData.action} • ${widget.paoData.object}',
                            style: TextStyle(fontSize: 22),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () async {
                                    // TODO: add message on the bottom for information regarding familiarity
                                    print(
                                        'increasing familiarity for ${widget.paoData.digits}');
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var paoData =
                                        (json.decode(prefs.getString(paoKey))
                                                as List)
                                            .map((i) => PAOData.fromJson(i))
                                            .toList();
                                    int currIndex =
                                        int.parse(widget.paoData.digits);
                                    PAOData updatedPAOEntry =
                                        paoData[currIndex];
                                    if (updatedPAOEntry.familiarity + 10 <=
                                        100) {
                                      updatedPAOEntry.familiarity += 10;
                                    } else {
                                      updatedPAOEntry.familiarity = 100;
                                    }
                                    paoData[currIndex] = updatedPAOEntry;
                                    prefs.setString(
                                        paoKey, json.encode(paoData));
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
                                    print(
                                        'increasing familiarity for ${widget.paoData.digits}');
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var paoData =
                                        (json.decode(prefs.getString(paoKey))
                                                as List)
                                            .map((i) => PAOData.fromJson(i))
                                            .toList();
                                    int currIndex =
                                        int.parse(widget.paoData.digits);
                                    PAOData updatedPAOEntry =
                                        paoData[currIndex];
                                    if (updatedPAOEntry.familiarity - 5 >= 0) {
                                      updatedPAOEntry.familiarity -= 5;
                                    } else {
                                      updatedPAOEntry.familiarity = 0;
                                    }
                                    paoData[currIndex] = updatedPAOEntry;
                                    prefs.setString(
                                        paoKey, json.encode(paoData));
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
