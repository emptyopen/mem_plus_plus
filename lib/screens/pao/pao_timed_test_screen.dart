import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';

class PAOTimedTestScreen extends StatefulWidget {
  final Function() callback;

  PAOTimedTestScreen({this.callback});

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
  String paoTestActiveKey = 'PAOTestActive';
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
      print('success');
      // await prefs.updateLevel(7);
      await prefs.updateActivityState('PAOTimedTest', 'review');
      await prefs.updateActivityVisible('PAOTimedTest', false);
      await prefs.updateActivityVisible('PAOTimedTestPrep', true);
      // TODO: next stuff!
      widget.callback();
    } else {
      print('failure');
      // TODO: snackbar on homescreen?
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PAO: timed test'), actions: <Widget>[
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 25,),
              Container(
                child: Text(
                  'Enter the digits: ',
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
                      hintText: 'XXXXXX',
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
                      hintText: 'XXXXXX',
                      hintStyle: TextStyle(fontSize: 30)),
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
                  style: TextStyle(fontSize: 30, fontFamily: 'SpaceMono'),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: 'XXXXXX',
                    hintStyle: TextStyle(fontSize: 30)),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(side: BorderSide(), borderRadius: BorderRadius.circular(5)),
                    color: Colors.grey[200],
                    onPressed: () => giveUp(),
                    child: Text(
                      'Give up',
                      style: TextStyle(fontSize: 30),
                    )),
                  SizedBox(width: 25,),
                  FlatButton(
                    shape: RoundedRectangleBorder(side: BorderSide(), borderRadius: BorderRadius.circular(5)),
                    color: Colors.amber[100],
                    onPressed: () => checkAnswer(),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 30),
                    )),
                ],
              ),
              SizedBox(height: 50,)
            ],
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
      information: ['    Time to recall your story! If you recall this correctly, you\'ll '
        'unlock the next system! Good luck!'],
    );
  }
}