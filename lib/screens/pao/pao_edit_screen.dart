import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/components/info_box.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class PAOEditScreen extends StatefulWidget {
  final Function callback;

  PAOEditScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _PAOEditScreenState createState() => _PAOEditScreenState();
}

class _PAOEditScreenState extends State<PAOEditScreen> {
  late SharedPreferences sharedPreferences;
  late List<PAOData>? paoData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, paoEditFirstHelpKey, PAOEditScreenHelp());
    if (prefs.getString(paoKey) == null) {
      paoData = debugModeEnabled ? defaultPAOData2 : defaultPAOData1;
      prefs.setString(paoKey, json.encode(paoData));
    } else {
      paoData = prefs.getSharedPrefs(paoKey) as List<PAOData>;
    }
    setState(() {});
  }

  callback(newPaoData) async {
    setState(() {
      paoData = newPaoData;
    });
    // check if all data is complete
    bool entriesComplete = true;
    for (int i = 0; i < paoData!.length; i++) {
      if (paoData![i].person == '') {
        entriesComplete = false;
      }
      if (paoData![i].action == '') {
        entriesComplete = false;
      }
      if (paoData![i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = prefs.getActivityVisible(paoPracticeKey);
    if (entriesComplete && !completedOnce) {
      prefs.updateActivityVisible(paoPracticeKey, true);
      prefs.updateActivityState(paoEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style: TextStyle(
              color: Colors.white, fontFamily: 'CabinSketch', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorPAODarker,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.callback();
    }
  }

  List<EditCard> getPAOEditCards() {
    List<EditCard> paoEditCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData!.length; i++) {
        EditCard paoEditCard = EditCard(
          entry: PAOData(
              paoData![i].index,
              paoData![i].digits,
              paoData![i].person,
              paoData![i].action,
              paoData![i].object,
              paoData![i].familiarity),
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
          backgroundColor: colorPAOStandard,
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
                      return PAOEditScreenHelp();
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
              children: getPAOEditCards(),
            )),
          ),
          Positioned(
            top: 4,
            right: 50,
            child: InfoBox(
                text: 'Start your PAO journey here!',
                infoKey: 'accountSection'),
          ),
        ],
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
  String errorMessage = '';

  updatePAOData(List<PAOData> paoDataList) async {
    PrefsUpdater prefs = PrefsUpdater();
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
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '    Here you can upload CSV text to quickly update your PAO values!\n'
                              '    Click below to save a copy of the template! I\'d recommend working primarily in your google doc as '
                              'you develop your PAO system, and come back to paste it here when you\'ve completed it.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            BasicFlatButton(
                              text: 'Google docs link!',
                              color: colorPAODarker,
                              textColor: Colors.white,
                              onPressed: () => launch(
                                  'https://docs.google.com/spreadsheets/d/17Cl4EfZTNo_FdmLUkSYzz6SXnjm1Gi5u00aD4d_zMCU/edit?usp=sharing'),
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
                        ElevatedButton(
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colorPAOStandard,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
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
                            if (l.length != 100) {
                              inputIsValid = false;
                              errorMessage +=
                                  '\n${l.length} lines detected (need 100).';
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
                              List<PAOData> paoDataList = [];
                              l.asMap().forEach((k, v) {
                                String person = v[0].toString();
                                String action = v[1].toString();
                                String object = v[2].toString();
                                paoDataList.add(PAOData(
                                    k,
                                    defaultPAOData1[k].digits,
                                    person,
                                    action,
                                    object,
                                    0));
                              });
                              updatePAOData(paoDataList);
                              Navigator.pop(context);
                            }
                            setState(() {});
                          },
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

class PAOEditScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to the 3rd system, the Double Digit / PAO System! :) \n'
        '    PAO stands for Person Action Object. What this means is that for every digit '
        '00, 01, 02, ..., 98, 99 we are going to assign a person, action, and object. '
        'You can assign any person, action, and object to any digit, but it\'s a good idea at first '
        'to follow some kind of pattern. ',
    '    This will take some time to set up! It took me a few days to put together the list, and another few weeks to '
        'start becoming "number fluent", to the point where I could instantly translate any numbers to scenes. But TRUST me, it\'ll be worth it. \n\n'
        '    The person should be associated to its corresponding action and object, '
        'and no two persons, actions, or objects should be too similar (also avoid overlap with '
        'your single digit and alphabet systems!). As a starter pattern, I recommend '
        'using an initials pattern. ',
    '    The initials pattern proposed in "Remember It!" by Nelson Dellis has '
        '0=O, 1=A, 2=B, 3=C, 4=D, 5=E, 6=S, 7=G, 8=H, and 9=N. Zeros, sixes, and nines are an exception because Fs, and Is are '
        'pretty rare in names; zeros look like Os, and (S)ix and (N)ine are more common letters in initials.\n'
        '     Using this pattern it becomes '
        'much easier to find famous people/fictional characters with initials, i.e. 12=AB=Antonio Banderas.',
    '    This system allows us to memorize sequences of numbers very efficiently. Passport/license IDs, '
        'phone numbers, order numbers, almost anything. The way it works is we break long sequences of numbers '
        'into groups of 6, or three pairs of two digits, each pair corresponding to a person, action, and object.\n\n'
        '    For example:\n\n    154825 -> 15-48-25\n    (15 person)\n    (48 action)\n    (25 object)',
    '    So with 15-48-25, '
        'which under my personal system corresponds to 15 (person) = AE = Albert Einstein, 48 (action) = DH (Dwight Howard) = slam dunking, '
        '25 (object) = quarters. \n    So my visualized scene would be ALBERT EINSTEIN who jumps into the air and SLAM DUNKS his '
        'fistfuls of shiny QUARTERS. What a sight that would be! Hear the cacaphony of quarters hit the ground as the absolute legend finally drops to the ground, shaking out his wild gray hair.',
    '    This system should take a good amount of time setting up before you start trying to master it. Update '
        'the PAO values for your digits until you\'re really happy with the list.\n\n    Use people you know in real life, '
        'famous celebrities, fictional characters... anyone! Just make sure everything is as unique as possible, '
        'because overlap will make decoding more difficult. ',
    '    As a final note, it\'s possible to upload an entire PAO system through the CSV upload method available in '
        'the top right of the screen.\n\n    I would highly, highly recommend storing your PAO data in a google doc. '
        'More details on how to do that is available in the upload section.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Edit/View',
      information: information,
      buttonColor: colorPAOStandard,
      buttonSplashColor: colorPAODarker,
      firstHelpKey: paoEditFirstHelpKey,
    );
  }
}
