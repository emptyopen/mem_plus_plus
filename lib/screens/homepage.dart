import 'package:flutter/material.dart';
import 'package:mem_plus_plus/screens/paoEditScreen.dart';
import 'package:mem_plus_plus/screens/paoPracticeScreen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO:

class _MyHomePageState extends State<MyHomePage> {
  double headerSize = 30;
  double itemSize = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MEM++ Homepage'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'TODO:',
                style: TextStyle(fontSize: headerSize),
              ),
              Container(
                height: 10,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PAOEditScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      'PAO Edit',
                      style: TextStyle(fontSize: itemSize),
                    ),
                  )),
              FlatButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PAOPracticeScreen()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    'PAO Practice',
                    style: TextStyle(fontSize: itemSize),
                  ),
                )
              ),
              Container(
                height: 30,
              ),
              Text(
                'Review:',
                style: TextStyle(fontSize: headerSize),
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
