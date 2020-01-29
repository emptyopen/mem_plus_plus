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

class _AlphabetTimedTestScreenState
    extends State<AlphabetTimedTestScreen> {
  String digit1 = '';
  String digit2 = '';
  String digit3 = '';
  String digit4 = '';
  String alphabetTestActiveKey = 'AlphabetTestActive';
  final textController = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    textController.dispose();
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
      digit1 = prefs.getString('alphabetTestDigit1');
      digit2 = prefs.getString('alphabetTestDigit2');
      digit3 = prefs.getString('alphabetTestDigit3');
      digit4 = prefs.getString('alphabetTestDigit4');
      print('real answer: $digit1$digit2$digit3$digit4');
    });
  }

  void checkAnswer() async {
    print('testing: $digit1$digit2$digit3$digit4 vs ${textController.text}');
    if (textController.text == '$digit1$digit2$digit3$digit4') {
      await prefs.updateLevel(4);
      await prefs.updateActivityState('AlphabetTimedTest', 'review');
      await prefs.updateActivityVisible('AlphabetTimedTest', false);
      await prefs.updateActivityVisible('AlphabetTimedTestPrep', true);
      widget.callback();
      final snackBar = SnackBar(
        content: Text(
          'Awesome Job! Head back to the main menu to check out the new system you\'ve unlocked!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.black,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      print('failure');
    }
    textController.text = '';
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single digit: timed test'), actions: <Widget>[
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
                'Enter the number: ',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: TextFormField(
                controller: textController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
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
