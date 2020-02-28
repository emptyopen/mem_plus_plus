import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter/services.dart';

import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/screens/settings_screen.dart';
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
import 'package:mem_plus_plus/screens/face/face_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/face/face_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_edit_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_practice_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/pi/pi_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/pi/pi_timed_test_screen.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Chapter 0
// welcome

// Chapter 1
// single digit
// - quick lesson 1: ?? Don't get discouraged! If you forgot something, it just wasn't anchored correctly, or it wasn't vivid enough. 
// - planet test
// - face test (with age)

// Chapter 2
// alphabet
// - quick lesson 2: ?? 
// - parking spot
// - phonetic alphabet
// - airline confirmation code / flight number / departure time / seat number

// Chapter 3
// pao
// - quick lesson 3: spaced repetition
// * custom memory manager
// - pi test

// ---- paywall -----

// Chapter 4
// deck
// - conversion rates
// - first aid
// - doomsday test


// done:
// add cooler page transitions
// fix padding on flash cards
// identify unavailable activites (availableAfter)
// add about developer to settings
// change page numbers to dot system  (welcome screen, help screens)
// BIG: 100 digit pi test
// change isSuper to completion of system, not unlock
// Tenable new activities based on if they are not yet enabled
// make keyboard numeric for custom memory fields

// next up:

// horizon:
// TODO: implement length limits for inputs (like action/object) - maybe 30 characters
// TODO: move custom memory to floating button
// TODO: tasks that are still more than 24 hours away, have separate bar with count of such activities
// TODO: make default date better (1990 for birthday, etc)
// TODO: handle bad CSV input
// TODO: add CSV template for google sheets
// TODO: if number of flash cards needed is less than 5?, make it 5 instead of just one
// TODO: consolidate tests between systems (need 3 or 4 tests in between each?)
// TODO: add more basic tests, intersperse between systems (planets, 100 digits of pi, phonetic alphabet, conversion rates, the doomsday rule)
// TODO: add first aid system
// TODO: add more faces, make all of them closer to the face
// TODO: alphabet PAO (person action, same object)
// TODO: add symbols
// TODO: add password test
// TODO: add safe viewing area (for toolbar)
// TODO: add global celebration animation whenever there is a level up (or more animation in general, FLARE?)
// TODO: write some lessons, intersperse
// TODO: crashlytics for IOS

// Nice to have
// TODO: make CSV uploader text selectable
// TODO: add name (first time, and preferences) - use in local notifications
// TODO: add sounds
// TODO: add ability for alphabet to contain up to 3 objects
// TODO: make PAO multiple choice tougher with similar digits
// TODO: make vibrations cooler, and more consistent across app?

// TODO:  Brain by Arjun Adamson from the Noun Project
// https://medium.com/@psyanite/how-to-add-app-launcher-icons-in-flutter-bd92b0e0873a
// Icons made by <a href="https://www.flaticon.com/authors/dimitry-miroliubov" title="Dimitry Miroliubov">Dimitry Miroliubov</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>
class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  List<String> availableActivities = [];
  Map customMemories;
  Map activityMenuButtonMap;
  bool firstTimeOpeningApp;
  bool customMemoryManagerAvailable;
  bool customMemoryManagerFirstView;
  final globalKey = GlobalKey<ScaffoldState>();
  bool consolidateSingleDigit = false;
  bool consolidateAlphabet = false;
  bool consolidatePAO = false;
  bool consolidateDeck = false;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    checkForAppUpdate();
    getSharedPrefs();
    initializeActivityMenuButtonMap();
    new Timer.periodic(
        Duration(milliseconds: 100), (Timer t) => setState(() {}));
  }

  checkForAppUpdate() async {
    //  String version = '6';
    //  if (await prefs.getBool('VERSION-$version') == null) {
    //    print('resetting due to new version $version');
    //    resetActivities();
    //    await prefs.setBool('VERSION-$version', true);
    //    setUnlockedActivities();
    //  }
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(darkModeKey) == null || !(prefs.getBool(darkModeKey))) {
      backgroundColor = Colors.white;
      backgroundHighlightColor = Colors.black;
      backgroundSemiColor = Colors.grey[200];
      backgroundSemiHighlightColor = Colors.grey[800];
    } else {
      backgroundColor = Colors.grey[800];
      backgroundHighlightColor = Colors.white;
      backgroundSemiColor = Colors.grey[600];
      backgroundSemiHighlightColor = Colors.grey[200];
    }
    setState(() {});

    // activity states, and unlockedActivities
    if (prefs.getKeys().contains(activityStatesKey)) {
      setState(() {
        var rawMap = json.decode(prefs.getString(activityStatesKey))
            as Map<String, dynamic>;
        activityStates =
            rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
      });
    } else {
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

    // iterate through all activity states, add activities if they are visible
    availableActivities = [];
    activityStates = await prefs.getSharedPrefs(activityStatesKey);

    for (String activityName in activityStates.keys) {
      if (activityStates[activityName].visible) {
        availableActivities.add(activityName);
      }
    }

    // consolidate menu buttons
    if (await prefs.getActivityState(singleDigitTimedTestKey) == 'review') {
      consolidateSingleDigit = true;
    }
    if (await prefs.getActivityState(alphabetTimedTestKey) == 'review') {
      consolidateAlphabet = true;
    }
    if (await prefs.getActivityState(paoTimedTestKey) == 'review') {
      consolidatePAO = true;
    }
    if (await prefs.getActivityState(deckTimedTestKey) == 'review') {
      consolidateDeck = true;
    }

    setState(() {});
    initializeNotificationsScheduler();
    print(activityStates);
    print(availableActivities);
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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) =>
            CustomMemoryManagerScreen(
          callback: callback,
        ),
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
    );
  }

  callback() {
    setUnlockedActivities();
    // print(activityStates.map((k, v) => MapEntry(k, '${v.state} | ${v.visible} | ${v.firstView}')));
  }

  List<Widget> getTodo() {
    List<Widget> mainMenuOptions = [];

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
        complete1: Colors.purple[200],
        complete2: Colors.purple[500],
        complete: true,
        globalKey: globalKey,
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
          complete1: activityMenuButtonMap[activity].complete1,
          complete2: activityMenuButtonMap[activity].complete2,
          complete: false,
          globalKey: globalKey,
        ));
      }
    }
    return mainMenuOptions;
  }

  List<Widget> getReview() {
    List<Widget> mainMenuOptions = [];

    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'review') {
        bool notConsolidated = true;
        if (activity.contains(singleDigitKey) && consolidateSingleDigit) {
          notConsolidated = false;
        }
        if (activity.contains(alphabetKey) && consolidateAlphabet) {
          notConsolidated = false;
        }
        if (activity.contains(paoKey) && consolidatePAO) {
          notConsolidated = false;
        }
        if (activity.contains(deckKey) && consolidateDeck) {
          notConsolidated = false;
        }
        if (notConsolidated) {
          mainMenuOptions.add(MainMenuOption(
            callback: callback,
            activity: activityStates[activity],
            text: activityMenuButtonMap[activity].text,
            route: activityMenuButtonMap[activity].route,
            icon: activityMenuButtonMap[activity].icon,
            color: activityMenuButtonMap[activity].color,
            splashColor: activityMenuButtonMap[activity].splashColor,
            complete: true,
            complete1: activityMenuButtonMap[activity].complete1,
            complete2: activityMenuButtonMap[activity].complete2,
            globalKey: globalKey,
          ));
        }
      }
      if (activity == singleDigitEditKey && consolidateSingleDigit) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Single Digit:',
            backgroundColor: colorSingleDigitStandard,
            buttonColor: colorSingleDigitDarker,
            buttonSplashColor: colorSingleDigitDarkest,
            editActivity: activityStates[singleDigitEditKey],
            editRoute: SingleDigitEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[singleDigitPracticeKey],
            practiceRoute: SingleDigitPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[singleDigitMultipleChoiceTestKey],
            testIcon: multipleChoiceTestIcon,
            testRoute: SingleDigitMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[singleDigitTimedTestPrepKey],
            timedTestPrepRoute: SingleDigitTimedTestPrepScreen(
              callback: callback,
            ),
          ),
        );
      }
      if (activity == alphabetEditKey && consolidateAlphabet) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Alphabet:',
            backgroundColor: colorAlphabetStandard,
            buttonColor: colorAlphabetDarker,
            buttonSplashColor: colorAlphabetDarkest,
            editActivity: activityStates[alphabetEditKey],
            editRoute: AlphabetEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[alphabetPracticeKey],
            practiceRoute: AlphabetPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[alphabetWrittenTestKey],
            testIcon: writtenTestIcon,
            testRoute: AlphabetWrittenTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[alphabetTimedTestPrepKey],
            timedTestPrepRoute: AlphabetTimedTestPrepScreen(
              callback: callback,
            ),
          ),
        );
      }
      if (activity == paoEditKey && consolidatePAO) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'PAO:',
            backgroundColor: colorPAOStandard,
            buttonColor: colorPAODarker,
            buttonSplashColor: colorPAODarkest,
            editActivity: activityStates[paoEditKey],
            editRoute: PAOEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[paoPracticeKey],
            practiceRoute: PAOPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[paoMultipleChoiceTestKey],
            testIcon: multipleChoiceTestIcon,
            testRoute: PAOMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[paoTimedTestPrepKey],
            timedTestPrepRoute: PAOTimedTestPrepScreen(
              callback: callback,
            ),
          ),
        );
      }
      if (activity == deckEditKey && consolidateDeck) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Deck:',
            backgroundColor: colorDeckStandard,
            buttonColor: colorDeckDarker,
            buttonSplashColor: colorDeckDarkest,
            editActivity: activityStates[deckEditKey],
            editRoute: DeckEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[deckPracticeKey],
            practiceRoute: DeckPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[deckMultipleChoiceTestKey],
            testIcon: multipleChoiceTestIcon,
            testRoute: DeckMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[deckTimedTestPrepKey],
            timedTestPrepRoute: DeckTimedTestPrepScreen(
              callback: callback,
            ),
          ),
        );
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
            backgroundColor: backgroundColor,
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
                                HapticFeedback.heavyImpact();
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
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) =>
                            SettingsScreen(
                          resetAll: resetAll,
                          resetActivities: resetActivities,
                          maxOutKeys: maxOutKeys,
                        ),
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) =>
                            SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    HapticFeedback.heavyImpact();
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
                decoration: BoxDecoration(color: backgroundColor),
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // BasicFlatButton(
                    //   text: 'Notify!',
                    //   onPressed: () => notifyDuration(Duration(seconds: 4), 'hey', 'yo'),
                    // ),
                    // Shimmer.fromColors(
                    //   baseColor: backgroundHighlightColor,
                    //   highlightColor: backgroundColor,
                    //   period: Duration(seconds: 6),
                    //   child: Text(
                    //     'To-do:',
                    //     style: TextStyle(fontSize: 30, color: backgroundHighlightColor),
                    //   ),
                    // ),
                    Text(
                      'To-do:',
                      style: TextStyle(
                          fontSize: 30, color: backgroundHighlightColor),
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
                      style: TextStyle(
                          fontSize: 30, color: backgroundHighlightColor),
                    ),
                    Container(
                      height: 10,
                    ),
                    Column(
                      children: getReview(),
                    ),
                  ],
                ),
              ),
            ));
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

    consolidateSingleDigit = false;
    consolidateAlphabet = false;
    consolidatePAO = false;
    consolidateDeck = false;

    setUnlockedActivities();

    setState(() {});
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

  void initializeActivityMenuButtonMap() {
    activityMenuButtonMap = {
      welcomeKey: ActivityMenuButton(
        text: 'Welcome',
        route: WelcomeScreen(),
        icon: Icon(Icons.filter),
        color: Colors.green[200],
        splashColor: Colors.green[400],
        complete1: Colors.green[200],
        complete2: Colors.green[400],
      ),
      singleDigitEditKey: ActivityMenuButton(
        text: 'Single Digit [View/Edit]',
        route: SingleDigitEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: Colors.amber[100],
        splashColor: Colors.amber[200],
        complete1: Colors.amber[200],
        complete2: Colors.amber[400],
      ),
      singleDigitPracticeKey: ActivityMenuButton(
        text: 'Single Digit [Practice]',
        route: SingleDigitPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: Colors.amber[200],
        splashColor: Colors.amber[300],
        complete1: Colors.amber[200],
        complete2: Colors.amber[400],
      ),
      singleDigitMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Single Digit [MC Test]',
        route: SingleDigitMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: Colors.amber[300],
        splashColor: Colors.amber[400],
        complete1: Colors.amber[200],
        complete2: Colors.amber[400],
      ),
      singleDigitTimedTestPrepKey: ActivityMenuButton(
        text: 'Single Digit [Test Prep]',
        route: SingleDigitTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.amber[400],
        splashColor: Colors.amber[500],
        complete1: Colors.amber[200],
        complete2: Colors.amber[400],
      ),
      singleDigitTimedTestKey: ActivityMenuButton(
        text: 'Single Digit [Timed Test]',
        route: SingleDigitTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.amber[400],
        splashColor: Colors.amber[500],
        complete1: Colors.amber[200],
        complete2: Colors.amber[400],
      ),
      faceTimedTestPrepKey: ActivityMenuButton(
        text: 'Faces [Test Prep]',
        route: FaceTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.lime[100],
        splashColor: Colors.lime[200],
        complete1: Colors.lime[200],
        complete2: Colors.lime[400],
      ),
      faceTimedTestKey: ActivityMenuButton(
        text: 'Faces [Timed Test]',
        route: FaceTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.lime[100],
        splashColor: Colors.lime[200],
        complete1: Colors.lime[200],
        complete2: Colors.lime[400],
      ),
      alphabetEditKey: ActivityMenuButton(
        text: 'Alphabet [View/Edit]',
        route: AlphabetEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: Colors.blue[100],
        splashColor: Colors.blue[200],
        complete1: Colors.blue[200],
        complete2: Colors.blue[400],
      ),
      alphabetPracticeKey: ActivityMenuButton(
        text: 'Alphabet [Practice]',
        route: AlphabetPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: Colors.blue[200],
        splashColor: Colors.blue[300],
        complete1: Colors.blue[200],
        complete2: Colors.blue[400],
      ),
      alphabetWrittenTestKey: ActivityMenuButton(
        text: 'Alphabet [Written Test]',
        route: AlphabetWrittenTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: writtenTestIcon,
        color: Colors.blue[300],
        splashColor: Colors.blue[400],
        complete1: Colors.blue[200],
        complete2: Colors.blue[400],
      ),
      alphabetTimedTestPrepKey: ActivityMenuButton(
        text: 'Alphabet [Test Prep]',
        route: AlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.blue[400],
        splashColor: Colors.blue[500],
        complete1: Colors.blue[200],
        complete2: Colors.blue[400],
      ),
      alphabetTimedTestKey: ActivityMenuButton(
        text: 'Alphabet [Timed Test]',
        route: AlphabetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.blue[400],
        splashColor: Colors.blue[500],
        complete1: Colors.blue[200],
        complete2: Colors.blue[400],
      ),
      paoEditKey: ActivityMenuButton(
        text: 'PAO [View/Edit]',
        route: PAOEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: Colors.pink[100],
        splashColor: Colors.pink[200],
        complete1: Colors.pink[200],
        complete2: Colors.pink[400],
      ),
      paoPracticeKey: ActivityMenuButton(
        text: 'PAO [Practice]',
        route: PAOPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: Colors.pink[200],
        splashColor: Colors.pink[300],
        complete1: Colors.pink[200],
        complete2: Colors.pink[400],
      ),
      paoMultipleChoiceTestKey: ActivityMenuButton(
        text: 'PAO [MC Test]',
        route: PAOMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: Colors.pink[300],
        splashColor: Colors.pink[400],
        complete1: Colors.pink[200],
        complete2: Colors.pink[400],
      ),
      paoTimedTestPrepKey: ActivityMenuButton(
        text: 'PAO [Test Prep]',
        route: PAOTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.pink[400],
        splashColor: Colors.pink[500],
        complete1: Colors.pink[200],
        complete2: Colors.pink[400],
      ),
      paoTimedTestKey: ActivityMenuButton(
        text: 'PAO [Timed Test]',
        route: PAOTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.pink[400],
        splashColor: Colors.pink[500],
        complete1: Colors.pink[200],
        complete2: Colors.pink[400],
      ),
      piTimedTestPrepKey: ActivityMenuButton(
        text: 'Pi [Test Prep]',
        route: PiTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.green[400],
        splashColor: Colors.green[500],
        complete1: Colors.green[200],
        complete2: Colors.green[400],
      ),
      piTimedTestKey: ActivityMenuButton(
        text: 'Pi [Timed Test]',
        route: PiTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.green[400],
        splashColor: Colors.green[500],
        complete1: Colors.green[200],
        complete2: Colors.green[400],
      ),
      deckEditKey: ActivityMenuButton(
        text: 'Deck [View/Edit]',
        route: DeckEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: Colors.teal[100],
        splashColor: Colors.teal[200],
        complete1: Colors.teal[200],
        complete2: Colors.teal[400],
      ),
      deckPracticeKey: ActivityMenuButton(
        text: 'Deck [Practice]',
        route: DeckPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: Colors.teal[200],
        splashColor: Colors.teal[300],
        complete1: Colors.teal[200],
        complete2: Colors.teal[400],
      ),
      deckMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Deck [MC Test]',
        route: DeckMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: Colors.teal[300],
        splashColor: Colors.teal[400],
        complete1: Colors.teal[200],
        complete2: Colors.teal[400],
      ),
      deckTimedTestPrepKey: ActivityMenuButton(
        text: 'Deck [Test Prep]',
        route: DeckTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: Colors.teal[400],
        splashColor: Colors.teal[500],
        complete1: Colors.teal[200],
        complete2: Colors.teal[400],
      ),
      deckTimedTestKey: ActivityMenuButton(
        text: 'Deck [Timed Test]',
        route: DeckTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: Colors.teal[400],
        splashColor: Colors.teal[500],
        complete1: Colors.teal[200],
        complete2: Colors.teal[400],
      ),
    };
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
            'info icon in the top right corner! Also check out the preferences, where you can toggle '
            'dark mode! '
      ],
      buttonColor: Colors.grey[200],
      buttonSplashColor: Colors.grey[300],
    );
  }
}
