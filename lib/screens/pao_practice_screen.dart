import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class PAOPracticeScreen extends StatefulWidget {
  PAOPracticeScreen({Key key}) : super(key: key);

  @override
  _PAOPracticeScreenState createState() => _PAOPracticeScreenState();
}

class _PAOPracticeScreenState extends State<PAOPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  String paoKey = 'pao';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // assume data exists
    paoData = (json.decode(prefs.getString(paoKey)) as List)
          .map((i) => PAOData.fromJson(i))
          .toList();
    setState(() {
      paoData = shuffle(paoData);
    });
  }

  List<PAOFlashCard> getPAOFlashCards() {
    List<PAOFlashCard> paoFlashCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOFlashCard paoFlashCard = PAOFlashCard(paoData: paoData[i],);
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
      ),
      body: Center(
        child: ListView(
          children: getPAOFlashCards(),
        )),
    );
  }
}
