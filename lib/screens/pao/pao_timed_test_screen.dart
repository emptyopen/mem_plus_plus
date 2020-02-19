import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class PAOTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOTimedTestScreen({this.callback, this.globalKey});

  @override
  _PAOTimedTestScreenState createState() =>
      _PAOTimedTestScreenState();
}

class _PAOTimedTestScreenState extends State<PAOTimedTestScreen> {
  String digits1 = '';
  String digits2 = '';
  String digits3 = '';
  String digits4 = '';
  String digits5 = '';
  String digits6 = '';
  String digits7 = '';
  String digits8 = '';
  String digits9 = '';
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();
  final textController3 = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController1.dispose();
    textController2.dispose();
    textController3.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'PAOTimedTestFirstHelp', PAOTimedTestScreenHelp());
    // grab the digits
    digits1 = await prefs.getString('paoTestDigits1');
    digits2 = await prefs.getString('paoTestDigits2');
    digits3 = await prefs.getString('paoTestDigits3');
    digits4 = await prefs.getString('paoTestDigits4');
    digits5 = await prefs.getString('paoTestDigits5');
    digits6 = await prefs.getString('paoTestDigits6');
    digits7 = await prefs.getString('paoTestDigits7');
    digits8 = await prefs.getString('paoTestDigits8');
    digits9 = await prefs.getString('paoTestDigits9');
    print('real answer: $digits1$digits2$digits3 $digits4$digits5$digits6 $digits7$digits8$digits9');
    setState(() {});
  }

  void checkAnswer() async {
    if (textController1.text.trim() == '$digits1$digits2$digits3' &&
        textController2.text.trim() == '$digits4$digits5$digits6' &&
        textController3.text.trim() == '$digits7$digits8$digits9') {
      await prefs.updateActivityState('PAOTimedTest', 'review');
      await prefs.updateActivityVisible('PAOTimedTest', false);
      await prefs.updateActivityVisible('PAOTimedTestPrep', true);

      await prefs.setBool(customMemoryManagerAvailableKey, true);
      if (await prefs.getBool(customMemoryManagerFirstHelpKey) == null) {
        await prefs.setBool(customMemoryManagerFirstHelpKey, true);
      }

      widget.callback();

      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Custom Memory Manager!',
        textColor: Colors.white,
        backgroundColor: Colors.purple,
        durationSeconds: 5,
        isSuper: true,
      );
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the XXX system!',
        textColor: Colors.white,
        backgroundColor: Colors.teal,
        durationSeconds: 5,
        isSuper: true,
      );
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    textController1.text = '';
    textController2.text = '';
    textController3.text = '';
    Navigator.pop(context);
  }

  void giveUp() async {
    await prefs.updateActivityState('PAOTimedTest', 'review');
    await prefs.updateActivityVisible('PAOTimedTest', false);
    await prefs.updateActivityVisible('PAOTimedTestPrep', true);
    Navigator.pop(context);
    showSnackBar(
      scaffoldState: widget.globalKey.currentState,
      snackBarText: 'The correct answers were: \n$digits1$digits2$digits3\n$digits4$digits5$digits6\n$digits7$digits8$digits9\nTry the timed test again to unlock the next system.',
      backgroundColor: colorIncorrect,
      durationSeconds: 15
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: backgroundColor,
      appBar: AppBar(title: Text('PAO: timed test'),
        backgroundColor: Colors.pink[200],
        actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return PAOTimedTestScreenHelp();
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
                SizedBox(height: 25,),
                Container(
                  child: Text(
                    'Enter the digits: ',
                    style: TextStyle(fontSize: 30, color: backgroundHighlightColor),
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
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundSemiColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXXX',
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
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundHighlightColor)),
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                        hintText: 'XXXXXX',
                        hintStyle: TextStyle(fontSize: 30, color: backgroundHighlightColor)),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: TextFormField(
                    controller: textController3,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono', color: backgroundHighlightColor),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: backgroundHighlightColor)),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: 'XXXXXX',
                      hintStyle: TextStyle(fontSize: 30, color: backgroundHighlightColor)),
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200],
                      splashColor: Colors.grey,
                      padding: 10,
                      fontSize: 24,
                    ),
                    SizedBox(width: 25,),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: Colors.pink[200],
                      splashColor: Colors.pink,
                      padding: 10,
                      fontSize: 24,
                    ),
                  ],
                ),
                SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PAOTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Timed Test',
      information: ['    Time to recall your story! If you recall this correctly, you\'ll '
        'unlock the next system! Good luck!'],
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
      firstHelpKey: paoTimedTestFirstHelpKey,
    );
  }
}
