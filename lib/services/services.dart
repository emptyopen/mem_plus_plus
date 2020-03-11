import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';

class PrefsUpdater {
  Future<Object> getSharedPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case activityStatesKey:
        String activityStatesString = prefs.getString(activityStatesKey);
        if (activityStatesString == null) {
          return defaultActivityStatesInitial;
        }
        Map<String, dynamic> rawMap = json
            .decode(activityStatesString) as Map<String, dynamic>;
        return rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
      case singleDigitKey:
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
            .map((i) => SingleDigitData.fromJson(i))
            .toList();
        return singleDigitData;
      case alphabetKey:
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
            .map((i) => AlphabetData.fromJson(i))
            .toList();
        return singleDigitData;
      case paoKey:
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
            .map((i) => PAOData.fromJson(i))
            .toList();
        return singleDigitData;
      case deckKey:
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
            .map((i) => DeckData.fromJson(i))
            .toList();
        return singleDigitData;
      case customMemoriesKey:
        return json.decode(prefs.getString(key));
    }
    return null;
  }

  Future<void> writeSharedPrefs(String key, Object object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case activityStatesKey:
        Map<String, Activity> activityStates = object;
        prefs.setString(activityStatesKey,
            json.encode(activityStates.map((k, v) => MapEntry(k, v.toJson()))));
        break;
      case singleDigitKey:
        List<SingleDigitData> thing = object;
        print('SERVICES: writing ${thing[2].object} | ${thing[3].object}');
        prefs.setString(key, json.encode(object));
        break;
      case alphabetKey:
        prefs.setString(key, json.encode(object));
        break;
      case paoKey:
        prefs.setString(key, json.encode(object));
        break;
      case deckKey:
        prefs.setString(key, json.encode(object));
        break;
      case customMemoriesKey:
        prefs.setString(key, json.encode(object));
        break;
    }
  }

  updateActivityFirstView(String activityName, bool isNew) async {
    print('setting $activityName first view to $isNew');
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.firstView = isNew;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityState(String activityName, String state) async {
    print('setting $activityName state to $state');
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.state = state;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  Future<String> getActivityState(String activityName) async {
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    return activityStates[activityName].state;
  }

  Future<bool> getActivityVisible(String activityName) async {
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    return activityStates[activityName].visible;
  }

  updateActivityVisible(String activityName, bool visible) async {
    print('setting $activityName visible to $visible');
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    if (activity == null) {
      print('hey, activity.visible was null. defaulting...');
      activityStates[activityName] = defaultActivityStatesAllDone[activityName];
      activity = activityStates[activityName];
    }
    activity.visible = visible;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityVisibleAfter(String activityName, DateTime visibleAfter) async {
    print('setting $activityName visibleAfter to $visibleAfter');
    Map<String, Activity> activityStates =
        await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.visibleAfterTime = visibleAfter;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  Future<void> setBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  Future<void> setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Set<String>> getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  Future<void> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  checkFirstTime(
      BuildContext context, String firstHelpKey, Widget helpScreen) async {
    var prefs = PrefsUpdater();
    if (await prefs.getBool(firstHelpKey) == null) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return helpScreen;
          }));
      //await prefs.setBool(firstHelpKey, true);
    }
  }
}

List shuffle(List items) {
  var random = new Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

void showSnackBar(
    {ScaffoldState scaffoldState,
    String snackBarText,
    Color textColor = Colors.black,
    Color backgroundColor,
    int durationSeconds = 3,
    bool isSuper = false}) {
  final snackBar = SnackBar(
    content: Shimmer.fromColors(
      period: Duration(seconds: 3),
      baseColor: textColor,
      highlightColor: isSuper ? Colors.greenAccent : textColor,
      child: Text(
        snackBarText,
        style: TextStyle(
          color: textColor,
          fontSize: isSuper ? 20 : 16,
          fontFamily: 'CabinSketch',
        ),
      ),
    ),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
  );
  scaffoldState.showSnackBar(snackBar);
}

void showConfirmDialog(
    {BuildContext context,
    Function function,
    String confirmText,
    Color confirmColor = Colors.redAccent,
    bool isRoute = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Confirm',
          style: TextStyle(color: backgroundHighlightColor),
        ),
        content: Text(
          confirmText,
          style: TextStyle(color: backgroundHighlightColor),
        ),
        actions: <Widget>[
          BasicFlatButton(
            text: 'Cancel',
            color: Colors.grey[300],
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
            },
          ),
          BasicFlatButton(
            text: 'Confirm',
            color: confirmColor,
            onPressed: () {
              function();
              HapticFeedback.heavyImpact();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// DateTime findNextDatetime(String startDatetime, String spacedRepetitionType, int spacedRepetitionLevel) {

//   // fib: 1 2 3 5 8 13 21 34
//   //  30 60 90 150 210 390 630 1020
//   //  30 120 330 810 1830 4050 8730 18480

//   return DateTime.parse(startDatetime).add(termDurationsMap[spacedRepetitionType][spacedRepetitionLevel]);
// }

String durationToString(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours - days * 24;
  int minutes = duration.inMinutes - hours * 60 - days * 1440;
  int seconds = duration.inSeconds - minutes * 60 - hours * 3600 - days * 86400;
  if (days >= 1) {
    return '${days}d ${hours}h';
  } else if (hours >= 1) {
    return '${hours}h ${minutes}m';
  } else if (minutes >= 3) {
    return '$minutes minutes';
  } else if (minutes >= 1) {
    return '${minutes}m ${seconds}s';
  } else {
    return '$seconds seconds!';
  }
}

notify() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'Test notification', 'testing 1 2 3', platformChannelSpecifics,
      payload: 'item x');
}

notifyDuration(
    Duration duration, String title, String subtitle, String payload) async {
  var scheduledNotificationDateTime = DateTime.now().add(duration);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    testReminderIdKey,
    testReminderKey,
    'Timed test available',
    importance: Importance.Max,
    priority: Priority.High,
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  print('setting notification $scheduledNotificationDateTime ||| $title ||| $subtitle');
  await flutterLocalNotificationsPlugin.schedule(
    0,
    title,
    subtitle,
    scheduledNotificationDateTime,
    platformChannelSpecifics,
    payload: payload,
  );
}

String datetimeToDateString(String datetimeString) {
  var datetime = DateTime.parse(datetimeString);
  String year = datetime.year.toString();
  String month = datetime.month.toString().padLeft(2, '0');
  String day = datetime.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}

initializeNotificationsScheduler() async {
  var prefs = PrefsUpdater();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var time = Time(12, 30, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      dailyReminderIdKey, dailyReminderKey, 'Daily reminder',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  String singleDigitEditState =
      await prefs.getActivityState(singleDigitEditKey);
  String singleDigitPracticeState =
      await prefs.getActivityState(singleDigitPracticeKey);
  String singleDigitMultipleChoiceTestState =
      await prefs.getActivityState(singleDigitMultipleChoiceTestKey);
  // String singleDigitEditState =
  //     await prefs.getActivityState(singleDigitEditKey);
  // String singleDigitEditState =
  //     await prefs.getActivityState(singleDigitEditKey);
  // String singleDigitEditState =
  //     await prefs.getActivityState(singleDigitEditKey);
  // String singleDigitEditState =
  //     await prefs.getActivityState(singleDigitEditKey);
  // String singleDigitEditState =
  //     await prefs.getActivityState(singleDigitEditKey);

  String title = 'Have you improved your memory today?';
  String subtitle = 'Click here to check your to-do list!';
  if (singleDigitEditState != null && singleDigitEditState == 'todo') {
    title = 'Let\'s pick up where you left off!';
    subtitle = 'Continue developing your Single Digit mapping!';
  } else if (singleDigitPracticeState != null && singleDigitPracticeState == 'todo') {
    title = 'Let\'s pick up where you left off!';
    subtitle = 'Continue familiarizing your Single Digits!';
  } //else if (await prefs.getActivityState(singleDigitMultipleChoiceTestKey) ==
  //     'todo') {
  //   title = 'Time to master Single Digits!';
  //   subtitle = 'Click here to start your MC test!';
  // } else if (await prefs.getActivityState(singleDigitTimedTestPrepKey) ==
  //     'todo') {
  //   title = 'Let\'s start a Single Digit timed test!';
  //   subtitle = 'Complete the test to unlock the next system!';
  // } else if (await prefs.getActivityState(alphabetEditKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue developing your Alphabet mapping!';
  // } else if (await prefs.getActivityState(alphabetPracticeKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue familiarizing your Alphabet System!';
  // } else if (await prefs.getActivityState(alphabetWrittenTestKey) == 'todo') {
  //   title = 'Time to master the Alphabet!';
  //   subtitle = 'Click here to start your MC test!';
  // } else if (await prefs.getActivityState(alphabetTimedTestPrepKey) == 'todo') {
  //   title = 'Let\'s start an Alphabet timed test!';
  //   subtitle = 'Complete the test to unlock the next system!';
  // } else if (await prefs.getActivityState(paoEditKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue developing your PAO mapping!';
  // } else if (await prefs.getActivityState(paoPracticeKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue familiarizing your PAO mapping!';
  // } else if (await prefs.getActivityState(paoMultipleChoiceTestKey) == 'todo') {
  //   title = 'Time to master your PAO system!';
  //   subtitle = 'Click here to start your MC test!';
  // } else if (await prefs.getActivityState(paoTimedTestPrepKey) == 'todo') {
  //   title = 'Let\'s start a PAO timed test!';
  //   subtitle = 'Complete the test to unlock the next system!';
  // } else if (await prefs.getActivityState(deckEditKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue developing your Deck mapping!';
  // } else if (await prefs.getActivityState(deckPracticeKey) == 'todo') {
  //   title = 'Let\'s pick up where you left off!';
  //   subtitle = 'Continue familiarizing your Deck mapping!';
  // } else if (await prefs.getActivityState(deckMultipleChoiceTestKey) ==
  //     'todo') {
  //   title = 'Time to master your Deck system!';
  //   subtitle = 'Click here to start your MC test!';
  // } else if (await prefs.getActivityState(deckTimedTestPrepKey) == 'todo') {
  //   title = 'Let\'s start a Deck timed test!';
  //   subtitle = 'Complete the test to unlock the next system!';
  // }
  await flutterLocalNotificationsPlugin.showDailyAtTime(
      0, title, subtitle, time, platformChannelSpecifics);
  print(
      'initialized daily notification @ ${time.hour}:${time.minute}:${time.second}');
}

getSlideCircles(int numCircles, int currentCircleIndex, Color highlightColor) {
  List<Widget> circles = [];
  for (int i = 0; i < numCircles; i++) {
    bool isCurrent = i == currentCircleIndex;
    circles.add(
      Container(
        height: isCurrent ? 14 : 10,
        width: isCurrent ? 14 : 10,
        decoration: BoxDecoration(
          color: isCurrent ? highlightColor : Colors.grey,
          borderRadius: isCurrent ? BorderRadius.circular(7) : BorderRadius.circular(7),
          border: i == currentCircleIndex ? Border.all(color: backgroundColor) : null,
        ),
      ),
    );
    circles.add(
      SizedBox(
        width: 5,
      ),
    );
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: circles,
  );
}