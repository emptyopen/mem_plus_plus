import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:flutter/services.dart';

class DayOrOlderActivitiesScreen extends StatefulWidget {
  final List<String> names;
  final List<DateTime> availableTimes;
  final List<IconData> icons;
  final List<String> nameKeys;
  final Function callback;

  DayOrOlderActivitiesScreen(
      {Key? key,
      required this.names,
      required this.availableTimes,
      required this.icons,
      required this.nameKeys,
      required this.callback})
      : super(key: key);

  @override
  _DayOrOlderActivitiesScreenState createState() =>
      _DayOrOlderActivitiesScreenState();
}

class _DayOrOlderActivitiesScreenState
    extends State<DayOrOlderActivitiesScreen> {
  PrefsUpdater prefs = PrefsUpdater();

  List<Widget> getActivities() {
    List<Widget> activityTileList = [];
    for (int i = 0; i < widget.names.length; i++) {
      activityTileList.add(
        Card(
          color: Colors.grey[900],
          child: ListTile(
            leading: Icon(
              widget.icons[i],
              color: Colors.grey[400],
            ),
            title: Text(
              widget.names[i],
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            subtitle: Text(
              findRemainingTime(widget.availableTimes[i]),
              style: TextStyle(
                color: Colors.grey[400],
              ),
            ),
            trailing: widget.nameKeys[i] == ''
                ? Container(
                    width: 1,
                  )
                : BasicFlatButton(
                    text: 'Cancel',
                    onPressed: () => showConfirmDialog(
                      context: context,
                      function: () => cancelActivity(widget.nameKeys[i], i),
                      confirmText: 'Are you sure you want to give up?',
                      confirmColor: Colors.grey,
                    ),
                    textColor: Colors.white,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
          ),
        ),
      );
    }
    return activityTileList;
  }

  cancelActivity(String activity, int index) async {
    switch (activity) {
      case singleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(singleDigitTimedTestKey, 'review');
        prefs.updateActivityVisible(singleDigitTimedTestKey, false);
        prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
        if (prefs.getBool(singleDigitTimedTestCompleteKey) == null) {
          prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
        }
        break;
      case singleDigitTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(singleDigitTimedTestKey, 'review');
        prefs.updateActivityVisible(singleDigitTimedTestKey, false);
        prefs.updateActivityVisible(singleDigitTimedTestPrepKey, true);
        if (prefs.getBool(singleDigitTimedTestCompleteKey) == null) {
          prefs.updateActivityState(singleDigitTimedTestPrepKey, 'todo');
        }
        break;
      case alphabetTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(alphabetTimedTestKey, 'review');
        prefs.updateActivityVisible(alphabetTimedTestKey, false);
        prefs.updateActivityVisible(alphabetTimedTestPrepKey, true);
        if (prefs.getBool(alphabetTimedTestCompleteKey) == null) {
          prefs.updateActivityState(alphabetTimedTestPrepKey, 'todo');
        }
        break;
      case paoTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(paoTimedTestKey, 'review');
        prefs.updateActivityVisible(paoTimedTestKey, false);
        prefs.updateActivityVisible(paoTimedTestPrepKey, true);
        if (prefs.getBool(paoTimedTestCompleteKey) == null) {
          prefs.updateActivityState(paoTimedTestPrepKey, 'todo');
        }
        break;
      case deckTimedTestKey:
        HapticFeedback.lightImpact();
        prefs.updateActivityState(deckTimedTestKey, 'review');
        prefs.updateActivityVisible(deckTimedTestKey, false);
        prefs.updateActivityVisible(deckTimedTestPrepKey, true);
        if (prefs.getBool(deckTimedTestCompleteKey) == null) {
          prefs.updateActivityState(deckTimedTestPrepKey, 'todo');
        }
        break;
    }
    widget.nameKeys.removeAt(index);
    widget.names.removeAt(index);
    widget.icons.removeAt(index);
    setState(() {});
    widget.callback();
  }

  String findRemainingTime(DateTime datetime) {
    var remainingTime = datetime.difference(DateTime.now());
    if (!remainingTime.isNegative) {
      return 'Available in: ${durationToString(remainingTime)}';
    }
    return 'Available! (Main Menu)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Upcoming tests'),
        backgroundColor: colorCustomMemoryLighter,
      ),
      body: Column(
        children: getActivities(),
      ),
    );
  }
}
