import 'package:flutter/material.dart';
import 'package:gson/gson.dart';

//activityMenuButtonMap = {
//'Welcome': ActivityMenuButton(
//text: Text(
//'Welcome',
//style: TextStyle(fontSize: 24),
//),
//route: WelcomeScreen(),
//icon: Icon(Icons.filter),
//color: Colors.green[100]),

class Activity {
  String state;
  bool visible;
  DateTime visibleAfter;
  bool firstView;
  Widget menuText;

  Activity(this.state, this.visible, this.visibleAfter, this.firstView,
      this.menuText);

  Map<String, dynamic> toJson() => {
        'state': state,
        'visible': visible,
        'visibleAfter': visibleAfter.toIso8601String(),
        'firstView': firstView,
        'menuText': gson.encode(menuText),
      };

  factory Activity.fromJson(Map<String, dynamic> json) {
    return new Activity(
        json['state'],
        json['visible'],
        DateTime.parse(json['visibleAfter']),
        json['firstView'],
        gson.decode(json['menuText']));
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
  'Welcome': Activity('review', true, DateTime.now(), false, Text('welcome')),
  'SingleDigitEdit':
      Activity('todo', true, DateTime.now(), false, Text('test')),
  'SingleDigitPractice':
      Activity('todo', true, DateTime.now(), false, Text('test')),
  'SingleDigitMultipleChoiceTest':
      Activity('todo', true, DateTime.now(), false, Text('test')),
  'SingleDigitTimedTestPrep':
      Activity('todo', true, DateTime.now(), false, Text('test')),
  'SingleDigitTimedTest':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'AlphabetEdit': Activity('todo', false, DateTime.now(), false, Text('test')),
  'AlphabetPractice':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'AlphabetMultipleChoiceTest':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'AlphabetTimedTestPrep':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'AlphabetTimedTest':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'PAOEdit': Activity('todo', false, DateTime.now(), false, Text('test')),
  'PAOPractice': Activity('todo', false, DateTime.now(), false, Text('test')),
  'PAOMultipleChoiceTest':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'PAOTimedTestPrep':
      Activity('todo', false, DateTime.now(), false, Text('test')),
  'PAOTimedTest': Activity('todo', false, DateTime.now(), false, Text('test')),
};
