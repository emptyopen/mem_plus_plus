import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';

class DeckEditScreen extends StatefulWidget {
  final Function callback;

  DeckEditScreen({Key key, this.callback}) : super(key: key);

  @override
  _DeckEditScreenState createState() => _DeckEditScreenState();
}

class _DeckEditScreenState extends State<DeckEditScreen> {
  List<DeckData> deckData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, deckEditFirstHelpKey, DeckEditScreenHelp());
    if (await prefs.getString(deckKey) == null) {
      print('initializing new data');
      deckData = debugModeEnabled ? defaultDeckData2 : defaultDeckData1;
      await prefs.setString(deckKey, json.encode(deckData));
    } else {
      print('getting old data');
      deckData = await prefs.getSharedPrefs(deckKey);
    }
    setState(() {});
  }

  callback(newDeckData) async {
    setState(() {
      deckData = newDeckData;
    });
    // check if all data is complete
    bool entriesComplete = true;
    for (int i = 0; i < deckData.length; i++) {
      if (deckData[i].person == '') {
        entriesComplete = false;
      }
      if (deckData[i].action == '') {
        entriesComplete = false;
      }
      if (deckData[i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = await prefs.getActivityVisible(deckPracticeKey);
    if (entriesComplete && !completedOnce) {
      await prefs.updateActivityVisible(deckPracticeKey, true);
      await prefs.updateActivityState(deckEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'CabinSketch',
            fontSize: 18
          ),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorDeckDarker,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getDeckEditCards() {
    List<EditCard> deckEditCards = [];
    print('yo');
    if (deckData != null) {
      for (int i = 0; i < deckData.length; i++) {
        EditCard deckEditCard = EditCard(
          entry: DeckData(
              deckData[i].index,
              deckData[i].digitSuit,
              deckData[i].person,
              deckData[i].action,
              deckData[i].object,
              deckData[i].familiarity),
          callback: callback,
          activityKey: deckKey,
        );
        deckEditCards.add(deckEditCard);
      }
    }
    return deckEditCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Deck: view/edit'),
          backgroundColor: colorDeckStandard,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_downward),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return CSVImporter(callback: callback);
                    }));
              },
            ),
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return DeckEditScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
            child: ListView(
          children: getDeckEditCards(),
        )),
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

  updateDeckData(List<DeckData> deckDataList) async {
    var prefs = PrefsUpdater();
    prefs.writeSharedPrefs(deckKey, deckDataList);
    widget.callback(deckDataList);
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
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '    Here you can upload CSV text to quickly update your deck values!\n'
                              '    You can do this in Google Sheets very easily. You just need '
                              'a column for Person, Action, and Object (no need for headers). Then in a '
                              'new column, add to the top cell: ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '=concat(concat(concat(concat(XX,","),YY),","),ZZ)',
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'SpaceMono'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'where XX is the cell represting the person (in the same row), '
                              'YY=action cell, ZZ=object cell. Then just drag the formula down to the bottom, '
                              'copy that last column, and paste it here! ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 350,
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Input below: ',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Ace through King, in order of Aces, Hearts, Clubs, Diamonds',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintText:
                                    'Ariel,singing underwater,mermaid fin\n'
                                    '...',
                                hintStyle: TextStyle(fontSize: 15)),
                            controller: textController,
                          ),
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
                            HapticFeedback.heavyImpact();
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
                          color: colorDeckStandard,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            var csvConverter = CsvToListConverter();
                            var l = csvConverter.convert(textController.text,
                                eol: '\n');
                            if (l.length == 52) {
                              List<DeckData> deckDataList = [];
                              l.asMap().forEach((k, v) {
                                deckDataList.add(DeckData(
                                    k, defaultDeckData1[k].digitSuit, v[0], v[1], v[2], 0));
                              });
                              updateDeckData(deckDataList);
                              Navigator.pop(context);
                            }
                          },
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
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

class DeckEditScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to the deck system! \n'
        '    PAO stands for Person Action Object. What this means is that for every digit '
        '00, 01, 02, ..., 98, 99 we are going to assign a person, action, and object. Again, '
        'you can assign any person, action, and object to any digit, but it\'s a good idea at first '
        'to follow some kind of pattern. ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Deck Edit/View',
      information: information,
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckEditFirstHelpKey,
    );
  }
}
