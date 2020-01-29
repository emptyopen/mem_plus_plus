import 'package:flutter/material.dart';

class Activity {
  String name;
  String state;
  bool visible;
  DateTime visibleAfter;
  bool firstView;

  Activity(this.name, this.state, this.visible, this.visibleAfter, this.firstView);

  Map<String, dynamic> toJson() => {
        'name': name,
        'state': state,
        'visible': visible,
        'visibleAfter': visibleAfter.toIso8601String(),
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
  Widget text;
  Widget route;
  Icon icon;
  Color color;

  ActivityMenuButton({this.text, this.route, this.icon, this.color});
}

var defaultActivityStates = {
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'todo', true, DateTime.now(), true),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'todo', true, DateTime.now(), true),
  'SingleDigitMultipleChoiceTest':
      Activity('SingleDigitMultipleChoiceTest', 'todo', true, DateTime.now(), false),
  'SingleDigitTimedTestPrep': Activity('SingleDigitTimedTestPrep', 'todo', true, DateTime.now(), false),
  'SingleDigitTimedTest': Activity('SingleDigitTimedTest', 'todo', false, DateTime.now(), false),
  'AlphabetEdit': Activity('AlphabetEdit', 'todo', false, DateTime.now(), false),
  'AlphabetPractice': Activity('AlphabetPractice', 'todo', false, DateTime.now(), false),
  'AlphabetMultipleChoiceTest': Activity('AlphabetMultipleChoiceTest', 'todo', false, DateTime.now(), false),
  'AlphabetTimedTestPrep': Activity('AlphabetTimedTestPrep', 'todo', false, DateTime.now(), false),
  'AlphabetTimedTest': Activity('AlphabetTimedTest', 'todo', false, DateTime.now(), false),
  'PAOEdit': Activity('PAOEdit', 'todo', false, DateTime.now(), false),
  'PAOPractice': Activity('PAOPractice', 'todo', false, DateTime.now(), false),
  'PAOMultipleChoiceTest': Activity('PAOMultipleChoiceTest', 'todo', false, DateTime.now(), false),
  'PAOTimedTestPrep': Activity('PAOTimedTestPrep', 'todo', false, DateTime.now(), false),
  'PAOTimedTest': Activity('PAOTimedTest', 'todo', false, DateTime.now(), false),
};
