import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/screens/custom_test_manager_screen.dart';
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

// TODO: add global celebration animation whenever there is a level up
// TODO: unlock the ability for personally created tests (credit cards, driver's licence, phone number)
// TODO: make practice work both ways object -> number / number -> object
// TODO: make practice unavailable if edit isn't complete
// TODO: collapse menu items into consolidated versions after complete
// TODO: roll out for ios Store
// TODO: add notifications about newly available activities

// Nice to have
// TODO: implement length limits for inputs (like action/object)
// TODO: make PAO multiple choice tougher with similar digits
// TODO: fix all flatbuttons
// TODO: make vibrations cooler, and more consistent across app?
// TODO: consolidate colors
// TODO: make snackbars prettier
// TODO: written test: allow close enough spelling
// TODO: tasks that are still more than 24 hours away, have separate bar with count of such activities
// TODO: add celebration/sad art when MC/written test is complete

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  String activityStatesKey = 'ActivityStates';
  List<String> availableActivities = [];
  String firstTimeAppKey = 'FirstTimeApp';
  String homepageFirstHelpKey = 'HomepageFirstHelp';
  Map activityMenuButtonMap;
  bool firstTimeOpeningApp;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    checkFirstTime();
    initializeActivityMenuButtonMap();
    new Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

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
            ));
      });
    }

    // set unlocked activities
    setUnlockedActivities();
  }

  void setUnlockedActivities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // first time opening app, welcome
    if (prefs.getBool(firstTimeAppKey) == null ||
        prefs.getBool(firstTimeAppKey)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen(
                    firstTime: true,
                    callback: callback,
                  )));
    } else {
      firstTimeOpeningApp = false;
    }

    // filter unlocked activities by level
    var rawMap =
        json.decode(prefs.getString(activityStatesKey)) as Map<String, dynamic>;
    activityStates = rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
    setState(() {
      // iterate through unlocked activities, and check if they are visible
      availableActivities = [];
      for (String activityName in activityStates.keys) {
        if (activityStates[activityName].visible) {
          availableActivities.add(activityName);
        }
      }
    });
  }

  checkFirstTime() async {
    var prefs = PrefsUpdater();
    if (await prefs.getBool(homepageFirstHelpKey) == null) {
      Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return HomepageHelp();
        }));
      await prefs.setBool(homepageFirstHelpKey, true);
    }
  }

  resetKeys() async {
    var prefs = PrefsUpdater();
    await prefs.clear();

    setState(() {
      activityStates = defaultActivityStates1;
      prefs.setString(
          activityStatesKey,
          json.encode(
            activityStates.map((k, v) => MapEntry(k, v.toJson())),
          ));
    });

    setUnlockedActivities();
  }

  callback() {
    setUnlockedActivities();
    print(activityStates.map(
        (k, v) => MapEntry(k, '${v.state} | ${v.visible} | ${v.firstView}')));
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
    return firstTimeOpeningApp == null
        ? Scaffold()
        : Scaffold(
            appBar: AppBar(
              title: Text('MEM++ Homepage'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_box),
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomTestManagerScreen();
                      }));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return HomepageHelp();
                      }));
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'To-do:',
                      style: TextStyle(fontSize: 30),
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
                      style: TextStyle(fontSize: 30),
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
    var editIcon = Icon(Icons.edit);
    var practiceIcon = Icon(Icons.flip);
    var multipleChoiceTestIcon = Icon(Icons.list);
    var timedTestPrepIcon = Icon(Icons.add_alarm);
    var timedTestIcon = Icon(Icons.access_alarm);
    var writtenTestIcon = Icon(Icons.text_format);
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
          icon: editIcon,
          color: Colors.amber[100]),
      'SingleDigitPractice': ActivityMenuButton(
          text: Text(
            'Single Digit [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.amber[200]),
      'SingleDigitMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'Single Digit [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.amber[300]),
      'SingleDigitTimedTestPrep': ActivityMenuButton(
          text: Text(
            'Single Digit [Timed Test Prep]',
            style: TextStyle(fontSize: 21),
          ),
          route: SingleDigitTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.amber[400]),
      'SingleDigitTimedTest': ActivityMenuButton(
          text: Text(
            'Single Digit [Timed Test]',
            style: TextStyle(fontSize: 22),
          ),
          route: SingleDigitTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.amber[400]),
      'AlphabetEdit': ActivityMenuButton(
          text: Text(
            'Alphabet [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetEditScreen(),
          icon: editIcon,
          color: Colors.blue[100]),
      'AlphabetPractice': ActivityMenuButton(
          text: Text(
            'Alphabet [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.blue[200]),
      'AlphabetWrittenTest': ActivityMenuButton(
          text: Text(
            'Alphabet [Written Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: writtenTestIcon,
          color: Colors.blue[300]),
      'AlphabetTimedTestPrep': ActivityMenuButton(
          text: Text(
            'Alphabet [Timed Test Prep]',
            style: TextStyle(fontSize: 21),
          ),
          route: AlphabetTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.blue[400]),
      'AlphabetTimedTest': ActivityMenuButton(
          text: Text(
            'Alphabet [Timed Test]',
            style: TextStyle(fontSize: 22),
          ),
          route: AlphabetTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.blue[400]),
      'PAOEdit': ActivityMenuButton(
          text: Text(
            'PAO [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOEditScreen(),
          icon: editIcon,
          color: Colors.pink[100]),
      'PAOPractice': ActivityMenuButton(
          text: Text(
            'PAO [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.pink[200]),
      'PAOMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'PAO [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.pink[300]),
      'PAOTimedTestPrep': ActivityMenuButton(
          text: Text(
            'PAO [Timed Test Prep]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.pink[400]),
      'PAOTimedTest': ActivityMenuButton(
          text: Text(
            'PAO [Timed Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.pink[400]),
    };
  }
}

class HomepageHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: ['    This is the homescreen! The first time you open any screen, the information '
        'regarding the screen will pop up. Access the information again at any time by clicking the '
        'info icon in the top right corner! '],
    );
  }
}