import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/data/alphabet_data.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'package:mem_plus_plus/components/data/pao_data.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/components/data/triple_digit_data.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUpdater {
  late SharedPreferences prefs;

  PrefsUpdater() {
    asyncInit();
  }

  asyncInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  Object? getSharedPrefs(String key) {
    switch (key) {
      case activityStatesKey:
        String? activityStatesString = prefs.getString(activityStatesKey);
        if (activityStatesString == null) {
          return defaultActivityStatesInitial;
        }
        Map<String, dynamic> rawMap =
            json.decode(activityStatesString) as Map<String, dynamic>;
        return rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
      case singleDigitKey:
        var singleDigitData = (json.decode(prefs.getString(key)!) as List)
            .map((i) => SingleDigitData.fromJson(i))
            .toList();
        return singleDigitData;
      case alphabetKey:
        var singleDigitData = (json.decode(prefs.getString(key)!) as List)
            .map((i) => AlphabetData.fromJson(i))
            .toList();
        return singleDigitData;
      case paoKey:
        var singleDigitData = (json.decode(prefs.getString(key)!) as List)
            .map((i) => PAOData.fromJson(i))
            .toList();
        return singleDigitData;
      case deckKey:
        var singleDigitData = (json.decode(prefs.getString(key)!) as List)
            .map((i) => DeckData.fromJson(i))
            .toList();
        return singleDigitData;
      case tripleDigitKey:
        var tripleDigitData = (json.decode(prefs.getString(key)!) as List)
            .map((i) => TripleDigitData.fromJson(i))
            .toList();
        return tripleDigitData;
      case customMemoriesKey:
        return json.decode(prefs.getString(key)!);
    }
    return null;
  }

  void writeSharedPrefs(String key, Object object) {
    switch (key) {
      case activityStatesKey:
        Map<String, Activity> activityStates = object as Map<String, Activity>;
        prefs.setString(activityStatesKey,
            json.encode(activityStates.map((k, v) => MapEntry(k, v.toJson()))));
        break;
      case singleDigitKey:
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
      case tripleDigitKey:
        prefs.setString(key, json.encode(object));
        break;
      case customMemoriesKey:
        prefs.setString(key, json.encode(object));
        break;
    }
  }

  void updateActivityFirstView(String activityName, bool isNew) {
    print('setting $activityName first view to $isNew');
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    Activity activity = activityStates[activityName]!;
    activity.firstView = isNew;
    activityStates[activityName] = activity;
    writeSharedPrefs(activityStatesKey, activityStates);
  }

  void updateActivityState(String activityName, String state) {
    print('setting $activityName state to $state');
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    Activity activity = activityStates[activityName]!;
    activity.state = state;
    activityStates[activityName] = activity;
    writeSharedPrefs(activityStatesKey, activityStates);
  }

  String getActivityState(String activityName) {
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    return activityStates[activityName]!.state;
  }

  bool getActivityVisible(String activityName) {
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    if (activityStates[activityName] == null) {
      return false;
    }
    return activityStates[activityName]!.visible;
  }

  void updateActivityVisible(String activityName, bool visible) {
    print('setting $activityName visible to $visible');
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    Activity activity = activityStates[activityName]!;
    activity.visible = visible;
    activityStates[activityName] = activity;
    writeSharedPrefs(activityStatesKey, activityStates);
  }

  void updateActivityVisibleAfter(String activityName, DateTime visibleAfter) {
    print('setting $activityName visibleAfter to $visibleAfter');
    Map<String, Activity> activityStates =
        getSharedPrefs(activityStatesKey) as Map<String, Activity>;
    Activity activity = activityStates[activityName]!;
    activity.visibleAfterTime = visibleAfter;
    activityStates[activityName] = activity;
    writeSharedPrefs(activityStatesKey, activityStates);
  }

  void setBool(String key, bool value) {
    prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return prefs.getBool(key);
  }

  void setString(String key, String value) {
    prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Set<String> getKeys() {
    return prefs.getKeys();
  }

  void remove(String key) {
    prefs.remove(key);
  }

  void clear() {
    prefs.clear();
  }

  checkFirstTime(BuildContext context, String firstHelpKey, Widget helpScreen) {
    PrefsUpdater prefs = PrefsUpdater();
    if (prefs.getBool(firstHelpKey) == null) {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) {
            return helpScreen;
          }));
    }
  }
}
