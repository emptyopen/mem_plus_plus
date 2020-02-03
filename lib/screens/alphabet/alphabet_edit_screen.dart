import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_edit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/services/services.dart';

class AlphabetEditScreen extends StatefulWidget {
  AlphabetEditScreen({Key key}) : super(key: key);

  @override
  _AlphabetEditScreenState createState() => _AlphabetEditScreenState();
}

class _AlphabetEditScreenState extends State<AlphabetEditScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  String alphabetKey = 'Alphabet';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    await prefs.checkFirstTime(context, 'AlphabetEditFirstHelp', AlphabetEditScreenHelp());
    if (await prefs.getString(alphabetKey) == null) {
      alphabetData = defaultAlphabetData;
      prefs.setString(alphabetKey, json.encode(alphabetData));
    } else {
      alphabetData = await prefs.getSharedPrefs(alphabetKey);
    }
    setState(() {});
  }

  callback(newAlphabetData) {
    setState(() {
      alphabetData = newAlphabetData;
    });
  }

  List<AlphabetEditCard> getAlphabetEditCards() {
    List<AlphabetEditCard> alphabetViews = [];
    if (alphabetData != null) {
      for (int i = 0; i < alphabetData.length; i++) {
        AlphabetEditCard alphabetEditCard = AlphabetEditCard(
          alphabetData: AlphabetData(alphabetData[i].index, alphabetData[i].letter,
              alphabetData[i].object, alphabetData[i].familiarity),
          callback: callback,
        );
        alphabetViews.add(alphabetEditCard);
      }
    }
    return alphabetViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alphabet: view/edit'), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return AlphabetEditScreenHelp();
                }));
          },
        ),
      ]),
      body: Center(
          child: ListView(
        children: getAlphabetEditCards(),
      )),
    );
  }
}

class AlphabetEditScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: ['    OK! Welcome to the 2nd system here at Takao Studios :) \n\n'
        '    What we\'re going to do here is just like last time, now with letters of '
        'the alphabet! '],
    );
  }
}
