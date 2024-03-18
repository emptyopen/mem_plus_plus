import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_edit_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_practice_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_timed_test_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter/services.dart';

import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/screens/day_or_older_activities_screen.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/screens/settings_screen.dart';
import 'package:mem_plus_plus/screens/games/games_screen.dart';
import 'package:mem_plus_plus/screens/custom_memory/custom_memory_manager_screen.dart';
import 'package:mem_plus_plus/screens/custom_memory/custom_memory_test_screen.dart';
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
import 'package:mem_plus_plus/screens/chapter1/face_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter1/face_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_edit_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_practice_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/deck/deck_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter3/pi_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter3/pi_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter3/face_2_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter3/face_2_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter1/planet_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter1/planet_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter2/airport_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter2/airport_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter2/phonetic_alphabet_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/chapter2/phonetic_alphabet_timed_test_screen.dart';
import 'package:mem_plus_plus/screens/chapter1/lesson_1_screen.dart';
import 'package:mem_plus_plus/screens/chapter2/lesson_2_screen.dart';
import 'package:mem_plus_plus/screens/chapter3/lesson_3_screen.dart';

import '../constants/keys.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// Chapter 0
// welcome

// Chapter 1
// single digit
// - quick lesson 1: Don't get discouraged! If you forgot something, it just wasn't anchored correctly, or it wasn't vivid enough.
// - face test (with age)
// - planet test

// Chapter 2
// alphabet
// - quick lesson 2: Memory palace!!
// - phonetic alphabet (use memory palace)
// - airline confirmation code / flight number / departure time / seat number

// Chapter 3
// pao
// - quick lesson 3: spaced repetition
// * custom memory manager
// - pi test
// - face test #2: first and last name, occupation, hometown

// ---- paywall -----

// Chapter 4
// deck
// - conversion rates
// - recipes
// - first aid
// - doomsday test
// - periodic table

// done:

// next up:
// figure out local notifications once and for all
// show irrational test animation for completion
// custom memory can't always submit answer? check if wrong
// when adding alphabet and PAO, check for overlap with existing objects (single digit, alphabet, etc)

// horizon:
// add trivia games (order of US presidents, British monarchies?) - unlock first set after planet test
// add FIND THE CARD game, memory show all cards for some amount of time, then flip over
// BIG: add date & recipe system
// welcome animation, second page still visible until swipe? (and other swiping pages only first page)
// handle bad CSV input
// figure out how to handle CSV on iphone (doesn't launch google sheets well?) button in CSV to copy text?
// check callback for adding custom ID vs others?
// investigate potential slow encrypting
// add recipe as custom test
// for small phones, add bottom opacity for scrolling screens (dots overlay), indicator to scroll!!
// BIG: badge / quest system
// BIG: once you beat something (like a timed test, it gets harder, up to three levels???) / or choose amount of time for timed tests
// describe amount of pi correct
// chapter animation
// add scroll notification when scrollable: https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac
// match ages for face (hard)
// divide photos (file names?) into ethnicities / age / gender buckets? choose characteristics first, then pick photo
// implement length limits for inputs (like action/object) - maybe 30 characters
// add conversion rates
// add doomsday memory rule
// add first aid system
// add more faces, make all of them closer to the face
// alphabet PAO (person action, same object)
// add symbols
// add password test
// add safe viewing area (for toolbar)
// add global celebration animation whenever there is a level up (or more animation in general, FLARE?)
// crashlytics for IOS
// look into possible battery drainage from refreshing screen? emulator seems to run hot
// add name (first time, and preferences) - use in local notifications
// add ability for alphabet to contain up to 3 objects (level up system?)
// make PAO multiple choice tougher with similar digits
// make vibrations cooler, and more consistent across app?
// make account, backend, retrieve portfolios
// delete old memory dict keys for custom memories when you delete the memory
// BIG: add backend, account recovery (store everything?)

// TODO:  Brain by Arjun Adamson from the Noun Project
// https://medium.com/@psyanite/how-to-add-app-launcher-icons-in-flutter-bd92b0e0873a
// Icons made by <a href="https://www.flaticon.com/authors/dimitry-miroliubov" title="Dimitry Miroliubov">Dimitry Miroliubov</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  List<String> availableActivities = [];
  Map? customMemories;
  Map? activityMenuButtonMap;
  bool? firstTimeOpeningApp;
  bool customMemoryManagerAvailable = false;
  bool customMemoryManagerFirstView = false;
  bool gamesAvailable = false;
  bool gamesFirstView = false;
  final globalKey = GlobalKey<ScaffoldState>();
  bool consolidateSingleDigit = false;
  bool consolidateChapter1 = false;
  bool consolidateAlphabet = false;
  bool consolidateChapter2 = false;
  bool consolidatePAO = false;
  bool consolidateChapter3 = false;
  bool consolidateDeck = false;
  bool consolidateTripleDigit = false;
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    handleAppUpdate();
    setState(() {});
    getSharedPrefs();
    initializeActivityMenuButtonMap();
    new Timer.periodic(
      Duration(milliseconds: 100),
      (Timer t) => setState(() {}),
    );
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(darkModeKey) == null || !(prefs.getBool(darkModeKey))!) {
      backgroundColor = Colors.white;
      backgroundHighlightColor = Colors.black;
      backgroundSemiColor = Colors.grey[200]!;
      backgroundSemiHighlightColor = Colors.grey[800]!;
    } else {
      backgroundColor = Colors.grey[800]!;
      backgroundHighlightColor = Colors.white;
      backgroundSemiColor = Colors.grey[600]!;
      backgroundSemiHighlightColor = Colors.grey[200]!;
    }
    setState(() {});

    // activity states, and unlockedActivities
    if (prefs.getKeys().contains(activityStatesKey)) {
      setState(() {
        var rawMap = json.decode(prefs.getString(activityStatesKey)!)
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

    // check if games are available, and firstView
    if (await prefs.getBool(gamesAvailableKey) == null) {
      gamesAvailable = false;
    } else {
      gamesAvailable = true;
    }
    if (await prefs.getBool(newGamesAvailableKey) == null ||
        await prefs.getBool(newGamesAvailableKey) == false) {
      gamesFirstView = false;
    } else {
      gamesFirstView = true;
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
      customMemories = (await prefs.getSharedPrefs(customMemoriesKey) as Map);
    }

    // backwards compatibility:
    // if deck is available, make triple digit available
    if (await prefs.getActivityVisible(deckEditKey) &&
        !(await prefs.getActivityVisible(tripleDigitEditKey))) {
      await prefs.updateActivityState(tripleDigitEditKey, 'todo');
      await prefs.updateActivityVisible(tripleDigitEditKey, true);
    }

    // iterate through all activity states, add activities if they are visible
    availableActivities = [];
    activityStates =
        await prefs.getSharedPrefs(activityStatesKey) as Map<String, Activity>;

    for (String activityName in activityStates.keys) {
      if (activityStates[activityName]!.visible) {
        availableActivities.add(activityName);
      }
    }

    // consolidate menu buttons
    if (await prefs.getBool(singleDigitTimedTestCompleteKey) != null) {
      consolidateSingleDigit = true;
    }
    if (await prefs.getBool(planetTimedTestCompleteKey) != null &&
        await prefs.getBool(faceTimedTestCompleteKey) != null) {
      consolidateChapter1 = true;
    }
    if (await prefs.getBool(alphabetTimedTestCompleteKey) != null) {
      consolidateAlphabet = true;
    }
    if (await prefs.getBool(phoneticAlphabetTimedTestCompleteKey) != null &&
        await prefs.getBool(airportTimedTestCompleteKey) != null) {
      consolidateChapter2 = true;
    }
    if (await prefs.getBool(paoTimedTestCompleteKey) != null) {
      consolidatePAO = true;
    }
    if (await prefs.getBool(piTimedTestCompleteKey) != null &&
        await prefs.getBool(face2TimedTestCompleteKey) != null) {
      consolidateChapter3 = true;
    }
    if (await prefs.getBool(deckTimedTestCompleteKey) != null) {
      consolidateDeck = true;
    }
    if (await prefs.getBool(tripleDigitTimedTestCompleteKey) != null) {
      consolidateTripleDigit = true;
    }

    setState(() {});
    //print(activityStates);
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

  checkGamesFirstTime() async {
    if (await prefs.getBool(newGamesAvailableKey) == true) {
      setState(() {
        gamesFirstView = false;
      });
      await prefs.setBool(newGamesAvailableKey, false);
    }
    slideTransition(
      context,
      GamesScreen(
        callback: callback,
      ),
    );
  }

  checkCustomMemoryManagerFirstTime() async {
    if (await prefs.getBool(customMemoryManagerFirstHelpKey) == true) {
      setState(() {
        customMemoryManagerFirstView = false;
      });
      await prefs.setBool(customMemoryManagerFirstHelpKey, false);
    }
    slideTransition(
      context,
      CustomMemoryManagerScreen(callback: callback),
    );
  }

  callback() {
    setUnlockedActivities();
  }

  List<Widget> getTodo() {
    List<Widget> mainMenuOptions = [];
    List<Activity> availableNowActivities = [];

    List<String> names = [];
    List<DateTime> availableTimes = [];
    List<IconData> icons = [];
    List<String> nameKeys = [];

    // custom tests
    customMemories.forEach((title, memory) {
      var nextDateTime = DateTime.parse(memory['nextDatetime']);
      var activity = Activity('test', 'todo', true, nextDateTime, false);
      var customIcon = customMemoryIconMap[memory['type']];
      if (activity.visibleAfterTime.compareTo(DateTime.now()) > 0) {
        availableNowActivities.add(activity);
      }
      if (activity.visibleAfterTime.difference(DateTime.now()) >
          Duration(days: 1)) {
        names.add(title);
        availableTimes.add(activity.visibleAfterTime);
        icons.add(customIcon);
        nameKeys.add('');
      } else {
        mainMenuOptions.add(
          MainMenuOption(
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
            globalKey: globalKey,
            isCustomTest: true,
          ),
        );
      }
    });

    // regular activities
    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'todo') {
        if (activityStates[activity]
                .visibleAfterTime
                .compareTo(DateTime.now()) >
            0) {
          availableNowActivities.add(activityStates[activity]);
        }
        if (activityStates[activity]
                .visibleAfterTime
                .difference(DateTime.now()) >
            Duration(days: 1)) {
          names.add(activityStates[activity].name);
          availableTimes.add(activityStates[activity].visibleAfterTime);
          icons.add(activityMenuButtonMap[activity].icon.icon);
          nameKeys.add(activityStates[activity].name);
        } else {
          mainMenuOptions.add(
            MainMenuOption(
              callback: callback,
              activity: activityStates[activity],
              text: activityMenuButtonMap[activity].text,
              route: activityMenuButtonMap[activity].route,
              icon: activityMenuButtonMap[activity].icon,
              color: activityMenuButtonMap[activity].color,
              splashColor: activityMenuButtonMap[activity].splashColor,
              globalKey: globalKey,
            ),
          );
        }
      }
    }

    // if nothing in todo, send button to go to custom memories (use same button/text template as 24hr +)
    if (mainMenuOptions.length == 0 && customMemoryManagerAvailable) {
      mainMenuOptions.add(MainMenuOption(
        text:
            'You\'ve got nothing to do! Add some memories in the memory manager!',
        isButton: true,
        color: colorCustomMemoryLighter,
        function: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                CustomMemoryManagerScreen(),
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
        ),
      ));
    }

    // for all items over 24 hours, consolidate in single button to view
    if (names.length > 0) {
      mainMenuOptions.add(MainMenuOption(
        text:
            'You have ${names.length} upcoming tests in more than a day! Click here to view.',
        isButton: true,
        textColor: Colors.white,
        color: Color.fromRGBO(0, 0, 0, 0.85),
        function: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                DayOrOlderActivitiesScreen(
              names: names,
              availableTimes: availableTimes,
              icons: icons,
              nameKeys: nameKeys,
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
        ),
      ));
    }

    return mainMenuOptions;
  }

  List<Widget> getReview() {
    List<Widget> mainMenuOptions = [];

    for (String activity in availableActivities) {
      // only look at activities in review
      if (activityStates[activity] != null &&
          activityStates[activity].state == 'review') {
        bool consolidated = false;
        if (activity.contains(singleDigitKey) && consolidateSingleDigit) {
          consolidated = true;
        }
        if ((activity == lesson1Key ||
                activity == planetTimedTestPrepKey ||
                activity == faceTimedTestPrepKey) &&
            consolidateChapter1) {
          consolidated = true;
        }
        if (activity.contains(alphabetKey) &&
            !activity.contains('Phonetic') &&
            consolidateAlphabet) {
          consolidated = true;
        }
        if ((activity == lesson2Key ||
                activity == phoneticAlphabetTimedTestPrepKey ||
                activity == airportTimedTestPrepKey) &&
            consolidateChapter2) {
          consolidated = true;
        }
        if (activity.contains(paoKey) && consolidatePAO) {
          consolidated = true;
        }
        if ((activity == lesson3Key ||
                activity == piTimedTestPrepKey ||
                activity == face2TimedTestPrepKey) &&
            consolidateChapter3) {
          consolidated = true;
        }
        if (activity.contains(deckKey) && consolidateDeck) {
          consolidated = true;
        }
        if (activity.contains(tripleDigitKey) && consolidateTripleDigit) {
          consolidated = true;
        }
        if (!consolidated) {
          mainMenuOptions.add(
            MainMenuOption(
              callback: callback,
              activity: activityStates[activity],
              text: activityMenuButtonMap[activity].text,
              route: activityMenuButtonMap[activity].route,
              icon: activityMenuButtonMap[activity].icon,
              color: activityMenuButtonMap[activity].color,
              splashColor: activityMenuButtonMap[activity].splashColor,
              globalKey: globalKey,
            ),
          );
        }
      }
      if (activity == singleDigitEditKey && consolidateSingleDigit) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Single Digit System',
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
      if (activity == lesson1Key && consolidateChapter1) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 1: The Basics',
            standardColor: colorChapter1Lighter,
            darkerColor: colorChapter1Darker,
            lesson: activityStates[lesson1Key],
            lessonRoute: Lesson1Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[faceTimedTestPrepKey],
            activity1Icon: faceIcon,
            activity1Route: FaceTimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[planetTimedTestPrepKey],
            activity2Icon: planetIcon,
            activity2Route: PlanetTimedTestPrepScreen(
              callback: callback,
            ),
            callback: callback,
          ),
        );
      }
      if (activity == alphabetEditKey && consolidateAlphabet) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Alphabet System',
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
      if (activity == lesson2Key && consolidateChapter2) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 2: Memory Palace',
            standardColor: colorChapter2Lighter,
            darkerColor: colorChapter2Darker,
            lesson: activityStates[lesson2Key],
            lessonRoute: Lesson2Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[phoneticAlphabetTimedTestPrepKey],
            activity1Icon: phoneticIcon,
            activity1Route: PhoneticAlphabetTimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[airportTimedTestPrepKey],
            activity2Icon: airportIcon,
            activity2Route: AirportTimedTestPrepScreen(
              callback: callback,
            ),
            callback: callback,
          ),
        );
      }
      if (activity == paoEditKey && consolidatePAO) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'PAO System',
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
      if (activity == lesson3Key && consolidateChapter3) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 3: Spaced Repetition',
            standardColor: colorChapter3Lighter,
            darkerColor: colorChapter3Darker,
            lesson: activityStates[lesson3Key],
            lessonRoute: Lesson3Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[face2TimedTestPrepKey],
            activity1Icon: face2Icon,
            activity1Route: Face2TimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[piTimedTestPrepKey],
            activity2Icon: piIcon,
            activity2Route: PiTimedTestPrepScreen(
              callback: callback,
            ),
            callback: callback,
          ),
        );
      }
      if (activity == deckEditKey && consolidateDeck) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Deck System',
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
      if (activity == tripleDigitEditKey && consolidateTripleDigit) {
        mainMenuOptions.add(
          CondensedMainMenuButtons(
            text: 'Triple Digit System',
            backgroundColor: colorTripleDigitStandard,
            buttonColor: colorTripleDigitDarker,
            buttonSplashColor: colorTripleDigitDarkest,
            editActivity: activityStates[tripleDigitEditKey],
            editRoute: TripleDigitEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[tripleDigitPracticeKey],
            practiceRoute: TripleDigitPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[tripleDigitMultipleChoiceTestKey],
            testIcon: multipleChoiceTestIcon,
            testRoute: TripleDigitMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[tripleDigitTimedTestPrepKey],
            timedTestPrepRoute: TripleDigitTimedTestPrepScreen(
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
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return firstTimeOpeningApp == null
        ? Scaffold()
        : Scaffold(
            backgroundColor: backgroundColor,
            key: globalKey,
            appBar: AppBar(
              title: Text('MEM++ Homepage'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    HapticFeedback.lightImpact();
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
                    HapticFeedback.lightImpact();
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) {
                          return HomepageHelp();
                        }));
                  },
                ),
              ],
            ),
            body: Container(
              height: screenHeight,
              width: screenWidth,
              child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(color: backgroundColor),
                      padding: EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
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
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 200,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              backgroundColor.withOpacity(0.0),
                              backgroundColor.withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: gamesAvailable
                        ? Stack(
                            children: <Widget>[
                              BigButton(
                                title: 'Games',
                                function: checkGamesFirstTime,
                                color1: Colors.lightBlueAccent,
                                color2: Colors.lightBlue[700],
                              ),
                              gamesFirstView ? NewTag(top: 10) : Container()
                            ],
                          )
                        : Container(),
                    bottom: 25,
                    left: 25,
                  ),
                  Positioned(
                    child: customMemoryManagerAvailable
                        ? Stack(
                            children: <Widget>[
                              BigButton(
                                title: 'Memories',
                                function: checkCustomMemoryManagerFirstTime,
                                color1: Colors.purpleAccent,
                                color2: Colors.purple,
                              ),
                              customMemoryManagerFirstView
                                  ? NewTag()
                                  : Container()
                            ],
                          )
                        : Container(),
                    bottom: 25,
                    right: 25,
                  ),
                ],
              ),
            ),
          );
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
    consolidateChapter1 = false;
    consolidateAlphabet = false;
    consolidateChapter2 = false;
    consolidatePAO = false;
    consolidateDeck = false;

    setUnlockedActivities();

    Navigator.of(context).pop();

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

  maxOutKeys(int maxTo) async {
    await prefs.setBool(customMemoryManagerAvailableKey, true);
    await prefs.setBool(customMemoryManagerFirstHelpKey, true);
    customMemoryManagerFirstView = true;
    customMemoryManagerAvailable = true;
    await prefs.setBool(gamesAvailableKey, true);
    await prefs.setBool(gamesFirstHelpKey, true);
    gamesAvailable = true;
    gamesFirstView = true;

    if (maxTo >= 2) {
      await prefs.setBool(singleDigitTimedTestCompleteKey, true);
      await prefs.setBool(alphabetTimedTestCompleteKey, true);
      await prefs.setBool(planetTimedTestCompleteKey, true);
      await prefs.setBool(faceTimedTestCompleteKey, true);
      await prefs.setBool(airportTimedTestCompleteKey, true);
      await prefs.setBool(phoneticAlphabetTimedTestCompleteKey, true);
      await prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter2Done);
      await prefs.setBool(fadeGameAvailableKey, true);
      await prefs.setBool(morseGameAvailableKey, true);
    }
    if (maxTo >= 3) {
      await prefs.setBool(paoTimedTestCompleteKey, true);
      await prefs.setBool(piTimedTestCompleteKey, true);
      await prefs.setBool(face2TimedTestCompleteKey, true);
      await prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter3Done);
      await prefs.setBool(irrationalGameAvailableKey, true);
      await prefs.setBool(deckEditKey, true);
    }
    if (maxTo >= 4) {
      await prefs.setBool(deckTimedTestCompleteKey, true);
      await prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter3Done);
    }
    if (maxTo >= 5) {
      await prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesAllDone);
    }

    setUnlockedActivities();
  }

  void initializeActivityMenuButtonMap() {
    activityMenuButtonMap = {
      welcomeKey: ActivityMenuButton(
        text: 'Welcome',
        route: WelcomeScreen(),
        icon: Icon(Icons.filter),
        color: Colors.green[200],
        splashColor: Colors.green[600],
      ),
      singleDigitEditKey: ActivityMenuButton(
        text: 'Single Digit [View/Edit]',
        route: SingleDigitEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitPracticeKey: ActivityMenuButton(
        text: 'Single Digit [Practice]',
        route: SingleDigitPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Single Digit [MC Test]',
        route: SingleDigitMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitTimedTestPrepKey: ActivityMenuButton(
        text: 'Single Digit [Test Prep]',
        route: SingleDigitTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitTimedTestKey: ActivityMenuButton(
        text: 'Single Digit [Timed Test]',
        route: SingleDigitTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      lesson1Key: ActivityMenuButton(
        text: 'Chapter 1 Lesson:',
        route: Lesson1Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      faceTimedTestPrepKey: ActivityMenuButton(
        text: 'Faces (Easy) [Test Prep]',
        route: FaceTimedTestPrepScreen(
          callback: callback,
        ),
        icon: faceIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      faceTimedTestKey: ActivityMenuButton(
        text: 'Faces (Easy) [Timed Test]',
        route: FaceTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: faceIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      planetTimedTestPrepKey: ActivityMenuButton(
        text: 'Planets [Test Prep]',
        route: PlanetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: planetIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      planetTimedTestKey: ActivityMenuButton(
        text: 'Planets [Timed Test]',
        route: PlanetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: planetIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      alphabetEditKey: ActivityMenuButton(
        text: 'Alphabet [View/Edit]',
        route: AlphabetEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetPracticeKey: ActivityMenuButton(
        text: 'Alphabet [Practice]',
        route: AlphabetPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetWrittenTestKey: ActivityMenuButton(
        text: 'Alphabet [Written Test]',
        route: AlphabetWrittenTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: writtenTestIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetTimedTestPrepKey: ActivityMenuButton(
        text: 'Alphabet [Test Prep]',
        route: AlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetTimedTestKey: ActivityMenuButton(
        text: 'Alphabet [Timed Test]',
        route: AlphabetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      lesson2Key: ActivityMenuButton(
        text: 'Chapter 2 Lesson:',
        route: Lesson2Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      phoneticAlphabetTimedTestPrepKey: ActivityMenuButton(
        text: 'Phonetic Alphabet [Test Prep]',
        route: PhoneticAlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: phoneticIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      phoneticAlphabetTimedTestKey: ActivityMenuButton(
        text: 'Phonetic Alphabet [Timed Test]',
        route: PhoneticAlphabetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: phoneticIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      airportTimedTestPrepKey: ActivityMenuButton(
        text: 'Airport [Test Prep]',
        route: AirportTimedTestPrepScreen(
          callback: callback,
        ),
        icon: airportIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      airportTimedTestKey: ActivityMenuButton(
        text: 'Airport [Timed Test]',
        route: AirportTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: airportIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      paoEditKey: ActivityMenuButton(
        text: 'PAO [View/Edit]',
        route: PAOEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoPracticeKey: ActivityMenuButton(
        text: 'PAO [Practice]',
        route: PAOPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoMultipleChoiceTestKey: ActivityMenuButton(
        text: 'PAO [MC Test]',
        route: PAOMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoTimedTestPrepKey: ActivityMenuButton(
        text: 'PAO [Test Prep]',
        route: PAOTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoTimedTestKey: ActivityMenuButton(
        text: 'PAO [Timed Test]',
        route: PAOTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      lesson3Key: ActivityMenuButton(
        text: 'Chapter 3 Lesson:',
        route: Lesson3Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      face2TimedTestPrepKey: ActivityMenuButton(
        text: 'Faces (Hard) [Test Prep]',
        route: Face2TimedTestPrepScreen(
          callback: callback,
        ),
        icon: face2Icon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      face2TimedTestKey: ActivityMenuButton(
        text: 'Faces (Hard) [Timed Test]',
        route: Face2TimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: face2Icon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      piTimedTestPrepKey: ActivityMenuButton(
        text: 'Pi [Test Prep]',
        route: PiTimedTestPrepScreen(
          callback: callback,
        ),
        icon: piIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      piTimedTestKey: ActivityMenuButton(
        text: 'Pi [Timed Test]',
        route: PiTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: piIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      deckEditKey: ActivityMenuButton(
        text: 'Deck [View/Edit]',
        route: DeckEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckPracticeKey: ActivityMenuButton(
        text: 'Deck [Practice]',
        route: DeckPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Deck [MC Test]',
        route: DeckMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckTimedTestPrepKey: ActivityMenuButton(
        text: 'Deck [Test Prep]',
        route: DeckTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckTimedTestKey: ActivityMenuButton(
        text: 'Deck [Timed Test]',
        route: DeckTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      tripleDigitEditKey: ActivityMenuButton(
        text: 'Triple Digit [View/Edit]',
        route: TripleDigitEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitPracticeKey: ActivityMenuButton(
        text: 'Triple Digit [Practice]',
        route: TripleDigitPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Triple Digit [MC Test]',
        route: TripleDigitMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitTimedTestPrepKey: ActivityMenuButton(
        text: 'Triple Digit [Test Prep]',
        route: TripleDigitTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitTimedTestKey: ActivityMenuButton(
        text: 'Triple Digit [Timed Test]',
        route: TripleDigitTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
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
