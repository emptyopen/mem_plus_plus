import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/deck/deck_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Map termDurationsMap = {
  shortTerm: debugModeEnabled ? [Duration(seconds: 1), Duration(seconds: 3), Duration(seconds: 5), Duration(seconds: 8), Duration(seconds: 1)] :
    [Duration(minutes: 20), Duration(minutes: 80), Duration(minutes: 220), Duration(minutes: 540), Duration(minutes: 1240)],
  mediumTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10)],
  longTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10), Duration(days: 30), Duration(days: 90)],
  extraLongTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10), Duration(days: 30), Duration(days: 90), Duration(days: 180), Duration(days: 400)],
};

Map customMemoryIconMap = {
  contactString: Icons.person_pin,
  idCardString: Icons.credit_card,
  otherString: Icons.add,
};

class PrefsUpdater {
  String activityStatesKey = 'ActivityStates';
  String singleDigitKey = 'SingleDigit';
  String levelKey = 'Level';

  Future<Object> getSharedPrefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'ActivityStates':
        Map<String, dynamic> rawMap = json.decode(prefs.getString(activityStatesKey)) as Map<String, dynamic>;
        return rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
      case 'SingleDigit':
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
            .map((i) => SingleDigitData.fromJson(i))
            .toList();
        return singleDigitData;
      case 'Alphabet':
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
          .map((i) => AlphabetData.fromJson(i))
          .toList();
        return singleDigitData;
      case 'PAO':
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
          .map((i) => PAOData.fromJson(i))
          .toList();
        return singleDigitData;
      case 'Deck':
        var singleDigitData = (json.decode(prefs.getString(key)) as List)
          .map((i) => DeckData.fromJson(i))
          .toList();
        return singleDigitData;
      case 'Level':
        return prefs.getInt(levelKey);
      case 'CustomMemories':
        return json.decode(prefs.getString(key));
    }
    return null;
  }

  Future<void> writeSharedPrefs(String key, Object object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'ActivityStates':
        Map<String, Activity> activityStates = object;
        prefs.setString(activityStatesKey, json.encode(activityStates.map((k, v) => MapEntry(k, v.toJson()))));
        break;
      case 'SingleDigit':
        prefs.setString(key, json.encode(object));
        break;
      case 'Alphabet':
        prefs.setString(key, json.encode(object));
        break;
      case 'PAO':
        prefs.setString(key, json.encode(object));
        break;
      case 'Deck':
        prefs.setString(key, json.encode(object));
        break;
      case 'CustomMemories':
        prefs.setString(key, json.encode(object));
        break;
    }
  }

  updateActivityFirstView(String activityName, bool isNew) async {
    print('setting $activityName first view to $isNew');
    Map<String, Activity> activityStates = await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.firstView = isNew;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityState(String activityName, String state) async {
    print('setting $activityName state to $state');
    Map<String, Activity> activityStates = await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.state = state;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityVisible(String activityName, bool visible) async {
    print('setting $activityName visible to $visible');
    Map<String, Activity> activityStates = await getSharedPrefs(activityStatesKey);
    Activity activity = activityStates[activityName];
    activity.visible = visible;
    activityStates[activityName] = activity;
    await writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityVisibleAfter(String activityName, DateTime visibleAfter) async {
    print('setting $activityName visibleAfter to $visibleAfter');
    Map<String, Activity> activityStates = await getSharedPrefs(activityStatesKey);
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

  checkFirstTime(BuildContext context, String firstHelpKey, Widget helpScreen) async {
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

void showSnackBar({ScaffoldState scaffoldState, String snackBarText, Color textColor = Colors.black, Color backgroundColor,
  int durationSeconds = 3, bool isSuper = false}) {
  final snackBar = SnackBar(
    // action: SnackBarAction(label: 'Roger!', onPressed: () => scaffoldState.hideCurrentSnackBar(), textColor: textColor,),
    content: Shimmer.fromColors(
      period: Duration(seconds: 3),
      baseColor: textColor,
      highlightColor: isSuper ? Colors.greenAccent : textColor,
      child: Text(
        snackBarText,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontFamily: 'CabinSketch',
        ),
      ),
    ),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
  );
  scaffoldState.showSnackBar(snackBar);
}

void showConfirmDialog({BuildContext context, Function function, String confirmText, Color confirmColor = Colors.redAccent, bool isRoute = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Confirm', style: TextStyle(color: backgroundHighlightColor),),
        content: Text(confirmText, style: TextStyle(color: backgroundHighlightColor),),
        actions: <Widget>[
          BasicFlatButton(
            text: 'Cancel',
            color: Colors.grey[300],
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          BasicFlatButton(
            text: 'Confirm',
            color: confirmColor,
            onPressed: () {
              function();
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
  int hours = duration.inHours;
  int minutes = duration.inMinutes - hours * 60;
  int seconds = duration.inSeconds - minutes * 60 - hours * 3600;
  if (hours >= 1) {
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
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'Test notification',
      'testing 1 2 3',
      platformChannelSpecifics,
      payload: 'item x');
}

notifyDuration(Duration duration, String title, String subtitle, String payload) async {
  var scheduledNotificationDateTime = DateTime.now().add(duration);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      testReminderIdKey, testReminderKey, 'Timed test available',
      importance: Importance.Max,
      priority: Priority.High,
      ticker: 'ticker',);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
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