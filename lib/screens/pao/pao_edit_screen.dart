import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';

class PAOEditScreen extends StatefulWidget {
  final Function callback;

  PAOEditScreen({Key key, this.callback}) : super(key: key);

  @override
  _PAOEditScreenState createState() => _PAOEditScreenState();
}

class _PAOEditScreenState extends State<PAOEditScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  callback(newPaoData) async {
    setState(() {
      paoData = newPaoData;
    });
    // check if all data is complete
    bool entriesComplete = true;
    for (int i = 0; i < paoData.length; i++) {
      if (paoData[i].person == '') {
        entriesComplete = false;
      }
      if (paoData[i].action == '') {
        entriesComplete = false;
      }
      if (paoData[i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = await prefs.getActivityVisible(paoPracticeKey);
    if (entriesComplete && !completedOnce) {
      await prefs.updateActivityVisible(paoPracticeKey, true);
      await prefs.updateActivityState(paoEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CabinSketch', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorPAODarker,
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      widget.callback();
    }
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoEditFirstHelpKey, PAOEditScreenHelp());
    if (await prefs.getString(paoKey) == null) {
      paoData = debugModeEnabled ? defaultPAOData2 : defaultPAOData1;
      await prefs.setString(paoKey, json.encode(paoData));
    } else {
      paoData = await prefs.getSharedPrefs(paoKey);
    }
    setState(() {});
  }

  List<EditCard> getPAOEditCards() {
    List<EditCard> paoEditCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        EditCard paoEditCard = EditCard(
          entry: PAOData(paoData[i].index, paoData[i].digits, paoData[i].person,
              paoData[i].action, paoData[i].object, paoData[i].familiarity),
          callback: callback,
          activityKey: 'PAO',
        );
        paoEditCards.add(paoEditCard);
      }
    }
    return paoEditCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('PAO: view/edit'),
          backgroundColor: Colors.pink[200],
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
                      return PAOEditScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: Center(
            child: ListView(
          children: getPAOEditCards(),
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

  updatePAOData(List<PAOData> paoDataList) async {
    var prefs = PrefsUpdater();
    prefs.writeSharedPrefs(paoKey, paoDataList);
    widget.callback(paoDataList);
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
                              '    Here you can upload CSV text to quickly update your PAO values!\n'
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
                          TextField(
                            maxLines: 4,
                            decoration: InputDecoration(
                                hintText:
                                    'Ozzy Osbourne,rocking out a concert,rock guitar\n'
                                    'Orlando Bloom,walking the plank,eyepatch\n'
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
                          color: colorPAOStandard,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          onPressed: () {
                            HapticFeedback.heavyImpact();
                            var csvConverter = CsvToListConverter();
                            var l = csvConverter.convert(textController.text,
                                eol: '\n');
                            if (l.length == 100) {
                              List<PAOData> paoDataList = [];
                              l.asMap().forEach((k, v) {
                                paoDataList.add(PAOData(
                                    k,
                                    defaultPAOData1[k].digits,
                                    v[0],
                                    v[1],
                                    v[2],
                                    0));
                              });
                              updatePAOData(paoDataList);
                              Navigator.pop(context);
                            }
                            //Navigator.pop(context);
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

class PAOEditScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to the 3rd system here at Takao Studios :) \n'
        '    PAO stands for Person Action Object. What this means is that for every digit '
        '00, 01, 02, ..., 98, 99 we are going to assign a person, action, and object. Again, '
        'you can assign any person, action, and object to any digit, but it\'s a good idea at first '
        'to follow some kind of pattern. ',
    '    This will take some time to set up! But believe me, it\'ll be worth it. \n'
        '    The person should be associated to its corresponding action and object, '
        'and no two persons, actions, or objects should be too similar (also avoid overlap with '
        'your single digit and alphabet systems!). As a starter pattern, we recommend '
        'using an initials pattern. ',
    '    The initials pattern proposed in "Remember It!" by Nelson Dellis has '
        '0=O, 1=A, 2=B, 3=C, 4=D, 5=E, 6=S, 7=G, 8=H, and 9=N. Zeros, sixes, and nines are an exception because Os, Fs, and Is are '
        'pretty rare in names; zeros look like Os, and (S)ix and (N)ine are more common letters in initials.\n'
        '     Using this pattern it becomes '
        'much easier to find famous people/fictional characters with initials, i.e. 12=AB=Antonio Banderas.',
    '    This system allows us to memorize sequences of numbers very efficiently. Passport/license IDs, '
        'phone numbers, order numbers, almost anything. The way it works is we break long sequences of numbers '
        'into groups of 6, or three pairs of two digits, each pair corresponding to a person, action, and object. ',
    '    For example, for the number 958417 we\'d break it down into 95-84-17, '
        'which under my personal system corresponds to 95 (person) = Tom Brady, 84 (action) = riding a motorcycle, '
        '17 (object) = giant boulder. So my visualized scene would be Tom Brady riding a motorcycle over '
        'a bunch of giant boulders. What a sight that would be!',
    '    This system should take a good amount of time setting up before you start trying to master it. Update '
        'the PAO values for your digits until you\'re really happy with the list. Use people you know in real life, '
        'famous celebrities, fictional characters... anyone! Just make sure everything is as unique as possible, '
        'because overlap will make decoding more difficult. ',
    '    As a final note, it\'s possible to upload an entire PAO system through the CSV upload method available in '
        'the top right of the screen. More details on how to do that is available in the upload section.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Edit/View',
      information: information,
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
      firstHelpKey: paoEditFirstHelpKey,
    );
  }
}
