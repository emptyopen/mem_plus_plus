import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/big_button.dart';
import 'package:mem_plus_plus/components/standard/condensed_main_menu_buttons.dart';
import 'package:mem_plus_plus/components/standard/condensed_main_menu_chapter_buttons.dart';
import 'package:mem_plus_plus/components/standard/main_menu_option.dart';
import 'package:mem_plus_plus/components/standard/new_tag.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_edit_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_multiple_choice_test_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_practice_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_timed_test_prep_screen.dart';
import 'package:mem_plus_plus/screens/triple_digit/triple_digit_timed_test_screen.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:convert';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter/services.dart';

import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/screens/day_or_older_activities_screen.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Activity> activityStates = {};
  List<String> availableActivities = [];
  Map customMemories = {};
  Map activityMenuButtonMap = {};
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
  PrefsUpdater prefs = PrefsUpdater();

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

  getSharedPrefs() {
    if (prefs.getBool(darkModeKey)) {
      backgroundColor = Colors.grey[800]!;
      backgroundHighlightColor = Colors.white;
      backgroundSemiColor = Colors.grey[600]!;
      backgroundSemiHighlightColor = Colors.grey[200]!;
    } else {
      backgroundColor = Colors.white;
      backgroundHighlightColor = Colors.black;
      backgroundSemiColor = Colors.grey[200]!;
      backgroundSemiHighlightColor = Colors.grey[800]!;
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

  void setUnlockedActivities() {
    print('setting unlocked activities');
    // if first time opening app, welcome
    if (!prefs.getBool(firstTimeAppKey)) {
      print('first time opening app');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      });
    }

    // check if games are available, and firstView
    if (prefs.getBool(gamesAvailableKey)) {
      gamesAvailable = true;
    } else {
      gamesAvailable = false;
    }
    if (prefs.getBool(newGamesAvailableKey)) {
      gamesFirstView = true;
    } else {
      gamesFirstView = false;
    }

    // check if customManager is available, and firstView
    if (prefs.getBool(customMemoryManagerAvailableKey)) {
      customMemoryManagerAvailable = true;
    } else {
      customMemoryManagerAvailable = false;
    }
    if (!prefs.getBool(customMemoryManagerFirstHelpKey)) {
      customMemoryManagerFirstView = true;
    } else {
      customMemoryManagerFirstView = false;
    }

    // get custom memories
    if (prefs.getString(customMemoriesKey) == '') {
      customMemories = {};
      prefs.writeSharedPrefs(customMemoriesKey, {});
    } else {
      customMemories = (prefs.getSharedPrefs(customMemoriesKey) as Map);
    }

    // backwards compatibility:
    // if deck is available, make triple digit available
    if (prefs.getActivityVisible(deckEditKey) &&
        !(prefs.getActivityVisible(tripleDigitEditKey))) {
      prefs.updateActivityState(tripleDigitEditKey, 'todo');
      prefs.updateActivityVisible(tripleDigitEditKey, true);
    }

    // iterate through all activity states, add activities if they are visible
    availableActivities = [];
    activityStates =
        prefs.getSharedPrefs(activityStatesKey) as Map<String, Activity>;

    for (String activityName in activityStates.keys) {
      if (activityStates[activityName]!.visible) {
        availableActivities.add(activityName);
      }
    }

    // consolidate menu buttons
    if (prefs.getBool(singleDigitTimedTestCompleteKey)) {
      consolidateSingleDigit = true;
    }
    if (prefs.getBool(planetTimedTestCompleteKey) &&
        prefs.getBool(faceTimedTestCompleteKey)) {
      consolidateChapter1 = true;
    }
    if (prefs.getBool(alphabetTimedTestCompleteKey)) {
      consolidateAlphabet = true;
    }
    if (prefs.getBool(phoneticAlphabetTimedTestCompleteKey) &&
        prefs.getBool(airportTimedTestCompleteKey)) {
      consolidateChapter2 = true;
    }
    if (prefs.getBool(paoTimedTestCompleteKey)) {
      consolidatePAO = true;
    }
    if (prefs.getBool(piTimedTestCompleteKey) &&
        prefs.getBool(face2TimedTestCompleteKey)) {
      consolidateChapter3 = true;
    }
    if (prefs.getBool(deckTimedTestCompleteKey)) {
      consolidateDeck = true;
    }
    if (prefs.getBool(tripleDigitTimedTestCompleteKey)) {
      consolidateTripleDigit = true;
    }

    setState(() {});
  }

  checkFirstTime() {
    if (!prefs.getBool(homepageFirstHelpKey)) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return HomepageHelp(callback: callback);
          }));
      prefs.setBool(homepageFirstHelpKey, true);
    }
  }

  checkGamesFirstTime() {
    setState(() {
      gamesFirstView = false;
    });
    prefs.setBool(newGamesAvailableKey, false);
    slideTransition(
      context,
      GamesScreen(
        callback: callback,
      ),
    );
  }

  checkCustomMemoryManagerFirstTime() {
    if (prefs.getBool(customMemoryManagerFirstHelpKey)) {
      setState(() {
        customMemoryManagerFirstView = false;
      });
      prefs.setBool(customMemoryManagerFirstHelpKey, false);
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
            icon: customIcon,
            text: '${memory['type']}: $title',
            route: CustomMemoryTestScreen(
              customMemory: memory,
              callback: callback,
              globalKey: globalKey,
            ),
            callback: callback,
            color: Colors.purple[400]!,
            splashColor: Colors.purple[500]!,
            isCustomTest: true,
          ),
        );
      }
    });

    // regular activities
    for (String activity in availableActivities) {
      if (activityStates[activity] != null &&
          activityStates[activity]!.state == 'todo') {
        if (activityStates[activity]!
                .visibleAfterTime
                .compareTo(DateTime.now()) >
            0) {
          availableNowActivities.add(activityStates[activity]!);
        }
        if (activityStates[activity]!
                .visibleAfterTime
                .difference(DateTime.now()) >
            Duration(days: 1)) {
          names.add(activityStates[activity]!.name);
          availableTimes.add(activityStates[activity]!.visibleAfterTime);
          icons.add(activityMenuButtonMap[activity].icon.icon);
          nameKeys.add(activityStates[activity]!.name);
        } else {
          // print('adding $activity to main menu options');
          mainMenuOptions.add(
            MainMenuOption(
              callback: callback,
              activity: activityStates[activity]!,
              text: activityMenuButtonMap[activity].text,
              route: activityMenuButtonMap[activity].route,
              icon: activityMenuButtonMap[activity].icon,
              color: activityMenuButtonMap[activity].color,
              splashColor: activityMenuButtonMap[activity].splashColor,
            ),
          );
        }
      }
    }

    // if nothing in todo, send button to go to custom memories (use same button/text template as 24hr +)
    if (mainMenuOptions.length == 0 && customMemoryManagerAvailable) {
      mainMenuOptions.add(MainMenuOption(
        text:
            'You\'ve got nothing to do! Tap to add some memories in the memory manager!',
        isButton: true,
        color: colorCustomMemoryLighter,
        splashColor: colorCustomMemoryLighter,
        function: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                CustomMemoryManagerScreen(
              callback: () {},
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

    // for all items over 24 hours, consolidate in single button to view
    if (names.length > 0) {
      mainMenuOptions.add(MainMenuOption(
        text:
            'You have ${names.length} upcoming tests in more than a day! Click here to view.',
        isButton: true,
        textColor: Colors.white,
        splashColor: Colors.black,
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
          activityStates[activity]!.state == 'review') {
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
              activity: activityStates[activity]!,
              text: activityMenuButtonMap[activity].text,
              route: activityMenuButtonMap[activity].route,
              icon: activityMenuButtonMap[activity].icon,
              color: activityMenuButtonMap[activity].color,
              splashColor: activityMenuButtonMap[activity].splashColor,
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
            editActivity: activityStates[singleDigitEditKey]!,
            editRoute: SingleDigitEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[singleDigitPracticeKey]!,
            practiceRoute: SingleDigitPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[singleDigitMultipleChoiceTestKey]!,
            testIcon: multipleChoiceTestIcon,
            testRoute: SingleDigitMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[singleDigitTimedTestPrepKey]!,
            timedTestPrepRoute: SingleDigitTimedTestPrepScreen(
              callback: callback,
            ),
            callback: () {},
          ),
        );
      }
      if (activity == lesson1Key && consolidateChapter1) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 1: The Basics',
            standardColor: colorChapter1Lighter,
            darkerColor: colorChapter1Darker,
            lesson: activityStates[lesson1Key]!,
            lessonRoute: Lesson1Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[faceTimedTestPrepKey]!,
            activity1Icon: faceIcon,
            activity1Route: FaceTimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[planetTimedTestPrepKey]!,
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
            editActivity: activityStates[alphabetEditKey]!,
            editRoute: AlphabetEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[alphabetPracticeKey]!,
            practiceRoute: AlphabetPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[alphabetWrittenTestKey]!,
            testIcon: writtenTestIcon,
            testRoute: AlphabetWrittenTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[alphabetTimedTestPrepKey]!,
            timedTestPrepRoute: AlphabetTimedTestPrepScreen(
              callback: callback,
            ),
            callback: () {},
          ),
        );
      }
      if (activity == lesson2Key && consolidateChapter2) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 2: Memory Palace',
            standardColor: colorChapter2Lighter,
            darkerColor: colorChapter2Darker,
            lesson: activityStates[lesson2Key]!,
            lessonRoute: Lesson2Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[phoneticAlphabetTimedTestPrepKey]!,
            activity1Icon: phoneticIcon,
            activity1Route: PhoneticAlphabetTimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[airportTimedTestPrepKey]!,
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
            editActivity: activityStates[paoEditKey]!,
            editRoute: PAOEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[paoPracticeKey]!,
            practiceRoute: PAOPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[paoMultipleChoiceTestKey]!,
            testIcon: multipleChoiceTestIcon,
            testRoute: PAOMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[paoTimedTestPrepKey]!,
            timedTestPrepRoute: PAOTimedTestPrepScreen(
              callback: callback,
            ),
            callback: () {},
          ),
        );
      }
      if (activity == lesson3Key && consolidateChapter3) {
        mainMenuOptions.add(
          CondensedMainMenuChapterButtons(
            text: 'Chapter 3: Spaced Repetition',
            standardColor: colorChapter3Lighter,
            darkerColor: colorChapter3Darker,
            lesson: activityStates[lesson3Key]!,
            lessonRoute: Lesson3Screen(
              callback: callback,
              globalKey: globalKey,
            ),
            activity1: activityStates[face2TimedTestPrepKey]!,
            activity1Icon: face2Icon,
            activity1Route: Face2TimedTestPrepScreen(
              callback: callback,
            ),
            activity2: activityStates[piTimedTestPrepKey]!,
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
            editActivity: activityStates[deckEditKey]!,
            editRoute: DeckEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[deckPracticeKey]!,
            practiceRoute: DeckPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[deckMultipleChoiceTestKey]!,
            testIcon: multipleChoiceTestIcon,
            testRoute: DeckMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[deckTimedTestPrepKey]!,
            timedTestPrepRoute: DeckTimedTestPrepScreen(
              callback: callback,
            ),
            callback: () {},
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
            editActivity: activityStates[tripleDigitEditKey]!,
            editRoute: TripleDigitEditScreen(
              callback: callback,
            ),
            practiceActivity: activityStates[tripleDigitPracticeKey]!,
            practiceRoute: TripleDigitPracticeScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            testActivity: activityStates[tripleDigitMultipleChoiceTestKey]!,
            testIcon: multipleChoiceTestIcon,
            testRoute: TripleDigitMultipleChoiceTestScreen(
              callback: callback,
              globalKey: globalKey,
            ),
            timedTestPrepActivity: activityStates[tripleDigitTimedTestPrepKey]!,
            timedTestPrepRoute: TripleDigitTimedTestPrepScreen(
              callback: callback,
            ),
            callback: () {},
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
    return Scaffold(
      backgroundColor: backgroundColor,
      key: globalKey,
      appBar: AppBar(
        title: Text('MEM++'),
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
                    return HomepageHelp(callback: callback);
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
                          color2: Colors.lightBlue[700]!,
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
                        customMemoryManagerFirstView ? NewTag() : Container()
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

  resetAll() {
    prefs.clear();

    var clearTo = defaultActivityStatesInitial;

    setState(() {
      activityStates = clearTo;
      customMemories = {};
    });
    prefs.writeSharedPrefs(activityStatesKey, clearTo);
    prefs.writeSharedPrefs(customMemoriesKey, {});

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

  resetActivities() {
    var clearTo = defaultActivityStatesInitial;

    setState(() {
      activityStates = clearTo;
      customMemories = {};
    });
    prefs.writeSharedPrefs(activityStatesKey, clearTo);

    setUnlockedActivities();
  }

  maxOutKeys(int maxTo) {
    prefs.setBool(customMemoryManagerAvailableKey, true);
    prefs.setBool(customMemoryManagerFirstHelpKey, true);
    customMemoryManagerFirstView = true;
    customMemoryManagerAvailable = true;
    prefs.setBool(gamesAvailableKey, true);
    prefs.setBool(gamesFirstHelpKey, true);
    gamesAvailable = true;
    gamesFirstView = true;

    if (maxTo >= 2) {
      prefs.setBool(singleDigitTimedTestCompleteKey, true);
      prefs.setBool(alphabetTimedTestCompleteKey, true);
      prefs.setBool(planetTimedTestCompleteKey, true);
      prefs.setBool(faceTimedTestCompleteKey, true);
      prefs.setBool(airportTimedTestCompleteKey, true);
      prefs.setBool(phoneticAlphabetTimedTestCompleteKey, true);
      prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter2Done);
      prefs.setBool(fadeGameAvailableKey, true);
      prefs.setBool(morseGameAvailableKey, true);
    }
    if (maxTo >= 3) {
      prefs.setBool(paoTimedTestCompleteKey, true);
      prefs.setBool(piTimedTestCompleteKey, true);
      prefs.setBool(face2TimedTestCompleteKey, true);
      prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter3Done);
      prefs.setBool(irrationalGameAvailableKey, true);
      prefs.setBool(deckEditKey, true);
    }
    if (maxTo >= 4) {
      prefs.setBool(deckTimedTestCompleteKey, true);
      prefs.writeSharedPrefs(
          activityStatesKey, defaultActivityStatesChapter3Done);
    }
    if (maxTo >= 5) {
      prefs.writeSharedPrefs(activityStatesKey, defaultActivityStatesAllDone);
    }

    setUnlockedActivities();
  }

  void initializeActivityMenuButtonMap() {
    activityMenuButtonMap = {
      welcomeKey: ActivityMenuButton(
        text: 'Welcome',
        route: WelcomeScreen(),
        icon: Icons.filter,
        color: Colors.green[200]!,
        splashColor: Colors.green[600]!,
      ),
      singleDigitEditKey: ActivityMenuButton(
        text: 'Single Digit System - Edit',
        route: SingleDigitEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitPracticeKey: ActivityMenuButton(
        text: 'Single Digit System - Practice',
        route: SingleDigitPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Single Digit System - MC Test',
        route: SingleDigitMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitTimedTestPrepKey: ActivityMenuButton(
        text: 'Single Digit System - Test Prep',
        route: SingleDigitTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      singleDigitTimedTestKey: ActivityMenuButton(
        text: 'Single Digit System - Timed Test',
        route: SingleDigitTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorSingleDigitLighter,
        splashColor: colorSingleDigitDarker,
      ),
      lesson1Key: ActivityMenuButton(
        text: 'Chapter 1 Lesson',
        route: Lesson1Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      faceTimedTestPrepKey: ActivityMenuButton(
        text: 'Faces (Easy) - Test Prep',
        route: FaceTimedTestPrepScreen(
          callback: callback,
        ),
        icon: faceIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      faceTimedTestKey: ActivityMenuButton(
        text: 'Faces (Easy) - Timed Test',
        route: FaceTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: faceIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      planetTimedTestPrepKey: ActivityMenuButton(
        text: 'Planets - Test Prep',
        route: PlanetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: planetIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      planetTimedTestKey: ActivityMenuButton(
        text: 'Planets - Timed Test',
        route: PlanetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: planetIcon,
        color: colorChapter1Lighter,
        splashColor: colorChapter1Darker,
      ),
      alphabetEditKey: ActivityMenuButton(
        text: 'Alphabet System - Edit',
        route: AlphabetEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetPracticeKey: ActivityMenuButton(
        text: 'Alphabet System - Practice',
        route: AlphabetPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetWrittenTestKey: ActivityMenuButton(
        text: 'Alphabet System - Written Test',
        route: AlphabetWrittenTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: writtenTestIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetTimedTestPrepKey: ActivityMenuButton(
        text: 'Alphabet System - Test Prep',
        route: AlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      alphabetTimedTestKey: ActivityMenuButton(
        text: 'Alphabet System - Timed Test',
        route: AlphabetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorAlphabetLighter,
        splashColor: colorAlphabetDarker,
      ),
      lesson2Key: ActivityMenuButton(
        text: 'Chapter 2 Lesson',
        route: Lesson2Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      phoneticAlphabetTimedTestPrepKey: ActivityMenuButton(
        text: 'Phonetic Alphabet - Test Prep',
        route: PhoneticAlphabetTimedTestPrepScreen(
          callback: callback,
        ),
        icon: phoneticIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      phoneticAlphabetTimedTestKey: ActivityMenuButton(
        text: 'Phonetic Alphabet - Timed Test',
        route: PhoneticAlphabetTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: phoneticIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      airportTimedTestPrepKey: ActivityMenuButton(
        text: 'Airport - Test Prep',
        route: AirportTimedTestPrepScreen(
          callback: callback,
        ),
        icon: airportIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      airportTimedTestKey: ActivityMenuButton(
        text: 'Airport - Timed Test',
        route: AirportTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: airportIcon,
        color: colorChapter2Lighter,
        splashColor: colorChapter2Darker,
      ),
      paoEditKey: ActivityMenuButton(
        text: 'PAO System - Edit',
        route: PAOEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoPracticeKey: ActivityMenuButton(
        text: 'PAO System - Practice',
        route: PAOPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoMultipleChoiceTestKey: ActivityMenuButton(
        text: 'PAO System - MC Test',
        route: PAOMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoTimedTestPrepKey: ActivityMenuButton(
        text: 'PAO System - Test Prep',
        route: PAOTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      paoTimedTestKey: ActivityMenuButton(
        text: 'PAO System - Timed Test',
        route: PAOTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorPAOLighter,
        splashColor: colorPAODarker,
      ),
      lesson3Key: ActivityMenuButton(
        text: 'Chapter 3 Lesson',
        route: Lesson3Screen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: lessonIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      face2TimedTestPrepKey: ActivityMenuButton(
        text: 'Faces (Hard) - Test Prep',
        route: Face2TimedTestPrepScreen(
          callback: callback,
        ),
        icon: face2Icon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      face2TimedTestKey: ActivityMenuButton(
        text: 'Faces (Hard) - Timed Test',
        route: Face2TimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: face2Icon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      piTimedTestPrepKey: ActivityMenuButton(
        text: 'Pi - Test Prep',
        route: PiTimedTestPrepScreen(
          callback: callback,
        ),
        icon: piIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      piTimedTestKey: ActivityMenuButton(
        text: 'Pi - Timed Test',
        route: PiTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: piIcon,
        color: colorChapter3Lighter,
        splashColor: colorChapter3Darker,
      ),
      deckEditKey: ActivityMenuButton(
        text: 'Deck System - Edit',
        route: DeckEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckPracticeKey: ActivityMenuButton(
        text: 'Deck System - Practice',
        route: DeckPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Deck System - MC Test',
        route: DeckMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckTimedTestPrepKey: ActivityMenuButton(
        text: 'Deck System - Test Prep',
        route: DeckTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      deckTimedTestKey: ActivityMenuButton(
        text: 'Deck System - Timed Test',
        route: DeckTimedTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: timedTestIcon,
        color: colorDeckLighter,
        splashColor: colorDeckDarker,
      ),
      tripleDigitEditKey: ActivityMenuButton(
        text: 'Triple Digit System - Edit',
        route: TripleDigitEditScreen(
          callback: callback,
        ),
        icon: editIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitPracticeKey: ActivityMenuButton(
        text: 'Triple Digit System - Practice',
        route: TripleDigitPracticeScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: practiceIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitMultipleChoiceTestKey: ActivityMenuButton(
        text: 'Triple Digit System - MC Test',
        route: TripleDigitMultipleChoiceTestScreen(
          callback: callback,
          globalKey: globalKey,
        ),
        icon: multipleChoiceTestIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitTimedTestPrepKey: ActivityMenuButton(
        text: 'Triple Digit System - Test Prep',
        route: TripleDigitTimedTestPrepScreen(
          callback: callback,
        ),
        icon: timedTestPrepIcon,
        color: colorTripleDigitLighter,
        splashColor: colorTripleDigitDarker,
      ),
      tripleDigitTimedTestKey: ActivityMenuButton(
        text: 'Triple Digit System - Timed Test',
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
  final Function callback;
  HomepageHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Homescreen',
      information: [
        '    This is the homescreen! The first time you open any screen for the first time, information '
            'regarding the screen will pop up. Access the information again at any time by clicking the '
            'info icon in the top right corner. Also check out the preferences, where you can toggle '
            'dark mode.'
      ],
      buttonColor: Colors.grey[200]!,
      buttonSplashColor: Colors.grey[300]!,
      firstHelpKey: 'homepageFirstHelpKey',
      callback: callback,
    );
  }
}
