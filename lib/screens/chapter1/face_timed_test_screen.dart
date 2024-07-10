import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/levenshtein.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class FaceTimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  FaceTimedTestScreen({required this.callback, required this.globalKey});

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

  getSharedPrefs() {
    prefs.checkFirstTime(context, faceTimedTestFirstHelpKey,
        FaceTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    face1 = (prefs.getString('face1'));
    face2 = (prefs.getString('face2'));
    name1 = (prefs.getString('name1'));
    name2 = (prefs.getString('name2'));
    isLoaded = true;
    print('real answer: $name1 $name2');
    setState(() {});
  }

  checkAnswer() {
    HapticFeedback.lightImpact();
    String answer1 = name1.toLowerCase().trim();
    String guess1 = textController1.text.toLowerCase().trim();
    String answer2 = name2.toLowerCase().trim();
    String guess2 = textController2.text.toLowerCase().trim();
    if (levenshtein(answer1, guess1) <= 2 &&
        levenshtein(answer2, guess2) <= 2) {
      if (levenshtein(answer1, guess1) == 1 ||
          levenshtein(answer2, guess2) == 1) {
        print('close enough');
      } else {
        print('success');
      }
      // every time
      prefs.updateActivityVisible(faceTimedTestKey, false);
      prefs.updateActivityVisible(faceTimedTestPrepKey, true);
      if (!prefs.getBool(faceTimedTestCompleteKey)) {
        prefs.updateActivityState(faceTimedTestKey, 'review');
        prefs.setBool(faceTimedTestCompleteKey, true);
        if (!prefs.getBool(planetTimedTestCompleteKey)) {
          showSnackBar(
            context: context,
            snackBarText:
                'Awesome job! Complete the Planet test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter1Darker,
            durationSeconds: 3,
          );
        } else {
          prefs.updateActivityVisible(alphabetEditKey, true);
          showSnackBar(
            context: context,
            snackBarText:
                'Congratulations! You\'ve unlocked the Alphabet system!',
            textColor: Colors.white,
            backgroundColor: colorAlphabetDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter1Darker,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
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

  giveUp() {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(faceTimedTestKey, 'review');
    prefs.updateActivityVisible(faceTimedTestKey, false);
    prefs.updateActivityVisible(faceTimedTestPrepKey, true);
    if (!prefs.getBool(faceTimedTestCompleteKey)) {
      prefs.updateActivityState(faceTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        context: context,
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
          title: Text('Face: timed test', style: TextStyle(fontSize: 18)),
          backgroundColor: colorChapter1Darker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return FaceTimedTestScreenHelp(callback: widget.callback);
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
                            color: Colors.grey[200]!,
                            onPressed: () => giveUp(),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          BasicFlatButton(
                            text: 'Submit',
                            fontSize: 24,
                            color: colorChapter1Standard,
                            onPressed: () => checkAnswer(),
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
  final Function callback;
  FaceTimedTestScreenHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Faces - Timed Test',
      information: [
        '    Time to remember the link between face features and similar '
            'sounds! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorChapter1Standard,
      buttonSplashColor: colorChapter1Darker,
      firstHelpKey: faceTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
