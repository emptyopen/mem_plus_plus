import 'package:flutter/material.dart';

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
  Widget text;
  Widget route;
  Icon icon;
  Color color;
  Color splashColor;

  ActivityMenuButton({this.text, this.route, this.icon, this.color, this.splashColor});
}

var defaultActivityStatesInitial = {
  // name, state, visible, visibleAfter, firstView
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'todo', true, DateTime.now(), true),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'todo', false, DateTime.now(), true),
  'SingleDigitMultipleChoiceTest': Activity('SingleDigitMultipleChoiceTest', 'todo', false, DateTime.now(), true),
  'SingleDigitTimedTestPrep': Activity('SingleDigitTimedTestPrep', 'todo', false, DateTime.now(), true),
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

var defaultActivityStatesSingleDigitDone = {
  // name, state, visible, visibleAfter, firstView
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'review', true, DateTime.now(), false),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'review', true, DateTime.now(), false),
  'SingleDigitMultipleChoiceTest': Activity('SingleDigitMultipleChoiceTest', 'review', true, DateTime.now(), false),
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

var defaultActivityStatesAlphabetDone = {
  // name, state, visible, visibleAfter, firstView
  'Welcome': Activity('Welcome', 'review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('SingleDigitEdit', 'review', true, DateTime.now(), false),
  'SingleDigitPractice': Activity('SingleDigitPractice', 'review', true, DateTime.now(), false),
  'SingleDigitMultipleChoiceTest': Activity('SingleDigitMultipleChoiceTest', 'review', true, DateTime.now(), false),
  'SingleDigitTimedTestPrep': Activity('SingleDigitTimedTestPrep', 'review', true, DateTime.now(), false),
  'SingleDigitTimedTest': Activity('SingleDigitTimedTest', 'review', true, DateTime.now(), false),
  'AlphabetEdit': Activity('AlphabetEdit', 'review', true, DateTime.now(), false),
  'AlphabetPractice': Activity('AlphabetPractice', 'review', true, DateTime.now(), false),
  'AlphabetWrittenTest': Activity('AlphabetWrittenTest', 'review', true, DateTime.now(), false),
  'AlphabetTimedTestPrep': Activity('AlphabetTimedTestPrep', 'todo', true, DateTime.now(), true),
  'AlphabetTimedTest': Activity('AlphabetTimedTest', 'todo', false, DateTime.now(), true),
  'PAOEdit': Activity('PAOEdit', 'todo', false, DateTime.now(), true),
  'PAOPractice': Activity('PAOPractice', 'todo', false, DateTime.now(), true),
  'PAOMultipleChoiceTest': Activity('PAOMultipleChoiceTest', 'todo', false, DateTime.now(), true),
  'PAOTimedTestPrep': Activity('PAOTimedTestPrep', 'todo', false, DateTime.now(), true),
  'PAOTimedTest': Activity('PAOTimedTest', 'todo', false, DateTime.now(), true),
};

var defaultActivityStatesAllDone = {
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
  'PAOEdit': Activity('PAOEdit', 'review', true, DateTime.now(), false),
  'PAOPractice': Activity('PAOPractice', 'review', true, DateTime.now(), false),
  'PAOMultipleChoiceTest': Activity('PAOMultipleChoiceTest', 'review', true, DateTime.now(), false),
  'PAOTimedTestPrep': Activity('PAOTimedTestPrep', 'todo', true, DateTime.now(), true),
  'PAOTimedTest': Activity('PAOTimedTest', 'todo', false, DateTime.now(), true),
};
