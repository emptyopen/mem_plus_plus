import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';

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
      case 'Level':
        return prefs.getInt(levelKey);
      case 'CustomTests':
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
      case 'PAO':
        prefs.setString(key, json.encode(object));
        break;
      case 'CustomTests':
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
    activity.visibleAfter = visibleAfter;
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
      await prefs.setBool(firstHelpKey, true);
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

void showSnackBar(BuildContext context, String snackBarText, Color textColor, Color backgroundColor,
  int durationSeconds) {
  final snackBar = SnackBar(
    content: Text(
      snackBarText,
      style: TextStyle(
        color: textColor,
      ),
    ),
    duration: Duration(seconds: durationSeconds),
    backgroundColor: backgroundColor,
  );
  Scaffold.of(context).showSnackBar(snackBar);
}

void showConfirmDialog(BuildContext context, Function function, String confirmText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(),
          borderRadius: BorderRadius.circular(5)
        ),
        title: Text('Confirm'),
        content: Text(confirmText),
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
            color: Colors.redAccent[100],
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

DateTime findNextDatetime(String startDatetime, String spacedRepetitionType, int spacedRep) {

  String shortTerm = 'short term (1d ~ 1w)';
  String mediumTerm = 'medium term (1w ~ 3m)';
  String longTerm = 'long term (3m ~ 1y)';
  String extraLongTerm = 'extra long term (1y ~ life)';

  // fib: 1 2 3 5 8 13 21 34
  //  30 60 90 150 210 390 630 1020
  //  30 120 330 810 1830 4050 8730 18480

  Map termDurationsMap = {
    shortTerm: [Duration(minutes: 20), Duration(minutes: 80), Duration(minutes: 220), Duration(minutes: 540), Duration(minutes: 1240)],
    mediumTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10)],
    longTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10), Duration(days: 30), Duration(days: 90)],
    extraLongTerm: [Duration(minutes: 30), Duration(hours: 3), Duration(hours: 12), Duration(days: 2), Duration(days: 10), Duration(days: 30), Duration(days: 90), Duration(days: 180), Duration(days: 400)],
  };
  return DateTime.parse(startDatetime).add(termDurationsMap[spacedRepetitionType][spacedRep]);
}

String durationToString(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes - hours * 60;
  int seconds = duration.inSeconds - minutes * 60 - hours * 3600;
  if (hours > 1) {
    return '${hours}h ${minutes}m';
  } else if (minutes >= 1) {
    return '${minutes}m ${seconds}s';
  } else {
    return '$seconds seconds!';
  }
}