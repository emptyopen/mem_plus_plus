import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';

class AlphabetPracticeScreen extends StatefulWidget {
  final Function() callback;

  AlphabetPracticeScreen({this.callback});

  @override
  _AlphabetPracticeScreenState createState() =>
      _AlphabetPracticeScreenState();
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  String alphabetKey = 'Alphabet';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString(alphabetKey) == null) {
        print('defaulting alphabet');
        alphabetData = defaultAlphabetData;
        prefs.setString(alphabetKey, json.encode(alphabetData));
      } else {
        print('found alphabet');
        alphabetData = (json.decode(prefs.getString(alphabetKey)) as List)
          .map((i) => AlphabetData.fromJson(i))
          .toList();
      }
      alphabetData = shuffle(alphabetData);
    });
  }

  callback() {
    widget.callback();
  }

  List<AlphabetFlashCard> getAlphabetFlashCards() {
    List<AlphabetFlashCard> alphabetFlashCards = [];
    if (alphabetData != null) {
      for (int i = 0; i < alphabetData.length; i++) {
        AlphabetFlashCard alphabetFlashCard = AlphabetFlashCard(
          alphabetEntry: alphabetData[i],
          callback: callback,
        );
        alphabetFlashCards.add(alphabetFlashCard);
      }
    }
    return alphabetFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alphabet: practice'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return AlphabetFlashCardScreenHelp();
                  }));
            },
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: Center(
          child: ListView(
        children: getAlphabetFlashCards(),
      )),
    );
  }
}

class AlphabetFlashCardScreenHelp extends StatelessWidget {
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
                        '    Welcome to your first system! \n\n'
                        '    The idea behind this system is to link the 9 digits to different objects. '
                        'Numbers are abstract and difficult to remember, but if we take a number '
                        'and convert it to an image, especially a strange image, it suddenly '
                        'becomes much easier to remember. \n    The default values I\'ve inserted here uses the '
                        'idea of a "shape" pattern. That is, each object corresponds to what the '
                        'actual digit it represents is shaped like. For example, 0 looks like a '
                        'ball, 1 like a baseball bat, etc. Another pattern could be "rhyming". 0 could be '
                        'hero, 1 could be bread (bun), etc. \n    You can really assign anything '
                        'to any digit, it just makes it easier to remember (initially) if you have some kind of pattern. '
                        'Make sure that the objects don\'t overlap conceptually, as much as possible! And don\'t forget, '
                        'when you edit a digit, that will reset your familiarity for that object back to zero! '
                        'Familiarity is listed on the far right of the tiles. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  PopButton(
                    widget: Text('OK'),
                    color: Colors.amber,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
