import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_multiple_choice_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:math';

class SingleDigitMultipleChoiceTestScreen extends StatefulWidget {
  final Function() callback;

  SingleDigitMultipleChoiceTestScreen({this.callback});

  @override
  _SingleDigitMultipleChoiceTestScreenState createState() =>
      _SingleDigitMultipleChoiceTestScreenState();
}

class _SingleDigitMultipleChoiceTestScreenState
    extends State<SingleDigitMultipleChoiceTestScreen> {
  SharedPreferences sharedPreferences;
  List<SingleDigitData> singleDigitData;
  String singleDigitKey = 'SingleDigit';
  int score = 0;
  int attempts = 0;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      singleDigitData = (json.decode(prefs.getString(singleDigitKey)) as List)
          .map((i) => SingleDigitData.fromJson(i))
          .toList();
      singleDigitData = shuffle(singleDigitData);
    });
  }

  void callback(BuildContext context, bool success) {
    if (success) {
      score += 1;
      if (score == 10) {
        final snackBar = SnackBar(
          content: Text(
            'You aced it! Head to the main menu to see what you\'ve unlocked!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 10),
          backgroundColor: Colors.black,
        );
        Scaffold.of(context).showSnackBar(snackBar);
      }
    }
    attempts += 1;

    if (attempts == 10 && score < 10) {
      final snackBar = SnackBar(
        content: Text(
          'Try again! You got this. Score: $score/10',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        // TODO: add action here for quick redo
        duration: Duration(seconds: 10),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  List<SingleDigitMultipleChoiceCard> getSingleDigitMultipleChoiceCards() {
    List<SingleDigitMultipleChoiceCard> singleDigitMultipleChoiceCards = [];
    if (singleDigitData != null) {
      for (int i = 0; i < singleDigitData.length; i++) {
        SingleDigitMultipleChoiceCard singleDigitView =
            SingleDigitMultipleChoiceCard(
          singleDigitData: SingleDigitData(singleDigitData[i].digits,
              singleDigitData[i].object, singleDigitData[i].familiarity),
          callback: callback,
        );
        singleDigitMultipleChoiceCards.add(singleDigitView);
      }
    }
    return singleDigitMultipleChoiceCards;
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
          title: Text('Single digit: multiple choice test'),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return SingleDigitMultipleChoiceScreenHelp();
                    }));
              },
            ),
          ]),
      body: Center(
          child: ListView(
        children: getSingleDigitMultipleChoiceCards(),
      )),
    );
  }
}

class SingleDigitMultipleChoiceScreenHelp extends StatelessWidget {
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
                        '    Welcome to your first multiple choice test! \n\n'
                        '    In this section, you will be tested on your familiarity with '
                        'each digit. Every time you load this page, the digits will be scattered in a random order, '
                        'and you simply have to choose the correct object. If you get a perfect score, '
                        'the next system will be unlocked! Good luck!',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
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
