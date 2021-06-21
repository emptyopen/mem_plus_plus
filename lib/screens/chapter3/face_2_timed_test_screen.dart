import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:edit_distance/edit_distance.dart';
import 'package:flutter/services.dart';

class Face2TimedTestScreen extends StatefulWidget {
  final Function callback;
  final GlobalKey<ScaffoldState> globalKey;

  Face2TimedTestScreen({this.callback, this.globalKey});

  @override
  _Face2TimedTestScreenState createState() => _Face2TimedTestScreenState();
}

class _Face2TimedTestScreenState extends State<Face2TimedTestScreen> {
  String face1 = '';
  String name1 = '';
  String job1 = '';
  String hometown1 = '';
  String face2 = '';
  String name2 = '';
  String job2 = '';
  String hometown2 = '';
  final name1Controller = TextEditingController();
  final job1Controller = TextEditingController();
  final hometown1Controller = TextEditingController();
  final name2Controller = TextEditingController();
  final job2Controller = TextEditingController();
  final hometown2Controller = TextEditingController();
  bool isLoaded = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    name1Controller.dispose();
    job1Controller.dispose();
    hometown1Controller.dispose();
    name2Controller.dispose();
    job2Controller.dispose();
    hometown2Controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, face2TimedTestFirstHelpKey, Face2TimedTestScreenHelp());
    face1 = await prefs.getString('face2Face1');
    name1 = await prefs.getString('face2Name1');
    job1 = await prefs.getString('face2Job1');
    hometown1 = await prefs.getString('face2Hometown1');
    face2 = await prefs.getString('face2Face2');
    name2 = await prefs.getString('face2Name2');
    job2 = await prefs.getString('face2Job2');
    hometown2 = await prefs.getString('face2Hometown2');
    isLoaded = true;
    print('real answer: $name1 $job1 $hometown1 || $name2 $job2 $hometown2');
    setState(() {});
  }

  void checkAnswer() async {
    HapticFeedback.lightImpact();
    Levenshtein d = new Levenshtein();
    String name1Answer = name1.toLowerCase().trim();
    String name1Guess = name1Controller.text.toLowerCase().trim();
    String name2Answer = name2.toLowerCase().trim();
    String name2Guess = name2Controller.text.toLowerCase().trim();
    String job1Answer = job1.toLowerCase().trim();
    String job1Guess = job1Controller.text.toLowerCase().trim();
    String job2Answer = job2.toLowerCase().trim();
    String job2Guess = job2Controller.text.toLowerCase().trim();
    String hometown1Answer = hometown1.toLowerCase().trim();
    String hometown1Guess = hometown1Controller.text.toLowerCase().trim();
    String hometown2Answer = hometown2.toLowerCase().trim();
    String hometown2Guess = hometown2Controller.text.toLowerCase().trim();
    if (d.distance(name1Answer, name1Guess) <= 2 &&
        d.distance(name2Answer, name2Guess) <= 2 &&
        d.distance(job1Answer, job1Guess) <= 4 &&
        d.distance(job2Answer, job2Guess) <= 4 &&
        d.distance(hometown1Answer, hometown1Guess) <= 2 &&
        d.distance(hometown2Answer, hometown2Guess) <= 2) {
      await prefs.updateActivityVisible(face2TimedTestKey, false);
      await prefs.updateActivityVisible(face2TimedTestPrepKey, true);
      if (await prefs.getBool(face2TimedTestCompleteKey) == null) {
        await prefs.updateActivityState(face2TimedTestKey, 'review');
        await prefs.setBool(face2TimedTestCompleteKey, true);
        if (await prefs.getBool(piTimedTestCompleteKey) == null) {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Awesome job! Complete the Pi test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter3Darker,
            durationSeconds: 3,
          );
        } else {
          await prefs.updateActivityVisible(deckEditKey, true);
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText: 'Congratulations! You\'ve unlocked the Deck system!',
            textColor: Colors.white,
            backgroundColor: colorDeckDarker,
            durationSeconds: 3,
            isSuper: true,
          );
          await prefs.updateActivityVisible(tripleDigitEditKey, true);
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Congratulations! You\'ve unlocked the Triple Digit system!',
            textColor: Colors.white,
            backgroundColor: colorTripleDigitDarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter3Darker,
          durationSeconds: 2,
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
    name1Controller.text = '';
    job1Controller.text = '';
    hometown1Controller.text = '';
    name2Controller.text = '';
    job2Controller.text = '';
    hometown2Controller.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.lightImpact();
    await prefs.updateActivityState(face2TimedTestKey, 'review');
    await prefs.updateActivityVisible(face2TimedTestKey, false);
    await prefs.updateActivityVisible(face2TimedTestPrepKey, true);
    if (await prefs.getBool(face2TimedTestCompleteKey) == null) {
      await prefs.updateActivityState(face2TimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'The correct information was: \n$name1, $job1, $hometown1 \n'
            '$name2, $job2, $hometown2\nTry the timed test again to unlock the next system.',
        backgroundColor: colorIncorrect,
        durationSeconds: 6);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Face: timed test'),
          backgroundColor: colorChapter3Darker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return Face2TimedTestScreenHelp();
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
                          'Enter the information: ',
                          style: TextStyle(
                              fontSize: 30, color: backgroundHighlightColor),
                        ),
                      ),
                      SizedBox(height: 25),
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
                        height: 20,
                      ),
                      InputPair(
                        textController: name1Controller,
                        title: 'Name:',
                        width: 270,
                        hintText: '______   ______',
                      ),
                      InputPair(
                        textController: job1Controller,
                        title: 'Job:',
                      ),
                      InputPair(
                        textController: hometown1Controller,
                        title: 'Hometown:',
                      ),
                      SizedBox(
                        height: 40,
                      ),
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
                        height: 20,
                      ),
                      InputPair(
                        textController: name2Controller,
                        title: 'Name:',
                        width: 270,
                        hintText: '______   ______',
                      ),
                      InputPair(
                        textController: job2Controller,
                        title: 'Job:',
                      ),
                      InputPair(
                        textController: hometown2Controller,
                        title: 'Hometown:',
                      ),
                      SizedBox(height: 30),
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
                            color: colorChapter3Standard,
                            splashColor: colorChapter3Darker,
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

class InputPair extends StatelessWidget {
  final TextEditingController textController;
  final String title;
  final TextInputType keyboardType;
  final double width;
  final String hintText;

  InputPair(
      {this.textController,
      this.title,
      this.keyboardType = TextInputType.text,
      this.width = 220,
      this.hintText = '________'});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: width,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
          child: TextFormField(
            controller: textController,
            textAlign: TextAlign.center,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundHighlightColor)),
                hintText: hintText,
                hintStyle:
                    TextStyle(fontSize: 18, color: backgroundHighlightColor)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class Face2TimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Face Timed Test',
      information: [
        '    Time to remember the link between face features and similar '
            'sounds! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorChapter3Standard,
      buttonSplashColor: colorChapter3Darker,
      firstHelpKey: face2TimedTestFirstHelpKey,
    );
  }
}
