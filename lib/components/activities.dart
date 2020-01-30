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

var defaultActivityStates1 = {
  // name, state, visible, visibleAfter, firstView
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'todo', true, DateTime.now(), true),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'todo', true, DateTime.now(), true),
  'SingleDigitMultipleChoiceTest': Activity('SingleDigitMultipleChoiceTest', 'todo', true, DateTime.now(), true),
  'SingleDigitTimedTestPrep': Activity('SingleDigitTimedTestPrep', 'todo', true, DateTime.now(), true),
  'SingleDigitTimedTest': Activity('SingleDigitTimedTest', 'todo', false, DateTime.now(), true),
  'AlphabetEdit': Activity('AlphabetEdit', 'todo', false, DateTime.now(), true),
  'AlphabetPractice': Activity('AlphabetPractice', 'todo', false, DateTime.now(), true),
  'AlphabetWrittenTest': Activity('AlphabetWrittenTest', 'todo', false, DateTime.now(), true),
  'AlphabetTimedTestPrep': Activity('AlphabetTimedTestPrep', 'todo', false, DateTime.now(), true),
  'AlphabetTimedTest': Activity('AlphabetTimedTest', 'todo', false, DateTime.now(), true),
  'PAOEdit': Activity('PAOEdit', 'todo', false, DateTime.now(), true),
  'PAOPractice': Activity('PAOPractice', 'todo', false, DateTime.now(), true),
  'PAOMultipleChoiceTest': Activity('PAOMultipleChoiceTest', 'todo', false, DateTime.now(), true),
  'PAOTimedTestPrep': Activity('PAOTimedTestPrep', 'todo', false, DateTime.now(), true),
  'PAOTimedTest': Activity('PAOTimedTest', 'todo', false, DateTime.now(), true),
};

var defaultActivityStates2 = {
  // name, state, visible, visibleAfter, firstView
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'review', true, DateTime.now(), false),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'review', true, DateTime.now(), false),
  'SingleDigitMultipleChoiceTest': Activity('SingleDigitMultipleChoiceTest', 'review', true, DateTime.now(), false),
  'SingleDigitTimedTestPrep': Activity('SingleDigitTimedTestPrep', 'review', true, DateTime.now(), false),
  'SingleDigitTimedTest': Activity('SingleDigitTimedTest', 'review', false, DateTime.now(), false),
  'AlphabetEdit': Activity('AlphabetEdit', 'review', true, DateTime.now(), false),
  'AlphabetPractice': Activity('AlphabetPractice', 'review', true, DateTime.now(), false),
  'AlphabetWrittenTest': Activity('AlphabetWrittenTest', 'review', true, DateTime.now(), false),
  'AlphabetTimedTestPrep': Activity('AlphabetTimedTestPrep', 'review', true, DateTime.now(), false),
  'AlphabetTimedTest': Activity('AlphabetTimedTest', 'review', false, DateTime.now(), false),
  'PAOEdit': Activity('PAOEdit', 'todo', true, DateTime.now(), true),
  'PAOPractice': Activity('PAOPractice', 'todo', true, DateTime.now(), true),
  'PAOMultipleChoiceTest': Activity('PAOMultipleChoiceTest', 'todo', false, DateTime.now(), true),
  'PAOTimedTestPrep': Activity('PAOTimedTestPrep', 'todo', false, DateTime.now(), true),
  'PAOTimedTest': Activity('PAOTimedTest', 'todo', false, DateTime.now(), true),
};
