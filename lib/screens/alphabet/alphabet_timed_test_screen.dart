import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';

class AlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final Function callbackSnackbar;

  AlphabetTimedTestScreen({this.callback, this.callbackSnackbar});

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
  String alphabetTestActiveKey = 'AlphabetTestActive';
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
      await prefs.updateActivityState('AlphabetTimedTest', 'review');
      await prefs.updateActivityVisible('AlphabetTimedTest', false);
      await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
      if (await prefs.getBool('AlphabetTimedTestComplete') == null) {
        await prefs.updateActivityVisible('PAOEdit', true);
        await prefs.updateActivityFirstView('PAOEdit', true);
        await prefs.setBool('AlphabetTimedTestComplete', true);
      }
      widget.callbackSnackbar('Congratulations! You\'ve unlocked the PAO system!', Colors.white, Colors.pink, 5);
    } else {
      widget.callbackSnackbar('Incorrect. Keep trying to remember, or give up and try again!', Colors.white, Colors.red, 4);
    }
    textController1.text = '';
    textController2.text = '';
    Navigator.pop(context);
    widget.callback();
    widget.callback();
  }

  void giveUp() async {
    await prefs.updateActivityState('AlphabetTimedTest', 'review');
    await prefs.updateActivityVisible('AlphabetTimedTest', false);
    await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
    if (await prefs.getBool('AlphabetTimedTestComplete') == null) {
      await prefs.updateActivityState('AlphabetTimedTestPrep', 'todo');
    }
    widget.callbackSnackbar('Try the timed test again to unlock the next system.', Colors.white, Colors.red, 3);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text(
                'Enter the characters: ',
                style: TextStyle(fontSize: 30),
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
                style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: 'XXXX',
                    hintStyle: TextStyle(fontSize: 30)),
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
                style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: 'XXXX',
                    hintStyle: TextStyle(fontSize: 30)),
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
                SizedBox(width: 10,),
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
          ],
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
    );
  }
}
