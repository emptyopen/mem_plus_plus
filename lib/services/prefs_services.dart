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

  Future<int> getLevel() async {
    return getSharedPrefs(levelKey);
  }

  void writeSharedPrefs(String key, Object object) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (key) {
      case 'ActivityStates':
        Map<String, Activity> activityStates = object;
        prefs.setString(
          activityStatesKey,
          json.encode(
            activityStates.map((k, v) => MapEntry(k, v.toJson())),
          )
        );
    }
  }

  updateLevel(int newLevel) async {

  }

  updateActivityFirstView(String activityName, bool isNew) async {
    Map<String, Activity> activityStates = await getSharedPrefs(activityStatesKey);
    Activity singleDigitMultipleChoiceTest = activityStates[activityName];
    singleDigitMultipleChoiceTest.firstView = isNew;
    activityStates[activityName] = singleDigitMultipleChoiceTest;
    writeSharedPrefs(activityStatesKey, activityStates);
  }

  updateActivityVisible(String activityName, bool visible) async {}

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
