import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
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

class MyHomePage extends StatefulWidget {

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// TODO: notifications for custom memory timed tests
// TODO: change custom memory tests to add time only once they are complete, use a 'nextTime'

// TODO: pao didn't show results

// mc test / written test
// TODO: full screen flash cards, flip to green correct or red incorrect
// TODO: auto exit after MC/written test
// TODO: only show cards that are not 100% familiarity, unless they are all 100% familiarity in which case show all of them
// TODO: after MC test, show which words were INCORRECT

// TODO: add ability to view custom memories

// other
// TODO: dark mode button in top right corner
// TODO: consolidate timed test stuff INTO SCREENS
// TODO: add warning about 0 vs O
// TODO: add safe viewing area (for toolbar)
// TODO: add global celebration animation whenever there is a level up (or more animation in general, FLARE?)
// TODO: add date input to custom memories
// TODO: add notifications about newly available activities
// TODO: write some lessons, intersperse

// Nice to have
// TODO: add ability for alphabet to contain up to 3 objects
// TODO: implement length limits for inputs (like action/object)
// TODO: collapse menu items into consolidated versions after complete
// TODO: make PAO multiple choice tougher with similar digits
// TODO: make vibrations cooler, and more consistent across app?
// TODO: consolidate colors
// TODO: make snackbars prettier
// TODO: written test: allow close enough spelling
// TODO: tasks that are still more than 24 hours away, have separate bar with count of such activities

// TODO:  Brain by Arjun Adamson from the Noun Project
// https://medium.com/@psyanite/how-to-add-app-launcher-icons-in-flutter-bd92b0e0873a

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  List<String> availableActivities = [];
  Map customMemories;
  Map activityMenuButtonMap;
  bool firstTimeOpeningApp;
  bool customMemoryManagerAvailable;
  bool customMemoryManagerFirstView;
  final globalKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    checkForAppUpdate();
    getSharedPrefs();
    initializeActivityMenuButtonMap();
    initializeNotificationsScheduler();
    new Timer.periodic(Duration(seconds: 1), (Timer t) => setState(() {}));
  }

  checkForAppUpdate() async {
//    String version = '3';
//    if (await prefs.getBool('VERSION-$version') == null) {
//      print('resetting due to new version $version');
//      resetKeys();
//      await prefs.setBool('VERSION-$version', true);
//      setUnlockedActivities();
//    }
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
        activityStates = defaultActivityStatesInitial;
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
    // if first time opening app, welcome
    if (await prefs.getBool(firstTimeAppKey) == null ||
        await prefs.getBool(firstTimeAppKey)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen(
                    firstTime: true,
                    callback: callback,
                    mainMenuFirstTimeCallback: checkFirstTime,
                  )));
    } else {
      firstTimeOpeningApp = false;
    }

    // check if customManager is available, and firstView
    if (await prefs.getBool(customMemoryManagerAvailableKey) == null) {
      customMemoryManagerAvailable = false;
    } else {
      customMemoryManagerAvailable = true;
    }
    if (await prefs.getBool(customMemoryManagerFirstHelpKey) == null ||
        await prefs.getBool(customMemoryManagerFirstHelpKey) == false) {
      customMemoryManagerFirstView = false;
    } else {
      customMemoryManagerFirstView = true;
    }

    // get custom memories
    if (await prefs.getString(customMemoriesKey) == null) {
      customMemories = {};
      await prefs.writeSharedPrefs(customMemoriesKey, {});
    } else {
      customMemories = await prefs.getSharedPrefs(customMemoriesKey);
    }

    // set available activities
    activityStates = await prefs.getSharedPrefs(activityStatesKey);
    setState(() {
      availableActivities = [];
      for (String activityName in activityStates.keys) {
        if (activityStates[activityName].visible) {
          availableActivities.add(activityName);
        }
      }
    });
  }

  checkFirstTime() async {
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
    if (await prefs.getBool(customMemoryManagerFirstHelpKey) == true) {
      setState(() {
        customMemoryManagerFirstView = false;
      });
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

  List<Widget> getTodo() {
    List<MainMenuOption> mainMenuOptions = [];

    // custom tests
    customMemories.forEach((title, memory) {
      var nextDateTime = DateTime.parse(memory['nextDatetime']);
      var activity = Activity('test', 'todo', true, nextDateTime, false);
      var customIcon = customMemoryIconMap[memory['type']];
      mainMenuOptions.add(MainMenuOption(
        activity: activity,
        icon: Icon(customIcon),
        text: '${memory['type']}: $title',
        route: CustomMemoryTestScreen(
          customMemory: memory,
          callback: callback,
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

  initializeNotificationsScheduler() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var time = Time(12, 30, 0);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Have you improved your memory today?',
        'Click here to check your to-do list!',
        time,
        platformChannelSpecifics);
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
                customMemoryManagerAvailable
                    ? Stack(
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
                          customMemoryManagerFirstView
                              ? Positioned(
                                  child: Container(
                                    width: 35,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      //color: Color.fromRGBO(255, 105, 180, 1),
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.85),
                                    ),
                                    child: Shimmer.fromColors(
                                      period: Duration(seconds: 3),
                                      baseColor: Colors.black,
                                      highlightColor: Colors.greenAccent,
                                      child: Center(
                                          child: Text(
                                        'new!',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.red),
                                      )),
                                    ),
                                  ),
                                  left: 3,
                                  top: 4)
                              : Container()
                        ],
                      )
                    : Container(),
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
                    // BasicFlatButton(
                    //   text: 'Notify!',
                    //   onPressed: () => notifyDuration(Duration(seconds: 4), 'hey', 'yo'),
                    // ),
                    // Fireworks(),
                    Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey[300],
                      period: Duration(seconds: 6),
                      child: Text(
                        'To-do:',
                        style: TextStyle(fontSize: 30),
                      ),
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
                      onPressed: () => resetActivities(),
                      text: 'reset activites, not data',
                    ),
                    BasicFlatButton(
                      onPressed: () => maxOutKeys(),
                      text: 'max out everything',
                    ),
                    BasicFlatButton(
                      onPressed: () => resetAll(),
                      text: 'reset everything',
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
          text: 'Welcome',
          route: WelcomeScreen(),
          icon: Icon(Icons.filter),
          color: Colors.green[100],
          splashColor: Colors.green[200]),
      'SingleDigitEdit': ActivityMenuButton(
          text: 'Single Digit [View/Edit]',
          route: SingleDigitEditScreen(
            callback: callback,
          ),
          icon: editIcon,
          color: Colors.amber[100],
          splashColor: Colors.amber[200]),
      'SingleDigitPractice': ActivityMenuButton(
          text: 'Single Digit [Practice]',
          route: SingleDigitPracticeScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: practiceIcon,
          color: Colors.amber[200],
          splashColor: Colors.amber[300]),
      'SingleDigitMultipleChoiceTest': ActivityMenuButton(
          text: 'Single Digit [MC Test]',
          route: SingleDigitMultipleChoiceTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.amber[300],
          splashColor: Colors.amber[400]),
      'SingleDigitTimedTestPrep': ActivityMenuButton(
          text: 'Single Digit [Test Prep]',
          route: SingleDigitTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.amber[400],
          splashColor: Colors.amber[500]),
      'SingleDigitTimedTest': ActivityMenuButton(
          text: 'Single Digit [Timed Test]',
          route: SingleDigitTimedTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: timedTestIcon,
          color: Colors.amber[400],
          splashColor: Colors.amber[500]),
      'AlphabetEdit': ActivityMenuButton(
          text: 'Alphabet [View/Edit]',
          route: AlphabetEditScreen(
            callback: callback,
          ),
          icon: editIcon,
          color: Colors.blue[100],
          splashColor: Colors.blue[200]),
      'AlphabetPractice': ActivityMenuButton(
          text: 'Alphabet [Practice]',
          route: AlphabetPracticeScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: practiceIcon,
          color: Colors.blue[200],
          splashColor: Colors.blue[300]),
      'AlphabetWrittenTest': ActivityMenuButton(
          text: 'Alphabet [Written Test]',
          route: AlphabetWrittenTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: writtenTestIcon,
          color: Colors.blue[300],
          splashColor: Colors.blue[400]),
      'AlphabetTimedTestPrep': ActivityMenuButton(
          text: 'Alphabet [Test Prep]',
          route: AlphabetTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.blue[400],
          splashColor: Colors.blue[500]),
      'AlphabetTimedTest': ActivityMenuButton(
          text: 'Alphabet [Timed Test]',
          route: AlphabetTimedTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: timedTestIcon,
          color: Colors.blue[400],
          splashColor: Colors.blue[500]),
      'PAOEdit': ActivityMenuButton(
          text: 'PAO [View/Edit]',
          route: PAOEditScreen(
            callback: callback,
          ),
          icon: editIcon,
          color: Colors.pink[100],
          splashColor: Colors.pink[200]),
      'PAOPractice': ActivityMenuButton(
          text: 'PAO [Practice]',
          route: PAOPracticeScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: practiceIcon,
          color: Colors.pink[200],
          splashColor: Colors.pink[300]),
      'PAOMultipleChoiceTest': ActivityMenuButton(
          text: 'PAO [MC Test]',
          route: PAOMultipleChoiceTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: multipleChoiceTestIcon,
          color: Colors.pink[300],
          splashColor: Colors.pink[400]),
      'PAOTimedTestPrep': ActivityMenuButton(
          text: 'PAO [Test Prep]',
          route: PAOTimedTestPrepScreen(
            callback: callback,
          ),
          icon: timedTestPrepIcon,
          color: Colors.pink[400],
          splashColor: Colors.pink[500]),
      'PAOTimedTest': ActivityMenuButton(
          text: 'PAO [Timed Test]',
          route: PAOTimedTestScreen(
            callback: callback,
            globalKey: globalKey,
          ),
          icon: timedTestIcon,
          color: Colors.pink[400],
          splashColor: Colors.pink[500]),
    };
  }

  resetAll() async {
    await prefs.clear();

    var clearTo = defaultActivityStatesInitial;

    setState(() {
      activityStates = clearTo;
      customMemories = {};
    });
    await prefs.writeSharedPrefs(activityStatesKey, clearTo);
    await prefs.writeSharedPrefs(customMemoriesKey, {});

    setUnlockedActivities();
  }

  resetActivities() async {
    var clearTo = defaultActivityStatesInitial;

    setState(() {
      activityStates = clearTo;
      customMemories = {};
    });
    await prefs.writeSharedPrefs(activityStatesKey, clearTo);

    setUnlockedActivities();
  }

  maxOutKeys() async {
    await prefs.setBool(customMemoryManagerAvailableKey, true);
    customMemoryManagerAvailable = true;

    await prefs.writeSharedPrefs(
        activityStatesKey, defaultActivityStatesAllDone);

    setUnlockedActivities();
  }
}

class HomepageHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Homescreen',
      information: [
        '    This is the homescreen! The first time you open any screen, the information '
            'regarding the screen will pop up. Access the information again at any time by clicking the '
            'info icon in the top right corner! '
      ],
      buttonColor: Colors.grey[200],
      buttonSplashColor: Colors.grey[300],
    );
  }
}
