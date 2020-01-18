import 'package:flutter/material.dart';
import 'package:mem_plus_plus/screens/pao.dart';
import 'package:mem_plus_plus/models/PAOData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  String spKey = 'test';
  PAOData paoData1 = new PAOData('00', 'Ozzy Osbourne', 'rocking out a concert', 'rock guitar', 10);
  PAOData paoData2 = new PAOData('01', 'Prairie Johnson', 'dancing metaphorically', 'halo', 40);
  PAOData paoData3 = new PAOData('02', 'Orlando Bloom', 'walking the plank', 'pirate sword / eyepatch', 70);
  PAOData paoData4 = new PAOData('03', 'Thomas Nguyenfa', 'jetskiing', 'jetski, pharmacy drugs', 90);
  var defaultPAOData = [
    PAOData('00', 'Ozzy Osbourne', 'rocking out a concert', 'rock guitar', 0),
    PAOData('00', 'Ozzy Osbourne', 'rocking out a concert', 'rock guitar', 0),
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      paoData = json.decode(prefs.getString(spKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    print('testing testing');
    print(paoData);
    return Scaffold(
      appBar: AppBar(
        title: Text('MEM++ Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PAOView(paoData: paoData1,),
            PAOView(paoData: paoData2,),
            PAOView(paoData: paoData3,),
            PAOView(paoData: paoData4,),
          ],
        ),
      ),
    );
  }
}
