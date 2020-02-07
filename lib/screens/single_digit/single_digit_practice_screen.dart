import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';

class SingleDigitPracticeScreen extends StatefulWidget {
  final Function() callback;

  SingleDigitPracticeScreen({this.callback});

  @override
  _SingleDigitPracticeScreenState createState() =>
      _SingleDigitPracticeScreenState();
}

class _SingleDigitPracticeScreenState extends State<SingleDigitPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<SingleDigitData> singleDigitData;
  String singleDigitKey = 'SingleDigit';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'SingleDigitPracticeFirstHelp', SingleDigitPracticeScreenHelp());
    if (await prefs.getString(singleDigitKey) == null) {
      singleDigitData = defaultSingleDigitData;
      await prefs.setString(singleDigitKey, json.encode(singleDigitData));
    } else {
      singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    }
    singleDigitData = shuffle(singleDigitData);
    setState(() {});
  }

  callback() {
    widget.callback();
  }

  List<SingleDigitFlashCard> getSingleDigitFlashCards() {
    List<SingleDigitFlashCard> singleDigitFlashCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        SingleDigitFlashCard singleDigitFlashCard = SingleDigitFlashCard(
          singleDigitEntry: singleDigitData[i],
          callback: callback,
        );
        singleDigitFlashCards.add(singleDigitFlashCard);
      }
    }
    return singleDigitFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single digit: practice'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return SingleDigitPracticeScreenHelp();
                  }));
            },
          ),
        ],
        backgroundColor: Colors.amber[200],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: Center(
          child: ListView(
        children: getSingleDigitFlashCards(),
      )),
    );
  }
}

class SingleDigitPracticeScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to your first practice! Since you have a complete set of single digits mapped out, you\'re '
        'now ready to get started with practice! \n    Here you will familiarize yourself '
        'with the digit-object mapping until you\'ve maxed out your '
        'familiarity with each digit, upon which the first test will be unlocked! ',
    '    Try to guess the object before even hitting the reveal button! It\'ll help you once you really get tested ;)'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: information,
    );
  }
}
