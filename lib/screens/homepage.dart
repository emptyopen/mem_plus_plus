import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/screens/custom_memory/custom_memory_manager_screen.dart';
import 'package:mem_plus_plus/screens/custom_memory/custom_memory_test_screen.dart';
import 'package:mem_plus_plus/screens/lessons/welcome_screen.dart';
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

const String firstTimeAppKey = 'FirstTimeApp';
const String homepageFirstHelpKey = 'HomepageFirstHelp';
const String activityStatesKey = 'ActivityStates';
const String customMemoriesKey = 'CustomMemories';
const String customMemoryManagerAvailableKey = 'CustomMemoryManagerAvailable';
const String customMemoryManagerFirstHelpKey = 'CustomMemoryManagerFirstView';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO: add global celebration animation whenever there is a level up
// TODO: change custom memory tests to add time only once they are complete, use a 'nextTime'
// TODO: add date input to custom memories
// TODO: make practice work both ways object -> number / number -> object
// TODO: roll out for ios Store
// TODO: add notifications about newly available activities

// Nice to have
// TODO: make practice unavailable if edit isn't complete
// TODO: implement length limits for inputs (like action/object)
// TODO: make PAO multiple choice tougher with similar digits
// TODO: make vibrations cooler, and more consistent across app?
// TODO: consolidate colors
// TODO: make snackbars prettier
// TODO: written test: allow close enough spelling
// TODO: tasks that are still more than 24 hours away, have separate bar with count of such activities
// TODO: add celebration/sad art when MC/written test is complete
// TODO: collapse menu items into consolidated versions after complete

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  List<String> availableActivities = [];
  Map customMemories;
  Map activityMenuButtonMap;
  bool firstTimeOpeningApp;
  bool customMemoryManagerAvailable;
  bool customMemoryManagerFirstView;
  final globalKey = GlobalKey<ScaffoldState>();

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

    var prefs = PrefsUpdater();

    // first time opening app, welcome
    if (await prefs.getBool(firstTimeAppKey) == null ||
        await prefs.getBool(firstTimeAppKey)) {
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

    // check if customManager is available, and firstView
    if (await prefs.getBool('CustomMemoryManagerAvailable') == null) {
      customMemoryManagerAvailable = false;
    } else {
      customMemoryManagerAvailable = true;
    }
    if (await prefs.getBool(customMemoryManagerFirstHelpKey) == null || await prefs.getBool(customMemoryManagerFirstHelpKey) == false) {
      customMemoryManagerFirstView = false;
    } else {
      customMemoryManagerFirstView = true;
    }

    // check for custom tests
    if (prefs.getString(customMemoriesKey) == null) {
      customMemories = {};
      await prefs.writeSharedPrefs(customMemoriesKey, {});
    } else {
      customMemories = await prefs.getSharedPrefs(customMemoriesKey);
    }

    // filter unlocked activities by level
    activityStates = await prefs.getSharedPrefs(activityStatesKey);
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

  checkCustomMemoryManagerFirstTime() async {
    var prefs = PrefsUpdater();
    if (await prefs.getBool(customMemoryManagerFirstHelpKey) == true) {
      setState(() {customMemoryManagerFirstView = false;});
      await prefs.setBool(customMemoryManagerFirstHelpKey, false);
    }
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) {
        return CustomMemoryManagerScreen(
          callback: callback,
        );
      }));
  }

  callback() {
    setUnlockedActivities();
    print(activityStates.map(
        (k, v) => MapEntry(k, '${v.state} | ${v.visible} | ${v.firstView}')));
  }

  callbackSnackbar(String text, Color textColor, Color backgroundColor, int durationSeconds) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      duration: Duration(seconds: durationSeconds),
      backgroundColor: backgroundColor,
    );
    globalKey.currentState.showSnackBar(snackBar);
  }

  List<Widget> getTodo() {
    List<MainMenuOption> mainMenuOptions = [];

    // custom tests
    customMemories.forEach((title, memory) {
      DateTime nextDateTime = findNextDatetime(
        memory['startDatetime'],
        memory['spacedRepetitionType'],
        memory['spacedRepetitionLevel']);
      var activity = Activity('test', 'todo', true, nextDateTime, false);
      var customIcon = customMemoryIconMap[memory['type']];
      mainMenuOptions.add(MainMenuOption(
        activity: activity,
        icon: Icon(customIcon),
        text: Text('${memory['type']}: $title', style: TextStyle(fontSize: 21),),
        route: CustomMemoryTestScreen(
          customMemory: memory,
          callback: callback,
          callbackSnackbar: callbackSnackbar,
          globalKey: globalKey,
        ),
        callback: callback,
        color: Colors.purple[400],
        splashColor: Colors.purple[500],
      ));
    });

    // regular activities
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
          splashColor: activityMenuButtonMap[activity].splashColor,
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
          splashColor: activityMenuButtonMap[activity].splashColor,
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
            key: globalKey,
            appBar: AppBar(
              title: Text('MEM++ Homepage'),
              actions: <Widget>[
                customMemoryManagerAvailable ? Stack(
                  children: <Widget>[
                    Center(
                      child: IconButton(
                        icon: Icon(Icons.add_box),
                        color: Colors.deepPurple,
                        onPressed: () {
                          checkCustomMemoryManagerFirstTime();
                        },
                      ),
                    ),
                    customMemoryManagerFirstView ? Positioned(
                      child: Container(
                        width: 33,
                        height: 16,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.red[200],
                        ),
                        child: Center(child: Text('new!', style: TextStyle(fontSize: 10, fontFamily: 'SpaceMono', color: Colors.black),)),
                      ),
                      left: 5,
                      top: 6) : Container()
                  ],
                ) : Container(),
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
                    BasicFlatButton(
                      onPressed: () => resetKeys(),
                      text: 'reset everything',
                    ),
                    BasicFlatButton(
                      onPressed: () => maxOutKeys(),
                      text: 'max out everything',
                    ),
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
          color: Colors.green[100],
          splashColor: Colors.green[200]),
      'SingleDigitEdit': ActivityMenuButton(
          text: Text(
            'Single Digit [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitEditScreen(),
          icon: editIcon,
          color: Colors.amber[100],
        splashColor: Colors.amber[200]),
      'SingleDigitPractice': ActivityMenuButton(
          text: Text(
            'Single Digit [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.amber[200],
        splashColor: Colors.amber[300]),
      'SingleDigitMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'Single Digit [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: SingleDigitMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.amber[300],
        splashColor: Colors.amber[400]),
      'SingleDigitTimedTestPrep': ActivityMenuButton(
          text: Text(
            'Single Digit [Timed Test Prep]',
            style: TextStyle(fontSize: 21),
          ),
          route: SingleDigitTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.amber[400],
        splashColor: Colors.amber[500]),
      'SingleDigitTimedTest': ActivityMenuButton(
          text: Text(
            'Single Digit [Timed Test]',
            style: TextStyle(fontSize: 22),
          ),
          route: SingleDigitTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.amber[400],
        splashColor: Colors.amber[500]),
      'AlphabetEdit': ActivityMenuButton(
          text: Text(
            'Alphabet [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetEditScreen(),
          icon: editIcon,
          color: Colors.blue[100],
        splashColor: Colors.blue[200]),
      'AlphabetPractice': ActivityMenuButton(
          text: Text(
            'Alphabet [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.blue[200],
        splashColor: Colors.blue[300]),
      'AlphabetWrittenTest': ActivityMenuButton(
          text: Text(
            'Alphabet [Written Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: AlphabetMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: writtenTestIcon,
          color: Colors.blue[300],
        splashColor: Colors.blue[400]),
      'AlphabetTimedTestPrep': ActivityMenuButton(
          text: Text(
            'Alphabet [Timed Test Prep]',
            style: TextStyle(fontSize: 21),
          ),
          route: AlphabetTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.blue[400],
        splashColor: Colors.blue[500]),
      'AlphabetTimedTest': ActivityMenuButton(
          text: Text(
            'Alphabet [Timed Test]',
            style: TextStyle(fontSize: 22),
          ),
          route: AlphabetTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.blue[400],
        splashColor: Colors.blue[500]),
      'PAOEdit': ActivityMenuButton(
          text: Text(
            'PAO [View/Edit]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOEditScreen(),
          icon: editIcon,
          color: Colors.pink[100],
        splashColor: Colors.pink[200]),
      'PAOPractice': ActivityMenuButton(
          text: Text(
            'PAO [Practice]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOPracticeScreen(
            callback: callback,
          ),
          icon: practiceIcon,
          color: Colors.pink[200],
        splashColor: Colors.pink[300]),
      'PAOMultipleChoiceTest': ActivityMenuButton(
          text: Text(
            'PAO [MC Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOMultipleChoiceTestScreen(
            callback: callback,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.pink[300],
        splashColor: Colors.pink[400]),
      'PAOTimedTestPrep': ActivityMenuButton(
          text: Text(
            'PAO [Timed Test Prep]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.pink[400],
        splashColor: Colors.pink[500]),
      'PAOTimedTest': ActivityMenuButton(
          text: Text(
            'PAO [Timed Test]',
            style: TextStyle(fontSize: 24),
          ),
          route: PAOTimedTestScreen(
            callback: callback,
          ),
          icon: timedTestIcon,
          color: Colors.pink[400],
        splashColor: Colors.pink[500]),
    };
  }

  resetKeys() async {
    var prefs = PrefsUpdater();

    await prefs.clear();

    setState(() {
      activityStates = defaultActivityStates1;
      customMemories = {};
    });
    await prefs.writeSharedPrefs(activityStatesKey, defaultActivityStates1);
    await prefs.writeSharedPrefs(customMemoriesKey, {});

    setUnlockedActivities();
  }

  maxOutKeys() async {
    var prefs = PrefsUpdater();

    await prefs.setBool(customMemoryManagerAvailableKey, true);
    customMemoryManagerAvailable = true;

    setState(() {
      activityStates = defaultActivityStates2;
    });
    await prefs.writeSharedPrefs(activityStatesKey, defaultActivityStates2);

    setUnlockedActivities();
  }
}

class HomepageHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Homescreen',
      information: ['    This is the homescreen! The first time you open any screen, the information '
        'regarding the screen will pop up. Access the information again at any time by clicking the '
        'info icon in the top right corner! '],
    );
  }
}