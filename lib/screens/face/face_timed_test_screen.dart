import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:edit_distance/edit_distance.dart';
import 'package:flutter/services.dart';

class FaceTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  FaceTimedTestScreen({this.callback, this.globalKey});

  @override
  _FaceTimedTestScreenState createState() => _FaceTimedTestScreenState();
}

class _FaceTimedTestScreenState extends State<FaceTimedTestScreen> {
  String face1 = '';
  String face2 = '';
  String name1 = '';
  String name2 = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  bool isLoaded = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, faceTimedTestFirstHelpKey, FaceTimedTestScreenHelp());
    // grab the digits
    face1 = await prefs.getString('face1');
    face2 = await prefs.getString('face2');
    name1 = await prefs.getString('name1');
    name2 = await prefs.getString('name2');
    isLoaded = true;
    print('real answer: $name1 $name2');
    setState(() {});
  }

  void checkAnswer() async {
    HapticFeedback.heavyImpact();
    Levenshtein d = new Levenshtein();
    String answer1 = name1.toLowerCase().trim();
    String guess1 = textController1.text.toLowerCase().trim();
    String answer2 = name2.toLowerCase().trim();
    String guess2 = textController2.text.toLowerCase().trim();
    if (d.distance(answer1, guess1) <= 1 && d.distance(answer2, guess2) <= 1) {
      if (d.distance(answer1, guess1) == 1 ||
          d.distance(answer1, guess1) == 1) {
        print('close enough');
      } else {
        print('success');
      }
      // every time
      await prefs.updateActivityVisible(faceTimedTestKey, false);
      await prefs.updateActivityVisible(faceTimedTestPrepKey, true);
      if (await prefs.getActivityState(faceTimedTestKey) == 'todo') {
        await prefs.updateActivityState(faceTimedTestKey, 'review');
        await prefs.updateActivityVisible(deckEditKey, true);
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You\'ve unlocked the Deck system!',
          textColor: Colors.white,
          backgroundColor: colorDeckDarker,
          durationSeconds: 5,
          isSuper: true,
        );
      } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Congratulations! You aced it!',
        textColor: Colors.black,
        backgroundColor: colorFaceDarker,
        durationSeconds: 3,
      );
    }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController1.text = '';
    textController2.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.heavyImpact();
    await prefs.updateActivityState(faceTimedTestKey, 'review');
    await prefs.updateActivityVisible(faceTimedTestKey, false);
    await prefs.updateActivityVisible(faceTimedTestPrepKey, true);
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'The correct names were: \n$name1 \n$name2\nTry the timed test again to unlock the next system.',
        backgroundColor: colorIncorrect,
        durationSeconds: 5);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Face: timed test'),
          backgroundColor: colorFaceDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return FaceTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: isLoaded
          ? SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(color: backgroundColor),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Text(
                          'Enter the names: ',
                          style: TextStyle(
                              fontSize: 30, color: backgroundHighlightColor),
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  height: 200,
                                  image: AssetImage(
                                    'assets/images/$face1',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: TextFormField(
                                  controller: textController1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: backgroundHighlightColor),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: backgroundSemiColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: backgroundHighlightColor)),
                                      hintText: '________',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: backgroundHighlightColor)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  height: 200,
                                  image: AssetImage(
                                    'assets/images/$face2',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: TextFormField(
                                  controller: textController2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: backgroundHighlightColor),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: backgroundSemiColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: backgroundHighlightColor)),
                                      hintText: '________',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: backgroundHighlightColor)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          BasicFlatButton(
                            text: 'Give up',
                            fontSize: 24,
                            color: Colors.grey[200],
                            splashColor: Colors.grey[400],
                            onPressed: () => giveUp(),
                            padding: 10,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          BasicFlatButton(
                            text: 'Submit',
                            fontSize: 24,
                            color: colorFaceStandard,
                            splashColor: colorFaceDarker,
                            onPressed: () => checkAnswer(),
                            padding: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}

class FaceTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Face Timed Test',
      information: [
        '    Time to remember the link between face features and similar '
            'sounds! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorFaceStandard,
      buttonSplashColor: colorFaceDarker,
      firstHelpKey: faceTimedTestFirstHelpKey,
    );
  }
}
