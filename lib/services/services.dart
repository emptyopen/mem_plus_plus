import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

handleAppUpdate() async {
  print('handling app update...');

  PrefsUpdater prefs = PrefsUpdater();

  // new games for old devices:
  // prefs.setBool(gamesAvailableKey, true);
  // prefs.setBool(fadeGameAvailableKey, true);
  // prefs.setBool(morseGameAvailableKey, true);
  // prefs.setBool(irrationalGameAvailableKey, true);

  Map<String, Activity> activityStates =
      prefs.getSharedPrefs(activityStatesKey) as Map<String, Activity>;

  defaultActivityStatesInitial.forEach((k, v) {
    if (!activityStates.keys.contains(k)) {
      activityStates[k] = v;
    }
  });
  prefs.writeSharedPrefs(activityStatesKey, activityStates);
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

void showSnackBar({
  required BuildContext context,
  required String snackBarText,
  Color textColor = Colors.black,
  Color? backgroundColor,
  int durationSeconds = 3,
  bool isSuper = false,
}) {
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
          fontFamily: 'Viga',
        ),
      ),
    ),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showConfirmDialog({
  required BuildContext context,
  required Function function,
  required String confirmText,
  Color confirmColor = Colors.redAccent,
  bool isRoute = false,
}) {
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
            color: Colors.grey[300]!,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          BasicFlatButton(
            text: 'Confirm',
            color: confirmColor,
            onPressed: () {
              function();
              HapticFeedback.lightImpact();
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
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
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
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  Random random = Random();
  await flutterLocalNotificationsPlugin.schedule(
    random.nextInt(100000) + 10,
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
  PrefsUpdater prefs = PrefsUpdater();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    dailyReminderIdKey,
    dailyReminderKey,
    'Weekly reminder',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  bool singleDigitComplete = prefs.getBool(singleDigitTimedTestCompleteKey);
  bool chapter1Complete = prefs.getBool(faceTimedTestCompleteKey) &&
      prefs.getBool(planetTimedTestCompleteKey);
  bool alphabetComplete = prefs.getBool(alphabetTimedTestCompleteKey);
  bool chapter2Complete = prefs.getBool(airportTimedTestCompleteKey) &&
      prefs.getBool(phoneticAlphabetTimedTestCompleteKey);
  bool paoComplete = prefs.getBool(paoTimedTestCompleteKey);
  bool chapter3Complete = prefs.getBool(piTimedTestCompleteKey) &&
      prefs.getBool(face2TimedTestCompleteKey);
  bool deckComplete = prefs.getBool(deckTimedTestCompleteKey);

  var random = Random();
  int basicMessageIndex = random.nextInt(6);
  String title = 'Have you improved your memory today?';
  String subtitle = 'Click here to check your todo list!';
  if (basicMessageIndex == 1) {
    title = 'Looking for something to do?';
  } else if (basicMessageIndex == 2) {
    title = 'Bored? Let\'s self-improve!';
  } else if (basicMessageIndex == 3) {
    title = 'Time to improve your memory!';
  } else if (basicMessageIndex == 4) {
    title = 'Get on in here! Memory time!';
  } else if (basicMessageIndex == 5) {
    title = 'C\'mon, let\'s improve your memory!';
  }
  if (!singleDigitComplete) {
    subtitle = 'Continue developing your Single Digit skills!';
  } else if (!chapter1Complete) {
    subtitle = 'Keep on working on Chapter 1!';
  } else if (!alphabetComplete) {
    subtitle = 'Work on your Alphabet System!';
  } else if (!chapter2Complete) {
    subtitle = 'Complete Chapter 2!';
  } else if (!paoComplete) {
    subtitle = 'Continue familiarizing your PAO System!';
  } else if (!chapter3Complete) {
    subtitle = 'Chapter 3 is waiting!';
  } else if (!deckComplete) {
    subtitle = 'Continue familiarizing your Deck System!';
  }

  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  tz.TZDateTime _nextInstanceOfLunch() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 12);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }
    return scheduledDate;
  }

  // debug
  List<PendingNotificationRequest> pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  pendingNotificationRequests.forEach((p) async {
    print('previous ${p.body} | ${p.id} | ${p.payload} | ${p.title}');
    if (p.id < 10) {
      await flutterLocalNotificationsPlugin.cancel(p.id);
    }
  });

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    title,
    subtitle,
    _nextInstanceOfLunch(),
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );

  // more debug
  pendingNotificationRequests =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  pendingNotificationRequests.forEach((p) {
    print('after ${p.body} | ${p.id} | ${p.payload} | ${p.title}');
  });
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
          borderRadius:
              isCurrent ? BorderRadius.circular(7) : BorderRadius.circular(7),
          border: i == currentCircleIndex
              ? Border.all(color: backgroundColor)
              : null,
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

slideTransition(BuildContext context, Widget route) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) =>
          route,
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

stringToMorse(String string, bool multiWord) {
  String morseString = multiWord ? '> ' : '';
  string.runes.forEach((int rune) {
    var character = new String.fromCharCode(rune).toUpperCase();
    if (letters.contains(character)) {
      int index = letters.indexWhere(
          (letter) => letter.toLowerCase() == character.toLowerCase());
      morseString += morse[index] + '/';
    } else if (character == ' ') {
      morseString += multiWord ? '\n> ' : ' ';
    } else {
      morseString += character;
    }
  });
  return morseString;
}
