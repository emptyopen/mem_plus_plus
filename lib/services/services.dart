import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:flutter/material.dart';

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