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
    }
  }

  Future<int> getLevel() async {
    return await getSharedPrefs(levelKey);
  }

  updateLevel(int newLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (await getLevel() == newLevel - 1) {
      prefs.setInt(levelKey, newLevel);
    }
  }

  setBool(String key, bool newBool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, newBool);
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
