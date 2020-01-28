import 'package:flutter/material.dart';

class Activity {
  String state;
  bool visible;
  DateTime visibleAfter;
  bool firstView;

  Activity(this.state, this.visible, this.visibleAfter, this.firstView);

  Map<String, dynamic> toJson() => {
        'state': state,
        'visible': visible,
        'visibleAfter': visibleAfter.toIso8601String(),
        'firstView': firstView,
      };

  factory Activity.fromJson(Map<String, dynamic> json) {
    return new Activity(
        json['state'], json['visible'], DateTime.parse(json['visibleAfter']), json['firstView']);
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
  'Welcome': Activity('review', true, DateTime.now(), false),
  'SingleDigitEdit': Activity('todo', true, DateTime.now(), false),
  'SingleDigitPractice': Activity('todo', true, DateTime.now(), false),
  'SingleDigitMultipleChoiceTest': Activity('todo', true, DateTime.now(), false),
  'SingleDigitTimedTestPrep': Activity('todo', true, DateTime.now(), false),
  'SingleDigitTimedTest': Activity('todo', false, DateTime.now(), false),
  'AlphabetEdit': Activity('todo', false, DateTime.now(), false),
  'AlphabetPractice': Activity('todo', false, DateTime.now(), false),
  'AlphabetMultipleChoiceTest': Activity('todo', false, DateTime.now(), false),
  'AlphabetTimedTestPrep': Activity('todo', false, DateTime.now(), false),
  'AlphabetTimedTest': Activity('todo', false, DateTime.now(), false),
  'PAOEdit': Activity('todo', false, DateTime.now(), false),
  'PAOPractice': Activity('todo', false, DateTime.now(), false),
  'PAOMultipleChoiceTest': Activity('todo', false, DateTime.now(), false),
  'PAOTimedTestPrep': Activity('todo', false, DateTime.now(), false),
  'PAOTimedTest': Activity('todo', false, DateTime.now(), false),
};
