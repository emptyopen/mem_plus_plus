import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';

class PAOPracticeScreen extends StatefulWidget {
  final Function() callback;

  PAOPracticeScreen({this.callback});

  @override
  _PAOPracticeScreenState createState() => _PAOPracticeScreenState();
}

class _PAOPracticeScreenState extends State<PAOPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  String paoKey = 'PAO';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'PAOPracticeFirstHelp', PAOPracticeScreenHelp());
    if (await prefs.getString(paoKey) == null) {
      paoData = defaultPAOData;
      await prefs.setString(paoKey, json.encode(paoData));
    } else {
      paoData = await prefs.getSharedPrefs(paoKey);
    }
    setState(() {});
  }

  callback() {
    widget.callback();
  }

  List<PAOFlashCard> getPAOFlashCards() {
    List<PAOFlashCard> paoFlashCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOFlashCard paoFlashCard = PAOFlashCard(
          paoEntry: paoData[i],
          callback: callback,
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
      information: ['    Get perfect familiarities for each set of digits and '
        'the first test will be unlocked! Good luck!'],
    );
  }
}