import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';

import 'package:mem_plus_plus/screens/welcome_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_edit_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_practice_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_edit_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_practice_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO: implement timed tests, leveling up integration testing

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  List<String> availableActivities = [];
  String levelKey = 'level';
  Map<String, Activity> activityStates = {};
  String activityStatesKey = 'activityStates';
  double headerSize = 30;
  double itemSize = 24;
  Map activityMenuButtonMap;

  var unlockMap = {
    0: ['Welcome'],
    1: ['SingleDigitEdit', 'SingleDigitPractice'],
    2: ['SingleDigitMultipleChoiceTest'],
    3: ['SingleDigitTimedTestPrep', 'SingleDigitTimedTest'],
    4: ['AlphabetEdit', 'AlphabetPractice'],
    5: ['AlphabetMultipleChoiceTest'],
    6: ['AlphabetTimedTestPrep', 'AlphabetTimedTest'],
    7: ['PAOEdit', 'PAOPractice'],
    8: ['PAOTestMultipleChoiceTest', 'PAOTimedTestPrep', 'PAOTimedTest'],
    9: ['FaceTestPrep', 'FaceTest'],
    // premium paywall here?
    10: ['DeckEdit', 'DeckPractice'],
    11: ['DeckMultipleChoiceTest', 'DeckTimedTestPrep', 'DeckTimedTest'],
  };

  @override
  void initState() {
    super.initState();
    getSharedPrefs();

    // TODO: integrate this into the actual activityState model?
    activityMenuButtonMap = {
      'Welcome': ActivityMenuButton(
          text: Text(
            'Welcome',
            style: TextStyle(fontSize: 24),
          ),
          route: WelcomeScreen(),
          icon: Icon(Icons.filter),
          color: Colors.green[100]),
      'SingleDigitEdit': ActivityMenuButton(
          text: Text(
            'Single Digit [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitEditScreen(),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[100]),
      'SingleDigitPractice': ActivityMenuButton(
          text: Text(
            'Single Digit [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitPracticeScreen(
            parentCallback: callback,
          ),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[200]),
      'SingleDigitMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'Single Digit [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitMultipleChoiceTestScreen(),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[300]),
      'SingleDigitTimedTestPrep': ActivityMenuButton(
        text: Text(
          'Single Digit [Timed Test]',
          style: TextStyle(fontSize: 23),
        ),
        route: SingleDigitTimedTestPrepScreen(),
        icon: Icon(Icons.filter_1),
        color: Colors.amber[400]),
      'PAOEdit': ActivityMenuButton(
          text: Text(
            'PAO [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOEditScreen(),
          icon: Icon(Icons.filter_2),
          color: Colors.blue[100]),
      'PAOPractice': ActivityMenuButton(
          text: Text(
            'PAO [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOPracticeScreen(),
          icon: Icon(Icons.filter_2),
          color: Colors.blue[200]),
    };
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // level
    if (false) {
      prefs.remove(levelKey);
    }
    if (false) {
      prefs.remove(activityStatesKey);
    }
    if (prefs.getKeys().contains(levelKey)) {
      setState(() {
        level = prefs.getInt(levelKey);
        print('found existing level: $level');
      });
    } else {
      int defaultLevel = 1;
      print('setting level to default, $defaultLevel');
      setState(() {
        // TODO: temporary, should be 0
        prefs.setInt(levelKey, defaultLevel);
        level = defaultLevel;
      });
    }

    // activity states, and unlockedActivities
    if (prefs.getKeys().contains(activityStatesKey)) {
      print('found existing activity states');
      setState(() {
        var rawMap = json.decode(prefs.getString(activityStatesKey))
            as Map<String, dynamic>;
        activityStates =
            rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
      });
    } else {
      print('setting activity states to default');
      setState(() {
        activityStates = defaultActivityStates;
        prefs.setString(
            activityStatesKey,
            json.encode(
              activityStates.map((k, v) => MapEntry(k, v.toJson())),
            ));
      });
    }

    // set unlocked activites
    setUnlockedActivities();
  }

  void setUnlockedActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    level = prefs.getInt(levelKey);
    var rawMap = json.decode(prefs.getString(activityStatesKey))
    as Map<String, dynamic>;
    activityStates =
      rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
    var unlockedActivities = [];
    setState(() {
      // filter unlocked activities by level
      for (var activity_groups
          in unlockMap.keys.toList().sublist(0, level + 1)) {
        for (String activity in unlockMap[activity_groups]) {
          unlockedActivities.add(activity);
        }
      }

      // iterate through unlocked activities, and check if they are visible
      availableActivities = [];
      for (String activityName in unlockedActivities) {
        // TODO: also check datetime
        if (activityStates[activityName].visible) {
          availableActivities.add(activityName);
        }
      }
    });

    print('unlocked activities: $unlockedActivities');
    print('available activites: $availableActivities');
  }

  callback(int newLevel) {
    print('wow got it');
    setState(() {
      level = newLevel;
      setUnlockedActivities();
    });
  }

  List<Widget> getTodo() {
    List<MainMenuOption> mainMenuOptions = [];
    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'todo') {
        mainMenuOptions.add(MainMenuOption(
          text: activityMenuButtonMap[activity].text,
          route: activityMenuButtonMap[activity].route,
          icon: activityMenuButtonMap[activity].icon,
          color: activityMenuButtonMap[activity].color,
          firstView: activityStates[activity].firstView,
        ));
      }
    }
    return mainMenuOptions;
  }

  List<Widget> getReview() {
    List<MainMenuOption> mainMenuOptions = [];
    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'review') {
        mainMenuOptions.add(MainMenuOption(
          text: activityMenuButtonMap[activity].text,
          route: activityMenuButtonMap[activity].route,
          icon: activityMenuButtonMap[activity].icon,
          color: activityMenuButtonMap[activity].color,
          firstView: activityStates[activity].firstView,
        ));
      }
    }
    return mainMenuOptions;
  }

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
              Column(
                children: getTodo(),
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
              Column(
                children: getReview(),
              ),
            ],
          ),
        ));
  }
}
