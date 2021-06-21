import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/components/info_box.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TripleDigitEditScreen extends StatefulWidget {
  final Function callback;

  TripleDigitEditScreen({Key key, this.callback}) : super(key: key);

  @override
  _TripleDigitEditScreenState createState() => _TripleDigitEditScreenState();
}

class _TripleDigitEditScreenState extends State<TripleDigitEditScreen> {
  SharedPreferences sharedPreferences;
  List<TripleDigitData> tripleDigitData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, tripleDigitEditFirstHelpKey, TripleDigitEditScreenHelp());
    if (await prefs.getString(tripleDigitKey) == null) {
      tripleDigitData = [];
      await prefs.setString(tripleDigitKey, json.encode(tripleDigitData));
    } else {
      tripleDigitData = await prefs.getSharedPrefs(tripleDigitKey);
    }
    setState(() {});
  }

  callback(newTripleDigitData) async {
    setState(() {
      tripleDigitData = newTripleDigitData;
    });
    // check if all data is complete
    bool entriesComplete = true;
    for (int i = 0; i < tripleDigitData.length; i++) {
      if (tripleDigitData[i].person == '') {
        entriesComplete = false;
      }
      if (tripleDigitData[i].action == '') {
        entriesComplete = false;
      }
      if (tripleDigitData[i].object == '') {
        entriesComplete = false;
      }
    }

    print('entries complete: $entriesComplete');

    // check if information is filled out for the first time
    bool completedOnce = await prefs.getActivityVisible(tripleDigitPracticeKey);
    if (entriesComplete && !completedOnce) {
      await prefs.updateActivityVisible(tripleDigitPracticeKey, true);
      await prefs.updateActivityState(tripleDigitEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CabinSketch', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorTripleDigitDarker,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getTripleDigitEditCards() {
    List<EditCard> tripleDigitEditCards = [];
    if (tripleDigitData != null) {
      for (int i = 0; i < tripleDigitData.length; i++) {
        EditCard tripleDigitEditCard = EditCard(
          entry: TripleDigitData(
              tripleDigitData[i].index,
              tripleDigitData[i].digits,
              tripleDigitData[i].person,
              tripleDigitData[i].action,
              tripleDigitData[i].object,
              tripleDigitData[i].familiarity),
          callback: callback,
          activityKey: 'TripleDigit',
        );
        tripleDigitEditCards.add(tripleDigitEditCard);
      }
    }
    // this is so hacky but whatever
    if (tripleDigitEditCards.isEmpty) {
      // generate default empty cards
      tripleDigitEditCards = generateDefaultTripleDigitEditCards();
    }
    return tripleDigitEditCards;
  }

  generateDefaultTripleDigitData() {
    List<TripleDigitData> data = [];
    for (int i = 0; i < 1000; i++) {
      data.add(TripleDigitData(i, i.toString().padLeft(3, '0'), '', '', '', 0));
    }
    return data;
  }

  generateDefaultTripleDigitEditCards() {
    List<EditCard> defaultCards = [];
    for (int i = 0; i < 1000; i++) {
      defaultCards.add(EditCard(
        entry: TripleDigitData(i, i.toString().padLeft(3, '0'), '', '', '', 0),
        callback: callback,
        activityKey: 'TripleDigit',
      ));
    }
    return defaultCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Triple Digit: view/edit'),
          backgroundColor: colorTripleDigitStandard,
          actions: <Widget>[
            Shimmer.fromColors(
              period: Duration(seconds: 3),
              baseColor: Colors.black,
              highlightColor: Colors.greenAccent,
              child: IconButton(
                icon: Icon(Icons.arrow_downward),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CSVImporter(callback: callback);
                      }));
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return TripleDigitEditScreenHelp();
                    }));
              },
            ),
          ]),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: backgroundColor),
            child: Center(
                child: ListView(
              children: getTripleDigitEditCards(),
            )),
          ),
          Positioned(
            top: 4,
            right: 50,
            child: InfoBox(
                text: 'Start your Triple Digit journey here!',
                infoKey: 'tripleDigit'),
          ),
        ],
      ),
    );
  }
}

class CSVImporter extends StatefulWidget {
  final Function callback;

  CSVImporter({this.callback});

  @override
  _CSVImporterState createState() => _CSVImporterState();
}

class _CSVImporterState extends State<CSVImporter> {
  final textController = TextEditingController();
  String errorMessage = '';

  updateTripleDigitData(List<TripleDigitData> tripleDigitDataList) async {
    var prefs = PrefsUpdater();
    await prefs.writeSharedPrefs(tripleDigitKey, tripleDigitDataList);
    widget.callback(tripleDigitDataList);
  }

  paddedNum(k) {
    return k.toString().padLeft(3, '0');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                constraints: BoxConstraints.expand(),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '    Here you can upload CSV text to quickly update your TripleDigit values!\n'
                              '    Click below to save a copy of the template! I\'d recommend working primarily in your google doc as '
                              'you develop your TripleDigit system, and come back to paste it here when you\'ve completed it.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BasicFlatButton(
                              text: 'Google docs link!',
                              color: colorTripleDigitDarker,
                              textColor: Colors.white,
                              onPressed: () => launch(
                                  'https://docs.google.com/spreadsheets/d/1cBqw5IfRBUltVsZ2yEfQUb0E1-eA7volnOlJM4X1_dU/edit?usp=sharing'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 350,
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Input below: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            maxLines: 4,
                            onChanged: (s) {
                              errorMessage = '';
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Copy the G12 cell here!',
                              hintStyle: TextStyle(fontSize: 15),
                            ),
                            controller: textController,
                          ),
                          errorMessage != ''
                              ? Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                      errorMessage,
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          color: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        FlatButton(
                          color: colorTripleDigitStandard,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            var csvConverter = CsvToListConverter();
                            String cleanedText = textController.text;
                            cleanedText = cleanedText.trim();
                            if (cleanedText.startsWith("\"")) {
                              cleanedText = cleanedText.substring(1);
                            }
                            if (cleanedText.endsWith("\"")) {
                              cleanedText = cleanedText.substring(
                                  0, cleanedText.length - 1);
                            }
                            var l = csvConverter.convert(cleanedText, eol: '|');
                            bool inputIsValid = true;
                            errorMessage = 'Incorrectly formatted!';
                            if (l.length != 1000) {
                              inputIsValid = false;
                              errorMessage +=
                                  '\n${l.length} lines detected (need 1000).';
                            }
                            bool columnsValid = true;
                            l.asMap().forEach((k, v) {
                              if (v.length != 3) {
                                columnsValid = false;
                              }
                            });
                            if (!columnsValid) {
                              inputIsValid = false;
                              errorMessage +=
                                  '\nFound at least one row with invalid number of columns. Make sure you aren\'t using any extra commas!';
                            }
                            if (inputIsValid) {
                              errorMessage = '';
                              List<TripleDigitData> tripleDigitDataList = [];
                              l.asMap().forEach((k, v) {
                                String person = v[0].toString();
                                String action = v[1].toString();
                                String object = v[2].toString();
                                tripleDigitDataList.add(TripleDigitData(
                                  k,
                                  paddedNum(k),
                                  person,
                                  action,
                                  object,
                                  0,
                                ));
                              });
                              updateTripleDigitData(tripleDigitDataList);
                              Navigator.pop(context);
                            }
                            setState(() {});
                          },
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class TripleDigitEditScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to the 5th system, the Triple Digit System! :) \n'
        '    If you conquer this system, you\'ll be able to memorize numbers with absolute ease. '
        'One telephone number? One scene. Credit card numbers fit in two scenes. '
        'It takes a long time to set up (it took me weeks), but I\'m having fun with it. ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Triple Digit Edit/View',
      information: information,
      buttonColor: colorTripleDigitStandard,
      buttonSplashColor: colorTripleDigitDarker,
      firstHelpKey: tripleDigitEditFirstHelpKey,
    );
  }
}
