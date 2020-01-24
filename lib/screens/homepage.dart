import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/screens/welcome_screen.dart';
import 'package:mem_plus_plus/screens/single_digit_edit_screen.dart';
import 'package:mem_plus_plus/screens/single_digit_practice_screen.dart';
import 'package:mem_plus_plus/screens/pao_edit_screen.dart';
import 'package:mem_plus_plus/screens/pao_practice_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO: generalize component like the flatbutton with default arguments
// pulse animator for beginning skip option

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
                'To-do:',
                style: TextStyle(fontSize: headerSize),
              ),
              Container(
                height: 10,
              ),
              MainMenuOption(
                icon: Icon(Icons.filter_1),
                text: 'Single Digit [View/Edit]',
                color: Colors.amber[100],
                route: SingleDigitEditScreen(),
                fontSize: itemSize,
              ),
              MainMenuOption(
                icon: Icon(Icons.filter_1),
                text: 'Single Digit [Practice]',
                color: Colors.amber[200],
                route: SingleDigitPracticeScreen(),
                fontSize: itemSize,
              ),
              MainMenuOption(
                icon: Icon(Icons.filter_2),
                text: 'PAO [View/Edit]',
                color: Colors.blue[100],
                route: PAOEditScreen(),
                fontSize: itemSize,
              ),
              MainMenuOption(
                icon: Icon(Icons.filter_2),
                text: 'PAO [Practice]',
                color: Colors.blue[200],
                route: PAOPracticeScreen(),
                fontSize: itemSize,
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
              MainMenuOption(
                icon: Icon(Icons.filter),
                text: 'Welcome',
                color: Colors.green[100],
                route: WelcomeScreen(),
                fontSize: itemSize,
              ),
            ],
          ),
        ));
  }
}
