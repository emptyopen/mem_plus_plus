import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/screens/welcome_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_edit_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_practice_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/single_digit/single_digit_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/alphabet/alphabet_edit_screen.dart';
import 'package:mem_plus_plus/screens/alphabet/alphabet_practice_screen.dart';
import 'package:mem_plus_plus/screens/alphabet/alphabet_written_test_screen.dart';
import 'package:mem_plus_plus/screens/alphabet/alphabet_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/alphabet/alphabet_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_edit_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_practice_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/pao/pao_timed_test_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO: add notifications about newly available activities
// TODO: add dot and dot-dot vibration for correct/incorrect answers

// Nice to have
// TODO: implement length limits for inputs (like action/object)
// TODO: make PAO multiple choice tougher with similar digits
// TODO: fix all flatbuttons
// TODO: consolidate more stuff (like entire sections - edit,practice,mc,timed)

class _MyHomePageState extends State<MyHomePage> {
  int level = 0;
  String levelKey = 'Level';
  Map<String, Activity> activityStates = {};
  String activityStatesKey = 'ActivityStates';
  List<String> availableActivities = [];
  double headerSize = 30;
  double itemSize = 24;
  Map activityMenuButtonMap;

  var unlockMap = {
    0: ['Welcome'],
    1: ['SingleDigitEdit', 'SingleDigitPractice'],
    2: ['SingleDigitMultipleChoiceTest'],
    3: ['SingleDigitTimedTestPrep', 'SingleDigitTimedTest'],
    4: ['AlphabetEdit', 'AlphabetPractice'],
    5: ['AlphabetWrittenTest'],
    6: ['AlphabetTimedTestPrep', 'AlphabetTimedTest'],
    7: ['PAOEdit', 'PAOPractice'],
    8: ['PAOMultipleChoiceTest',],
    9: ['PAOTimedTestPrep', 'PAOTimedTest'],
    10: ['FaceTestPrep', 'FaceTest'],
    // premium paywall here?
    11: ['DeckEdit', 'DeckPractice'],
    12: ['DeckMultipleChoiceTest', 'DeckTimedTestPrep', 'DeckTimedTest'],
  };

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    initializeActivityMenuButtonMap();
    new Timer.periodic(Duration(seconds: 1), (Timer t) => setState((){}));
  }

  resetKeys() async {
    int defaultLevel = 7;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(levelKey);
    prefs.remove(activityStatesKey);
    setState(() {
      prefs.setInt(levelKey, defaultLevel);
      level = defaultLevel;
      activityStates = defaultActivityStates2;
      prefs.setString(
        activityStatesKey,
        json.encode(
          activityStates.map((k, v) => MapEntry(k, v.toJson())),
        )
      );
    });

    setUnlockedActivities();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('AlphabetData');
    // level
    if (prefs.getKeys().contains(levelKey)) {
      setState(() {
        level = prefs.getInt(levelKey);
        print('found existing level: $level');
      });
    } else {
      int defaultLevel = 1;
      print('setting level to default, $defaultLevel');
      setState(() {
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
        activityStates = defaultActivityStates2;
        prefs.setString(
          activityStatesKey,
          json.encode(
            activityStates.map((k, v) => MapEntry(k, v.toJson())),
          )
        );
      });
    }

    // set unlocked activities
    setUnlockedActivities();
  }

  void setUnlockedActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    level = prefs.getInt(levelKey);
    var rawMap =
        json.decode(prefs.getString(activityStatesKey)) as Map<String, dynamic>;
    activityStates = rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
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
        if (activityStates[activityName].visible) {
          availableActivities.add(activityName);
        }
      }
    });
  }

  callback() {
    setUnlockedActivities();
    print(activityStates.map((k, v) => MapEntry(k, '${v.state} | ${v.visible} | ${v.firstView}')));
  }

  List<Widget> getTodo() {
    List<MainMenuOption> mainMenuOptions = [];
    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'todo') {
        mainMenuOptions.add(MainMenuOption(
          callback: callback,
          activity: activityStates[activity],
          text: activityMenuButtonMap[activity].text,
          route: activityMenuButtonMap[activity].route,
          icon: activityMenuButtonMap[activity].icon,
          color: activityMenuButtonMap[activity].color,
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
          callback: callback,
          activity: activityStates[activity],
          text: activityMenuButtonMap[activity].text,
          route: activityMenuButtonMap[activity].route,
          icon: activityMenuButtonMap[activity].icon,
          color: activityMenuButtonMap[activity].color,
        ));
      }
    }
    mainMenuOptions = mainMenuOptions.reversed.toList();
    return mainMenuOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MEM++ Homepage'),
        ),
        body: SingleChildScrollView(
          child: Container(
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
                FlatButton(
                  onPressed: () => resetKeys(),
                  child: Text('reset'),
                )
              ],
            ),
          ),
        ));
  }

  void initializeActivityMenuButtonMap() {
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
            callback: callback,
          ),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[200]),
      'SingleDigitMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'Single Digit [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[300]),
      'SingleDigitTimedTestPrep': ActivityMenuButton(
          text: Text(
            'Single Digit [Timed Test Prep]',
            style: TextStyle(fontSize: 19),
          ),
          route: SingleDigitTimedTestPrepScreen(
            callback: callback,
          ),
          icon: Icon(Icons.filter_1),
          color: Colors.amber[400]),
      'SingleDigitTimedTest': ActivityMenuButton(
        text: Text(
          'Single Digit [Timed Test]',
          style: TextStyle(fontSize: 22),
        ),
        route: SingleDigitTimedTestScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_1),
        color: Colors.amber[400]),
      'AlphabetEdit': ActivityMenuButton(
        text: Text(
          'Alphabet [View/Edit]',
          style: TextStyle(fontSize: 24),
        ),
        route: AlphabetEditScreen(),
        icon: Icon(Icons.filter_2),
        color: Colors.blue[100]),
      'AlphabetPractice': ActivityMenuButton(
        text: Text(
          'Alphabet [Practice]',
          style: TextStyle(fontSize: 24),
        ),
        route: AlphabetPracticeScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_2),
        color: Colors.blue[200]),
      'AlphabetWrittenTest': ActivityMenuButton(
        text: Text(
          'Alphabet [Written Test]',
          style: TextStyle(fontSize: 24),
        ),
        route: AlphabetMultipleChoiceTestScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_2),
        color: Colors.blue[300]),
      'AlphabetTimedTestPrep': ActivityMenuButton(
        text: Text(
          'Alphabet [Timed Test Prep]',
          style: TextStyle(fontSize: 21),
        ),
        route: AlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_2),
        color: Colors.blue[400]),
      'AlphabetTimedTest': ActivityMenuButton(
        text: Text(
          'Alphabet [Timed Test]',
          style: TextStyle(fontSize: 22),
        ),
        route: AlphabetTimedTestScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_2),
        color: Colors.blue[400]),
      'PAOEdit': ActivityMenuButton(
          text: Text(
            'PAO [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOEditScreen(),
          icon: Icon(Icons.filter_3),
          color: Colors.pink[100]),
      'PAOPractice': ActivityMenuButton(
          text: Text(
            'PAO [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOPracticeScreen(
            callback: callback,
          ),
          icon: Icon(Icons.filter_3),
          color: Colors.pink[200]),
      'PAOMultipleChoiceTest': ActivityMenuButton(
        text: Text(
          'PAO [MC Test]',
          style: TextStyle(fontSize: 24),
        ),
        route: PAOMultipleChoiceTestScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_3),
        color: Colors.pink[300]),
      'PAOTimedTestPrep': ActivityMenuButton(
        text: Text(
          'PAO [Timed Test Prep]',
          style: TextStyle(fontSize: 24),
        ),
        route: PAOTimedTestPrepScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_3),
        color: Colors.pink[400]),
      'PAOTimedTest': ActivityMenuButton(
        text: Text(
          'PAO [Timed Test]',
          style: TextStyle(fontSize: 24),
        ),
        route: PAOTimedTestScreen(
          callback: callback,
        ),
        icon: Icon(Icons.filter_3),
        color: Colors.pink[400]),
    };
  }
}
