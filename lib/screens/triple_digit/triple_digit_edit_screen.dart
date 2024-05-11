import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/components/info_box.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class TripleDigitEditScreen extends StatefulWidget {
  final Function callback;

  TripleDigitEditScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _TripleDigitEditScreenState createState() => _TripleDigitEditScreenState();
}

class _TripleDigitEditScreenState extends State<TripleDigitEditScreen> {
  late List<TripleDigitData> tripleDigitData;
  PrefsUpdater prefs = PrefsUpdater();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(context, tripleDigitEditFirstHelpKey,
        TripleDigitEditScreenHelp(callback: widget.callback));
    tripleDigitData =
        prefs.getSharedPrefs(tripleDigitKey) as List<TripleDigitData>;
    loading = false;
    setState(() {});
  }

  generateEmptyTripleDigitData() {
    List<TripleDigitData> data = [];
    for (int i = 0; i < 1000; i++) {
      data.add(TripleDigitData(i, i.toString().padLeft(3, '0'), '', '', '', 0));
    }
    return data;
  }

  updateTripleDigitData(newTripleDigitData, {isCSV = false}) async {
    bool entriesComplete = true;
    for (int i = 0; i < newTripleDigitData.length; i++) {
      if (tripleDigitData[i].person != newTripleDigitData[i].person ||
          tripleDigitData[i].action != newTripleDigitData[i].action ||
          tripleDigitData[i].object != newTripleDigitData[i].object) {
        tripleDigitData[i] = newTripleDigitData[i];
      }
      // check if incomplete
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

    PrefsUpdater prefs = PrefsUpdater();
    prefs.writeSharedPrefs(tripleDigitKey, tripleDigitData);

    // check if upload was success
    if (isCSV) {
      final snackBar = SnackBar(
        content: Text(
          'Upload success!',
          style:
              TextStyle(color: Colors.black, fontFamily: 'Viga', fontSize: 18),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: colorTripleDigitStandard,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    // check if information is filled out for the first time
    bool completedOnce = prefs.getActivityVisible(tripleDigitPracticeKey);
    if (entriesComplete && !completedOnce) {
      prefs.updateActivityVisible(tripleDigitPracticeKey, true);
      prefs.updateActivityState(tripleDigitEditKey, 'review');
      final snackBar = SnackBar(
        content: Text(
          'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          style:
              TextStyle(color: Colors.white, fontFamily: 'Viga', fontSize: 18),
        ),
        duration: Duration(seconds: 5),
        backgroundColor: colorTripleDigitDarker,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      widget.callback();
    }

    setState(() {});
  }

  List<EditCard> getTripleDigitEditCards() {
    List<EditCard> tripleDigitEditCards = [];
    for (int i = 0; i < tripleDigitData.length; i++) {
      EditCard tripleDigitEditCard = EditCard(
        entry: tripleDigitData[i],
        callback: updateTripleDigitData,
        activityKey: 'TripleDigit',
      );
      tripleDigitEditCards.add(tripleDigitEditCard);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        return CSVImporter(callback: updateTripleDigitData);
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
                      return TripleDigitEditScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: Stack(
        children: [
          loading
              ? Container()
              : Container(
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

  CSVImporter({required this.callback});

  @override
  _CSVImporterState createState() => _CSVImporterState();
}

class _CSVImporterState extends State<CSVImporter> {
  final textController = TextEditingController();
  String errorMessage = '';

  paddedNum(k) {
    return k.toString().padLeft(3, '0');
  }

  submitCSV() {
    HapticFeedback.lightImpact();
    var csvConverter = CsvToListConverter();
    String cleanedText = textController.text;
    cleanedText = cleanedText.trim();
    if (cleanedText.startsWith("\"")) {
      cleanedText = cleanedText.substring(1);
    }
    if (cleanedText.endsWith("\"")) {
      cleanedText = cleanedText.substring(0, cleanedText.length - 1);
    }
    var l = csvConverter.convert(cleanedText, eol: '|');
    bool inputIsValid = true;
    errorMessage = 'Incorrectly formatted!';
    if (l.length != 1000) {
      inputIsValid = false;
      errorMessage += '\n${l.length} lines detected (need 1000).';
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
      widget.callback(tripleDigitDataList, isCSV: true);
      Navigator.pop(context);
    }
    setState(() {});
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
                              '    Here you can upload CSV text to quickly update your Triple Digit values!\n'
                              '    Click below to save a copy of the template! I\'d recommend working primarily in your google doc as '
                              'you develop your Triple Digit system, and come back to paste it here when you\'ve completed it.',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorTripleDigitStandard,
                              ),
                              onPressed: () => launch(
                                  'https://docs.google.com/spreadsheets/d/1cBqw5IfRBUltVsZ2yEfQUb0E1-eA7volnOlJM4X1_dU/edit?usp=sharing'),
                              child: Text(
                                'Google docs link!',
                                style: TextStyle(color: Colors.white),
                              ),
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
                            onSubmitted: (s) {
                              submitCSV();
                            },
                            textInputAction: TextInputAction.go,
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
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.pop(context);
                          },
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
                              backgroundColor: colorTripleDigitStandard,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                          onPressed: () {
                            submitCSV();
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

class TripleDigitEditScreenHelp extends StatelessWidget {
  final Function callback;
  TripleDigitEditScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Welcome to the 5th system, the Triple Digit System! \n'
        '    If you conquer this system, you\'ll be able to memorize numbers with absolute ease. '
        'One telephone number? One scene. Credit card numbers fit in two scenes. '
        'It takes a long time to set up (it took me weeks), but I\'m having fun with it. ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'The Triple Digit System',
      information: information,
      buttonColor: colorTripleDigitStandard,
      buttonSplashColor: colorTripleDigitDarker,
      firstHelpKey: tripleDigitEditFirstHelpKey,
      callback: callback,
    );
  }
}
