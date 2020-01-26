import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_edit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PAOEditScreen extends StatefulWidget {
  PAOEditScreen({Key key}) : super(key: key);

  @override
  _PAOEditScreenState createState() => _PAOEditScreenState();
}

class _PAOEditScreenState extends State<PAOEditScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  String paoKey = 'pao';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  callback(newPaoData) {
    setState(() {
      paoData = newPaoData;
    });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains(paoKey)) {
      print('found existing paoData');
      setState(() {
        paoData = (json.decode(prefs.getString(paoKey)) as List)
          .map((i) => PAOData.fromJson(i))
          .toList();
      });
    } else {
      print('setting paoData to default');
      setState(() {
        paoData = defaultPAOData;
        prefs.setString(paoKey, json.encode(paoData));
      });
    }
  }

  List<PAOEditCard> getPAOEditCards() {
    List<PAOEditCard> paoEditCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOEditCard paoEditCard = PAOEditCard(
          paoData: PAOData(paoData[i].digits, paoData[i].person,
            paoData[i].action, paoData[i].object, paoData[i].familiarity),
          callback: callback,
        );
        paoEditCards.add(paoEditCard);
      }
    }
    return paoEditCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAO: view/edit'),
      ),
      body: Center(
        child: ListView(
          children: getPAOEditCards(),
        )),
    );
  }
}
