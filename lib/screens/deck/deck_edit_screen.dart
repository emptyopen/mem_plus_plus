import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

class DeckEditScreen extends StatefulWidget {
  final Function callback;

  DeckEditScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _DeckEditScreenState createState() => _DeckEditScreenState();
}

class _DeckEditScreenState extends State<DeckEditScreen> {
  late List<DeckData> deckData;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, deckEditFirstHelpKey,
        DeckEditScreenHelp(callback: widget.callback));
    if (prefs.getString(deckKey) == '') {
      deckData = debugModeEnabled ? defaultDeckData2 : defaultDeckData1;
      prefs.setString(deckKey, json.encode(deckData));
    } else {
      deckData = prefs.getSharedPrefs(deckKey) as List<DeckData>;
    }
    setState(() {});
  }

  callback(newDeckData) {
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
    bool completedOnce = prefs.getActivityVisible(deckPracticeKey);
    if (entriesComplete && !completedOnce) {
      prefs.updateActivityVisible(deckPracticeKey, true);
      prefs.updateActivityState(deckEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style:
              TextStyle(color: Colors.white, fontFamily: 'Viga', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorDeckDarker,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getDeckEditCards() {
    List<EditCard> deckEditCards = [];
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
    return deckEditCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deck System', style: TextStyle(fontSize: 18)),
        backgroundColor: colorDeckStandard,
        actions: <Widget>[
          IconButton(
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
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return DeckEditScreenHelp(callback: widget.callback);
                  }));
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
            child: Column(
          children: getDeckEditCards(),
        )),
      ),
    );
  }
}

class CSVImporter extends StatefulWidget {
  final Function callback;

  CSVImporter({required this.callback});

  @override
  _CSVImporterState createState() => _CSVImporterState();
}

class _CSVImporterState extends State<CSVImporter> {
  final textController = TextEditingController();

  updateDeckData(List<DeckData> deckDataList) {
    PrefsUpdater prefs = PrefsUpdater();
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
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '    Here you can upload CSV text to quickly update your Deck values!\n'
                              '    Click below to save a copy of the template! I\'d recommend working primarily in your google doc as '
                              'you develop your Deck system, and come back to paste it here when you\'ve completed it.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BasicFlatButton(
                              text: 'Google docs link!',
                              color: colorDeckDarker,
                              textColor: Colors.white,
                              onPressed: () => launch(
                                  'https://docs.google.com/spreadsheets/d/11qs3Uv0Nxwe12vHtR0qJSadZLj_5uhQm3-HvGVDIvK0/edit?usp=sharing'),
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ace through King, in order of Spades, Hearts, Clubs, Diamonds',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintText: 'Copy the G12 cell here!',
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
                        BasicFlatButton(
                          text: 'Cancel',
                          fontSize: 20,
                          color: Colors.grey[300]!,
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        BasicFlatButton(
                          text: 'Submit',
                          fontSize: 20,
                          color: colorDeckStandard,
                          onPressed: () {
                            print('yo');
                            HapticFeedback.lightImpact();
                            var csvConverter = CsvToListConverter();
                            var l = csvConverter.convert(textController.text,
                                eol: '|');
                            print(l.length);
                            if (l.length == 52) {
                              List<DeckData> deckDataList = [];
                              l.asMap().forEach((k, v) {
                                deckDataList.add(DeckData(
                                    k,
                                    defaultDeckData1[k].digitSuit,
                                    v[0],
                                    v[1],
                                    v[2],
                                    0));
                              });
                              updateDeckData(deckDataList);
                              Navigator.pop(context);
                            }
                          },
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

class DeckEditScreenHelp extends StatelessWidget {
  final Function callback;
  DeckEditScreenHelp({Key? key, required this.callback}) : super(key: key);
  final List<String> information = [
    '    Welcome to the deck system! \n'
        '    Here we are going to use the same idea as the PAO system, only now for each of the 52 cards! '
        'Feel free to re-use People, Actions, and Objects from your 2-digit PAO system, unless you\'re planning '
        'on being in a position where you\'ll have to remember combinations of digits and cards.',
    '    One tip I\'d give from my personal system is to break up the people into categories based on suit. '
        'In my system, Spades are fictional characters, Hearts are people I know personally, Clubs are athletes and '
        'performers, and Diamonds are rich people or other celebrities. But feel free to memorize however you want!',
    '    Once again, I\'d also highly recommend storing this data in a google sheet and importing it! A lot '
        'easier than having to type everything out on your phone, and you can always reuse it in case you '
        'get a new phone. '
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'The Deck System',
      information: information,
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckEditFirstHelpKey,
      callback: callback,
    );
  }
}
