import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class Activity {
  String name;
  String state;
  bool visible;
  DateTime visibleAfterTime;
  bool firstView;

  Activity(this.name, this.state, this.visible, this.visibleAfterTime, this.firstView);

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'visible': visible,
        'visibleAfter': visibleAfterTime.toIso8601String(),
        'firstView': firstView,
      };

  factory Activity.fromJson(Map<String, dynamic> json) {
    return new Activity(
      json['name'],
      json['state'],
      json['visible'],
      DateTime.parse(json['visibleAfter']),
      json['firstView'],
    );
  }
}

class ActivityMenuButton {
  String text;
  Widget route;
  Icon icon;
  Color color;
  Color splashColor;

  ActivityMenuButton({this.text, this.route, this.icon, this.color, this.splashColor});
}

var defaultActivityStatesInitial = {
  // name, state, visible, visibleAfter, firstView
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey: Activity(singleDigitEditKey, 'todo', true, DateTime.now(), true),
  singleDigitPracticeKey: Activity(singleDigitPracticeKey, 'todo', false, DateTime.now(), true),
  singleDigitMultipleChoiceTestKey: Activity(singleDigitMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  singleDigitTimedTestPrepKey: Activity(singleDigitTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  singleDigitTimedTestKey: Activity(singleDigitTimedTestKey, 'todo', false, DateTime.now(), true),
  alphabetEditKey: Activity(alphabetEditKey, 'todo', false, DateTime.now(), true),
  alphabetPracticeKey: Activity(alphabetPracticeKey, 'todo', false, DateTime.now(), true),
  alphabetWrittenTestKey: Activity(alphabetWrittenTestKey, 'todo', false, DateTime.now(), true),
  alphabetTimedTestPrepKey: Activity(alphabetTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  alphabetTimedTestKey: Activity(alphabetTimedTestKey, 'todo', false, DateTime.now(), true),
  paoEditKey: Activity(paoEditKey, 'todo', false, DateTime.now(), true),
  paoPracticeKey: Activity(paoPracticeKey, 'todo', false, DateTime.now(), true),
  paoMultipleChoiceTestKey: Activity(paoMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  paoTimedTestPrepKey: Activity(paoTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  paoTimedTestKey: Activity('paoTimedTestKey', 'todo', false, DateTime.now(), true),
  faceTimedTestPrepKey: Activity(faceTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  faceTimedTestKey: Activity(faceTimedTestKey, 'todo', false, DateTime.now(), true),
};

var defaultActivityStatesAllDone = {
  // name, state, visible, visibleAfter, firstView
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey: Activity(singleDigitEditKey, 'review', true, DateTime.now(), false),
  singleDigitPracticeKey: Activity(singleDigitPracticeKey, 'review', true, DateTime.now(), false),
  singleDigitMultipleChoiceTestKey: Activity(singleDigitMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestPrepKey: Activity(singleDigitTimedTestPrepKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestKey: Activity(singleDigitTimedTestKey, 'review', false, DateTime.now(), false),
  alphabetEditKey: Activity(alphabetEditKey, 'review', true, DateTime.now(), false),
  alphabetPracticeKey: Activity(alphabetPracticeKey, 'review', true, DateTime.now(), false),
  alphabetWrittenTestKey: Activity(alphabetWrittenTestKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestPrepKey: Activity(alphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestKey: Activity(alphabetTimedTestKey, 'review', false, DateTime.now(), false),
  paoEditKey: Activity(paoEditKey, 'review', true, DateTime.now(), false),
  paoPracticeKey: Activity(paoPracticeKey, 'review', true, DateTime.now(), false),
  paoMultipleChoiceTestKey: Activity(paoMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  paoTimedTestPrepKey: Activity(paoTimedTestPrepKey, 'review', true, DateTime.now(), false),
  paoTimedTestKey: Activity(paoTimedTestKey, 'todo', false, DateTime.now(), true),
  faceTimedTestPrepKey: Activity(faceTimedTestPrepKey, 'todo', true, DateTime.now(), true),
  faceTimedTestKey: Activity(faceTimedTestKey, 'todo', false, DateTime.now(), true),
};
