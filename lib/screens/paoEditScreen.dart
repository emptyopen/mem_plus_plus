import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao.dart';
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
      print('found existing');
      setState(() {
        paoData = (json.decode(prefs.getString(paoKey)) as List)
          .map((i) => PAOData.fromJson(i))
          .toList();
      });
    } else {
      print('setting to default');
      setState(() {
        paoData = defaultPAOData;
        prefs.setString(paoKey, json.encode(paoData));
      });
    }
  }

  List<PAOView> getPAOViews() {
    List<PAOView> paoViews = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOView paoView = PAOView(
          paoData: PAOData(paoData[i].digits, paoData[i].person,
            paoData[i].action, paoData[i].object, paoData[i].familiarity),
          callback: callback,
        );
        paoViews.add(paoView);
      }
    }
    return paoViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PAO: edit'),
      ),
      body: Center(
        child: ListView(
          children: getPAOViews(),
        )),
    );
  }
}
