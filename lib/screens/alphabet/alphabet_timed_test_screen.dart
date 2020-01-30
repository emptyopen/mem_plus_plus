import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/services/prefs_services.dart';

class AlphabetTimedTestScreen extends StatefulWidget {
  final Function() callback;

  AlphabetTimedTestScreen({this.callback});

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // grab the digits
      char1 = prefs.getString('alphabetTestChar1');
      char2 = prefs.getString('alphabetTestChar2');
      char3 = prefs.getString('alphabetTestChar3');
      char4 = prefs.getString('alphabetTestChar4');
      char5 = prefs.getString('alphabetTestChar5');
      char6 = prefs.getString('alphabetTestChar6');
      char7 = prefs.getString('alphabetTestChar7');
      char8 = prefs.getString('alphabetTestChar8');
      print('real answer: $char1$char2$char3$char4 $char5$char6$char7$char8');
    });
  }

  void checkAnswer() async {
    if (textController1.text.toLowerCase().trim() ==
            '$char1$char2$char3$char4'.toLowerCase() &&
        textController2.text.toLowerCase().trim() == '$char5$char6$char7$char8'.toLowerCase()) {
      print('success');
      await prefs.updateLevel(7);
      await prefs.updateActivityState('AlphabetTimedTest', 'review');
      await prefs.updateActivityVisible('AlphabetTimedTest', false);
      await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
      await prefs.updateActivityVisible('PAOEdit', true);
      await prefs.updateActivityVisible('PAOPractice', true);
      await prefs.updateActivityFirstView('PAOEdit', true);
      await prefs.updateActivityFirstView('PAOPractice', true);
      widget.callback();
    } else {
      print('failure');
    }
    textController1.text = '';
    textController2.text = '';
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alphabet: timed test'), actions: <Widget>[
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
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all()),
              child: FlatButton(
                  onPressed: () => checkAnswer(),
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 30),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class AlphabetTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Text(
                        '    Time to recall your story! \n    If you recall this correctly, you\'ll '
                        'unlock the next system! Good luck!',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  PopButton(
                    widget: Text('OK'),
                    color: Colors.amber[300],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
