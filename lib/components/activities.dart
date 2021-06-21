import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class Activity {
  String name;
  String state;
  bool visible;
  DateTime visibleAfterTime;
  bool firstView;

  Activity(this.name, this.state, this.visible, this.visibleAfterTime,
      this.firstView);

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

  ActivityMenuButton(
      {this.text, this.route, this.icon, this.color, this.splashColor});
}

var defaultActivityStatesInitial = {
  // name, state, visible, visibleAfter, firstView
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey:
      Activity(singleDigitEditKey, 'todo', true, DateTime.now(), true),
  singleDigitPracticeKey:
      Activity(singleDigitPracticeKey, 'todo', false, DateTime.now(), true),
  singleDigitMultipleChoiceTestKey: Activity(
      singleDigitMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  singleDigitTimedTestPrepKey: Activity(
      singleDigitTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  singleDigitTimedTestKey:
      Activity(singleDigitTimedTestKey, 'todo', false, DateTime.now(), true),
  lesson1Key: Activity(lesson1Key, 'todo', false, DateTime.now(), true),
  faceTimedTestPrepKey:
      Activity(faceTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  faceTimedTestKey:
      Activity(faceTimedTestKey, 'todo', false, DateTime.now(), true),
  planetTimedTestPrepKey:
      Activity(planetTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  planetTimedTestKey:
      Activity(planetTimedTestKey, 'todo', false, DateTime.now(), true),
  alphabetEditKey:
      Activity(alphabetEditKey, 'todo', false, DateTime.now(), true),
  alphabetPracticeKey:
      Activity(alphabetPracticeKey, 'todo', false, DateTime.now(), true),
  alphabetWrittenTestKey:
      Activity(alphabetWrittenTestKey, 'todo', false, DateTime.now(), true),
  alphabetTimedTestPrepKey:
      Activity(alphabetTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  alphabetTimedTestKey:
      Activity(alphabetTimedTestKey, 'todo', false, DateTime.now(), true),
  lesson2Key: Activity(lesson2Key, 'todo', false, DateTime.now(), true),
  phoneticAlphabetTimedTestPrepKey: Activity(
      phoneticAlphabetTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  phoneticAlphabetTimedTestKey: Activity(
      phoneticAlphabetTimedTestKey, 'todo', false, DateTime.now(), true),
  airportTimedTestPrepKey:
      Activity(airportTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  airportTimedTestKey:
      Activity(airportTimedTestKey, 'todo', false, DateTime.now(), true),
  paoEditKey: Activity(paoEditKey, 'todo', false, DateTime.now(), true),
  paoPracticeKey: Activity(paoPracticeKey, 'todo', false, DateTime.now(), true),
  paoMultipleChoiceTestKey:
      Activity(paoMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  paoTimedTestPrepKey:
      Activity(paoTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  paoTimedTestKey:
      Activity(paoTimedTestKey, 'todo', false, DateTime.now(), true),
  lesson3Key: Activity(lesson3Key, 'todo', false, DateTime.now(), true),
  face2TimedTestPrepKey:
      Activity(face2TimedTestPrepKey, 'todo', false, DateTime.now(), true),
  face2TimedTestKey:
      Activity(face2TimedTestKey, 'todo', false, DateTime.now(), true),
  piTimedTestPrepKey:
      Activity(piTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  piTimedTestKey: Activity(piTimedTestKey, 'todo', false, DateTime.now(), true),
  deckEditKey: Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  deckPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  deckMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  deckTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  deckTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitEditKey:
      Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  tripleDigitPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  tripleDigitMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
};

var defaultActivityStatesChapter2Done = {
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey:
      Activity(singleDigitEditKey, 'review', true, DateTime.now(), false),
  singleDigitPracticeKey:
      Activity(singleDigitPracticeKey, 'review', true, DateTime.now(), false),
  singleDigitMultipleChoiceTestKey: Activity(
      singleDigitMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestPrepKey: Activity(
      singleDigitTimedTestPrepKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestKey:
      Activity(singleDigitTimedTestKey, 'review', false, DateTime.now(), false),
  lesson1Key: Activity(lesson1Key, 'review', true, DateTime.now(), false),
  faceTimedTestPrepKey:
      Activity(faceTimedTestPrepKey, 'review', true, DateTime.now(), false),
  faceTimedTestKey:
      Activity(faceTimedTestKey, 'review', false, DateTime.now(), false),
  planetTimedTestPrepKey:
      Activity(planetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  planetTimedTestKey:
      Activity(planetTimedTestKey, 'review', false, DateTime.now(), false),
  alphabetEditKey:
      Activity(alphabetEditKey, 'review', true, DateTime.now(), false),
  alphabetPracticeKey:
      Activity(alphabetPracticeKey, 'review', true, DateTime.now(), false),
  alphabetWrittenTestKey:
      Activity(alphabetWrittenTestKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestPrepKey:
      Activity(alphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestKey:
      Activity(alphabetTimedTestKey, 'review', false, DateTime.now(), false),
  lesson2Key: Activity(lesson2Key, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestPrepKey: Activity(
      phoneticAlphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestKey: Activity(
      phoneticAlphabetTimedTestKey, 'review', false, DateTime.now(), false),
  airportTimedTestPrepKey:
      Activity(airportTimedTestPrepKey, 'review', true, DateTime.now(), false),
  airportTimedTestKey:
      Activity(airportTimedTestKey, 'review', false, DateTime.now(), false),
  paoEditKey: Activity(paoEditKey, 'todo', true, DateTime.now(), true),
  paoPracticeKey: Activity(paoPracticeKey, 'todo', false, DateTime.now(), true),
  paoMultipleChoiceTestKey:
      Activity(paoMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  paoTimedTestPrepKey:
      Activity(paoTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  paoTimedTestKey:
      Activity(paoTimedTestKey, 'todo', false, DateTime.now(), true),
  lesson3Key: Activity(lesson3Key, 'todo', false, DateTime.now(), true),
  face2TimedTestPrepKey:
      Activity(face2TimedTestPrepKey, 'todo', false, DateTime.now(), true),
  face2TimedTestKey:
      Activity(face2TimedTestKey, 'todo', false, DateTime.now(), true),
  piTimedTestPrepKey:
      Activity(piTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  piTimedTestKey: Activity(piTimedTestKey, 'todo', false, DateTime.now(), true),
  deckEditKey: Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  deckPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  deckMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  deckTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  deckTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitEditKey:
      Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  tripleDigitPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  tripleDigitMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
};

var defaultActivityStatesChapter3Done = {
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey:
      Activity(singleDigitEditKey, 'review', true, DateTime.now(), false),
  singleDigitPracticeKey:
      Activity(singleDigitPracticeKey, 'review', true, DateTime.now(), false),
  singleDigitMultipleChoiceTestKey: Activity(
      singleDigitMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestPrepKey: Activity(
      singleDigitTimedTestPrepKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestKey:
      Activity(singleDigitTimedTestKey, 'review', false, DateTime.now(), false),
  lesson1Key: Activity(lesson1Key, 'review', true, DateTime.now(), false),
  faceTimedTestPrepKey:
      Activity(faceTimedTestPrepKey, 'review', true, DateTime.now(), false),
  faceTimedTestKey:
      Activity(faceTimedTestKey, 'review', false, DateTime.now(), false),
  planetTimedTestPrepKey:
      Activity(planetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  planetTimedTestKey:
      Activity(planetTimedTestKey, 'review', false, DateTime.now(), false),
  alphabetEditKey:
      Activity(alphabetEditKey, 'review', true, DateTime.now(), false),
  alphabetPracticeKey:
      Activity(alphabetPracticeKey, 'review', true, DateTime.now(), false),
  alphabetWrittenTestKey:
      Activity(alphabetWrittenTestKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestPrepKey:
      Activity(alphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestKey:
      Activity(alphabetTimedTestKey, 'review', false, DateTime.now(), false),
  lesson2Key: Activity(lesson2Key, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestPrepKey: Activity(
      phoneticAlphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestKey: Activity(
      phoneticAlphabetTimedTestKey, 'review', false, DateTime.now(), false),
  airportTimedTestPrepKey:
      Activity(airportTimedTestPrepKey, 'review', true, DateTime.now(), false),
  airportTimedTestKey:
      Activity(airportTimedTestKey, 'review', false, DateTime.now(), false),
  paoEditKey: Activity(paoEditKey, 'review', true, DateTime.now(), false),
  paoPracticeKey:
      Activity(paoPracticeKey, 'review', true, DateTime.now(), false),
  paoMultipleChoiceTestKey:
      Activity(paoMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  paoTimedTestPrepKey:
      Activity(paoTimedTestPrepKey, 'review', true, DateTime.now(), false),
  paoTimedTestKey:
      Activity(paoTimedTestKey, 'review', false, DateTime.now(), false),
  lesson3Key: Activity(lesson3Key, 'review', true, DateTime.now(), false),
  face2TimedTestPrepKey:
      Activity(face2TimedTestPrepKey, 'review', true, DateTime.now(), false),
  face2TimedTestKey:
      Activity(face2TimedTestKey, 'review', false, DateTime.now(), false),
  piTimedTestPrepKey:
      Activity(piTimedTestPrepKey, 'review', true, DateTime.now(), false),
  piTimedTestKey:
      Activity(piTimedTestKey, 'review', false, DateTime.now(), false),
  deckEditKey: Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  deckPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  deckMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  deckTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  deckTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitEditKey:
      Activity(deckEditKey, 'todo', false, DateTime.now(), true),
  tripleDigitPracticeKey:
      Activity(deckPracticeKey, 'todo', false, DateTime.now(), true),
  tripleDigitMultipleChoiceTestKey:
      Activity(deckMultipleChoiceTestKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'todo', false, DateTime.now(), true),
  tripleDigitTimedTestKey:
      Activity(deckTimedTestKey, 'todo', false, DateTime.now(), true),
};

var defaultActivityStatesAllDone = {
  welcomeKey: Activity(welcomeKey, 'review', true, DateTime.now(), false),
  singleDigitEditKey:
      Activity(singleDigitEditKey, 'review', true, DateTime.now(), false),
  singleDigitPracticeKey:
      Activity(singleDigitPracticeKey, 'review', true, DateTime.now(), false),
  singleDigitMultipleChoiceTestKey: Activity(
      singleDigitMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestPrepKey: Activity(
      singleDigitTimedTestPrepKey, 'review', true, DateTime.now(), false),
  singleDigitTimedTestKey:
      Activity(singleDigitTimedTestKey, 'review', false, DateTime.now(), false),
  lesson1Key: Activity(lesson1Key, 'review', true, DateTime.now(), false),
  faceTimedTestPrepKey:
      Activity(faceTimedTestPrepKey, 'review', true, DateTime.now(), false),
  faceTimedTestKey:
      Activity(faceTimedTestKey, 'review', false, DateTime.now(), false),
  planetTimedTestPrepKey:
      Activity(planetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  planetTimedTestKey:
      Activity(planetTimedTestKey, 'review', false, DateTime.now(), false),
  alphabetEditKey:
      Activity(alphabetEditKey, 'review', true, DateTime.now(), false),
  alphabetPracticeKey:
      Activity(alphabetPracticeKey, 'review', true, DateTime.now(), false),
  alphabetWrittenTestKey:
      Activity(alphabetWrittenTestKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestPrepKey:
      Activity(alphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  alphabetTimedTestKey:
      Activity(alphabetTimedTestKey, 'review', false, DateTime.now(), false),
  lesson2Key: Activity(lesson2Key, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestPrepKey: Activity(
      phoneticAlphabetTimedTestPrepKey, 'review', true, DateTime.now(), false),
  phoneticAlphabetTimedTestKey: Activity(
      phoneticAlphabetTimedTestKey, 'review', false, DateTime.now(), false),
  airportTimedTestPrepKey:
      Activity(airportTimedTestPrepKey, 'review', true, DateTime.now(), false),
  airportTimedTestKey:
      Activity(airportTimedTestKey, 'review', false, DateTime.now(), false),
  paoEditKey: Activity(paoEditKey, 'review', true, DateTime.now(), false),
  paoPracticeKey:
      Activity(paoPracticeKey, 'review', true, DateTime.now(), false),
  paoMultipleChoiceTestKey:
      Activity(paoMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  paoTimedTestPrepKey:
      Activity(paoTimedTestPrepKey, 'review', true, DateTime.now(), false),
  paoTimedTestKey:
      Activity(paoTimedTestKey, 'review', false, DateTime.now(), false),
  lesson3Key: Activity(lesson3Key, 'review', true, DateTime.now(), false),
  face2TimedTestPrepKey:
      Activity(face2TimedTestPrepKey, 'review', true, DateTime.now(), false),
  face2TimedTestKey:
      Activity(face2TimedTestKey, 'review', false, DateTime.now(), false),
  piTimedTestPrepKey:
      Activity(piTimedTestPrepKey, 'review', true, DateTime.now(), false),
  piTimedTestKey:
      Activity(piTimedTestKey, 'review', false, DateTime.now(), false),
  deckEditKey: Activity(deckEditKey, 'review', true, DateTime.now(), false),
  deckPracticeKey:
      Activity(deckPracticeKey, 'review', true, DateTime.now(), false),
  deckMultipleChoiceTestKey: Activity(
      deckMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  deckTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'review', true, DateTime.now(), false),
  deckTimedTestKey:
      Activity(deckTimedTestKey, 'review', false, DateTime.now(), false),
  tripleDigitEditKey:
      Activity(deckEditKey, 'review', true, DateTime.now(), false),
  tripleDigitPracticeKey:
      Activity(deckPracticeKey, 'review', true, DateTime.now(), false),
  tripleDigitMultipleChoiceTestKey: Activity(
      deckMultipleChoiceTestKey, 'review', true, DateTime.now(), false),
  tripleDigitTimedTestPrepKey:
      Activity(deckTimedTestPrepKey, 'review', true, DateTime.now(), false),
  tripleDigitTimedTestKey:
      Activity(deckTimedTestKey, 'review', false, DateTime.now(), false),
};
