import 'package:flutter/material.dart';

class Activity {
  String state;
  bool visible;
  DateTime visibleAfter;

  Activity(this.state, this.visible, this.visibleAfter);

  Map<String, dynamic> toJson() => {
        'state': state,
        'visible': visible,
        'visibleAfter': visibleAfter.toIso8601String(),
      };

  factory Activity.fromJson(Map<String, dynamic> json) {
    return new Activity(
        json['state'], json['visible'], DateTime.parse(json['visibleAfter']));
  }
}

class ActivityMenuButton {
  String text;
  Widget route;
  Icon icon;
  Color color;
  
  ActivityMenuButton({this.text, this.route, this.icon, this.color});
}

var defaultActivityStates = {
  'Welcome': Activity('review', true, DateTime.now()),
  'SingleDigitEdit': Activity('todo', true, DateTime.now()),
  'SingleDigitPractice': Activity('todo', true, DateTime.now()),
  'SingleDigitMultipleChoiceTest': Activity('todo', false, DateTime.now()),
  'SingleDigitTimeTestPrep': Activity('todo', false, DateTime.now()),
  'SingleDigitTimeTest': Activity('todo', false, DateTime.now()),
  'AlphabetEdit': Activity('todo', false, DateTime.now()),
  'AlphabetPractice': Activity('todo', false, DateTime.now()),
  'AlphabetMultipleChoiceTest': Activity('todo', false, DateTime.now()),
  'AlphabetTimeTestPrep': Activity('todo', false, DateTime.now()),
  'AlphabetTimeTest': Activity('todo', false, DateTime.now()),
  'PAOEdit': Activity('todo', false, DateTime.now()),
  'PAOPractice': Activity('todo', false, DateTime.now()),
  'PAOMultipleChoiceTest': Activity('todo', false, DateTime.now()),
  'PAOTimeTestPrep': Activity('todo', false, DateTime.now()),
  'PAOTimeTest': Activity('todo', false, DateTime.now()),
};
