import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class PAOPracticeScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  PAOPracticeScreen({this.callback, this.globalKey});

  @override
  _PAOPracticeScreenState createState() => _PAOPracticeScreenState();
}

class _PAOPracticeScreenState extends State<PAOPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    paoData = await prefs.getSharedPrefs(paoKey);
    setState(() {});
  }

  callback() {
    widget.callback();
  }

  void nextActivity() async {
    await prefs.updateActivityState('PAOEdit', 'review');
    await prefs.updateActivityState('PAOPractice', 'review');
    await prefs.updateActivityFirstView('PAOMultipleChoiceTest', true);
    await prefs.updateActivityVisible('PAOMultipleChoiceTest', true);
    await prefs.setBool('PAOPracticeComplete', true);
    widget.callback();
  }

  List<FlashCard> getPAOFlashCards() {
    List<FlashCard> paoFlashCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        FlashCard paoFlashCard = FlashCard(
          entry: paoData[i],
          callback: callback,
          globalKey: widget.globalKey,
          activityKey: 'PAO',
          nextActivityCallback: nextActivity,
          familiarityTotal: 10000,
          color: colorPAODarker,
        );
        paoFlashCards.add(paoFlashCard);
      }
    }
    return paoFlashCards;
  }

  List shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAO: practice'),
        backgroundColor: Colors.pink[200],
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return PAOPracticeScreenHelp();
                }));
            },
          ),
        ]
      ),
      body: Center(
          child: ListView(
        children: getPAOFlashCards(),
      )),
    );
  }
}

class PAOPracticeScreenHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'PAO Practice',
      information: ['    Get perfect familiarities for each set of digits and '
        'the first test will be unlocked! Good luck!'],
      buttonColor: Colors.pink[100],
      buttonSplashColor: Colors.pink[300],
    );
  }
}