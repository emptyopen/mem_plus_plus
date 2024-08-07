import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/single_digit_data.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class SingleDigitEditScreen extends StatefulWidget {
  final Function callback;

  SingleDigitEditScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _SingleDigitEditScreenState createState() => _SingleDigitEditScreenState();
}

class _SingleDigitEditScreenState extends State<SingleDigitEditScreen> {
  late List<SingleDigitData> singleDigitData;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() {
    prefs.checkFirstTime(context, singleDigitEditFirstHelpKey,
        SingleDigitEditScreenHelp(callback: widget.callback));
    if (prefs.getString(singleDigitKey) == '') {
      singleDigitData =
          debugModeEnabled ? defaultSingleDigitData3 : defaultSingleDigitData1;
      prefs.setString(singleDigitKey, json.encode(singleDigitData));
    } else {
      singleDigitData =
          prefs.getSharedPrefs(singleDigitKey) as List<SingleDigitData>;
    }
    setState(() {});
  }

  callback(newSingleDigitData) {
    // check if all data is complete
    prefs.writeSharedPrefs(singleDigitKey, newSingleDigitData);
    setState(() {
      singleDigitData = newSingleDigitData;
    });
    bool entriesComplete = true;
    for (int i = 0; i < singleDigitData.length; i++) {
      if (singleDigitData[i].object == '') {
        entriesComplete = false;
      }
    }

    // check if information is filled out for the first time
    bool completedOnce = prefs.getActivityVisible(singleDigitPracticeKey);
    if (entriesComplete && !completedOnce) {
      prefs.updateActivityVisible(singleDigitPracticeKey, true);
      prefs.updateActivityState(singleDigitEditKey, 'review');
      showSnackBar(
          context: context,
          snackBarText:
              'Great job filling everything out! Head to the main menu to see what you\'ve unlocked!',
          backgroundColor: colorSingleDigitDarker,
          durationSeconds: 5);
      widget.callback();
    }
  }

  List<EditCard> getSingleDigitEditCards() {
    List<EditCard> singleDigitViews = [];
    for (int i = 0; i < singleDigitData.length; i++) {
      EditCard singleDigitEditCard = EditCard(
        entry: singleDigitData[i],
        callback: callback,
        activityKey: singleDigitKey,
      );
      singleDigitViews.add(singleDigitEditCard);
    }
    return singleDigitViews;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Single Digit System', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.amber[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return SingleDigitEditScreenHelp(callback: widget.callback);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Column(
            children: getSingleDigitEditCards(),
          ),
        ),
      ),
    );
  }
}

class SingleDigitEditScreenHelp extends StatelessWidget {
  final Function callback;
  SingleDigitEditScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final information = [
    '    Welcome to your first system, the single digit system! '
        'The idea behind this system is to link the nine digits (0-9) to different objects. \n'
        '    Numbers are abstract and difficult to remember, but if we '
        'convert them to images, especially strange and vivid images, they suddenly '
        'becomes much easier to remember. For sequences of numbers, we simply string them together '
        'into the scenes of a strange story. ',
    '    The example values I\'ve inserted here uses the '
        'idea of a "shape" pattern. That is, each object corresponds to what the '
        'actual digit it represents is shaped like. For example, 1 looks like a '
        'stick, and perhaps 4 looks like a sailboat. \n    Another pattern could be not physical shape, but rhyming. 2 could be '
        'shoe, 5 could be a bee hive. Or maybe you just have a strong association with a certain '
        'object for a particular digit! ',
    '    You can assign anything '
        'to any digit (in fact, you can assign multiple object to a digit), it just makes it easier to get started if you have some kind of pattern. '
        'Make sure that the objects don\'t overlap conceptually, as much as possible! \n    It\'s completely '
        'OK to change digit associations as you progress, but just know that '
        'when you edit a digit\'s association it will reset your familiarity for that object back to zero! '
        'Familiarity is listed on the right side of the tiles. ',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'The Single Digit System',
      information: information,
      buttonColor: Colors.amber[100]!,
      buttonSplashColor: Colors.amber[300]!,
      firstHelpKey: singleDigitEditFirstHelpKey,
      callback: callback,
    );
  }
}
