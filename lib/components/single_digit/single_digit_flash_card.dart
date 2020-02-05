import 'package:flutter/material.dart';
import 'single_digit_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';

class SingleDigitFlashCard extends StatefulWidget {
  final SingleDigitData singleDigitEntry;
  final Function() callback;

  SingleDigitFlashCard({this.singleDigitEntry, this.callback});

  @override
  _SingleDigitFlashCardState createState() => _SingleDigitFlashCardState();
}

class _SingleDigitFlashCardState extends State<SingleDigitFlashCard> {
  final prefs = PrefsUpdater();

  void nextActivity() async {
    await prefs.setBool('SingleDigitPracticeComplete', true);
    await prefs.updateActivityState('SingleDigitEdit', 'review');
    await prefs.updateActivityState('SingleDigitPractice', 'review');
    await prefs.updateActivityVisible('SingleDigitMultipleChoiceTest', true);
    await prefs.updateActivityFirstView('SingleDigitMultipleChoiceTest', true);

    // todo: this needs to move to end of PAO, just dev for now
    await prefs.setBool('CustomTestManagerAvailable', true);
    if (await prefs.getBool('CustomTestManagerFirstView') == null) {
      await prefs.setBool('CustomTestManagerFirstView', true);
    }
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return FlashCard(
      activityKey: 'SingleDigit',
      entry: widget.singleDigitEntry,
      callback: widget.callback,
      nextActivityCallback: nextActivity,
      familiarityTotal: 1000,
      color: Colors.amber[200],
    );
  }
}


