import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';
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

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
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
                    return SingleDigitFlashCardScreenHelp();
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
        children: getSingleDigitFlashCards(),
      )),
    );
  }
}

class SingleDigitFlashCardScreenHelp extends StatelessWidget {
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
