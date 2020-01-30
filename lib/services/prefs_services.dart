import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'dart:math';
import 'package:mem_plus_plus/components/activities.dart';

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
        return shuffle(singleDigitData);
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

  Future<int> getLevel() async {
    return await getSharedPrefs(levelKey);
  }

  updateLevel(int newLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // TODO: need to check level!!
//    if (await getLevel() == newLevel - 1) {
//      print('updating level!');
//      prefs.setInt(levelKey, newLevel);
//    }
//    print('wrong level to update: ${await getLevel()} $newLevel');
    print('setting level to $newLevel');
    prefs.setInt(levelKey, newLevel);
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
}
