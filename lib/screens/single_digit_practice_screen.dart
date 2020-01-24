import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import 'package:mem_plus_plus/components/standard.dart';

class SingleDigitPracticeScreen extends StatefulWidget {
  SingleDigitPracticeScreen({Key key}) : super(key: key);

  @override
  _SingleDigitPracticeScreenState createState() =>
      _SingleDigitPracticeScreenState();
}

class _SingleDigitPracticeScreenState extends State<SingleDigitPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<SingleDigitData> singleDigitData;
  String singleDigitKey = 'singleDigit';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // assume data exists
    singleDigitData = (json.decode(prefs.getString(singleDigitKey)) as List)
        .map((i) => SingleDigitData.fromJson(i))
        .toList();
    setState(() {
      singleDigitData = shuffle(singleDigitData);
    });
  }

  List<SingleDigitFlashCard> getSingleDigitFlashCards() {
    List<SingleDigitFlashCard> singleDigitFlashCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        SingleDigitFlashCard singleDigitFlashCard = SingleDigitFlashCard(
          singleDigitData: singleDigitData[i],
        );
        singleDigitFlashCards.add(singleDigitFlashCard);
      }
    }
    return singleDigitFlashCards;
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
      appBar: AppBar(title: Text('Single digit: practice'), actions: <Widget>[
        // action button
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
      ]),
      body: Center(
          child: ListView(
        children: getSingleDigitFlashCards(),
      )),
    );
  }
}

class SingleDigitPracticeScreenHelp extends StatelessWidget {
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
                        '    Welcome to your first system practice! \n\n'
                        '    In this section, you will increase your familiarity with '
                        'each digit. Familiarity is scored from 0 to 100. \n    Every time '
                        'you load this page, the digits will be scattered in a random order, '
                        'and you simply have to recall the object before pressing "Show", like a flashcard. If '
                        'you knew what the object was successfully, hit "Got it", and if you '
                        'missed it, "Didn\'t got it". \n    Once your familiarity with each '
                        'digit maxes out, you will be tested! So don\'t cheat ;) When '
                        'you pass the test, the next system will be unlocked!',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
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
