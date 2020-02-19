import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class AlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AlphabetTimedTestScreen({this.callback, this.globalKey});

  @override
  _AlphabetTimedTestScreenState createState() =>
      _AlphabetTimedTestScreenState();
}

class _AlphabetTimedTestScreenState extends State<AlphabetTimedTestScreen> {
  String char1 = '';
  String char2 = '';
  String char3 = '';
  String char4 = '';
  String char5 = '';
  String char6 = '';
  String char7 = '';
  String char8 = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
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
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, 'AlphabetTimedTestFirstHelp', AlphabetTimedTestScreenHelp());
    // grab the digits
    char1 = await prefs.getString('alphabetTestChar1');
    char2 = await prefs.getString('alphabetTestChar2');
    char3 = await prefs.getString('alphabetTestChar3');
    char4 = await prefs.getString('alphabetTestChar4');
    char5 = await prefs.getString('alphabetTestChar5');
    char6 = await prefs.getString('alphabetTestChar6');
    char7 = await prefs.getString('alphabetTestChar7');
    char8 = await prefs.getString('alphabetTestChar8');
    print('real answer: $char1$char2$char3$char4 $char5$char6$char7$char8');
    setState(() {});
  }

  void checkAnswer() async {
    if (textController1.text.toLowerCase().trim() ==
            '$char1$char2$char3$char4'.toLowerCase() &&
        textController2.text.toLowerCase().trim() ==
            '$char5$char6$char7$char8'.toLowerCase()) {
      print('success');
      await prefs.updateActivityState(alphabetTimedTestKey, 'review');
      await prefs.updateActivityVisible(alphabetTimedTestKey, false);
      await prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
      if (await prefs.getBool(alphabetTimedTestCompleteKey) == null) {
        await prefs.updateActivityVisible(paoEditKey, true);
        await prefs.setBool(alphabetTimedTestCompleteKey, true);
      }
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the PAO system!',
        textColor: Colors.white,
        backgroundColor: colorPAODarker,
        durationSeconds: 5,
        isSuper: true,
      );
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController1.text = '';
    textController2.text = '';
    Navigator.pop(context);
    widget.callback();
    widget.callback();
  }

  void giveUp() async {
    await prefs.updateActivityState(alphabetTimedTestKey, 'review');
    await prefs.updateActivityVisible(alphabetTimedTestKey, false);
    await prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
    if (await prefs.getBool(alphabetTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(alphabetTimedTestPrepKey, 'todo');
    }
    showSnackBar(
      scaffoldState: widget.globalKey.currentState,
      snackBarText: 'Try the timed test again to unlock the next system.',
      textColor: Colors.black,
      backgroundColor: colorIncorrect,
      durationSeconds: 3,
    );
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Alphabet: timed test'),
          backgroundColor: Colors.blue[200],
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AlphabetTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: Text(
                    'Enter the characters: ',
                    style: TextStyle(
                        fontSize: 30, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono', color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXX',
                        hintStyle: TextStyle(fontSize: 30, color: backgroundHighlightColor)),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono', color: backgroundHighlightColor),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXX',
                        hintStyle: TextStyle(fontSize: 30, color: backgroundHighlightColor)),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      fontSize: 24,
                      color: Colors.grey[200],
                      splashColor: Colors.blue,
                      onPressed: () => giveUp(),
                      padding: 10,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      fontSize: 24,
                      color: Colors.blue[200],
                      splashColor: Colors.blue,
                      onPressed: () => checkAnswer(),
                      padding: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlphabetTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: Colors.blue[100],
      buttonSplashColor: Colors.blue[300],
      firstHelpKey: alphabetTimedTestFirstHelpKey,
    );
  }
}
