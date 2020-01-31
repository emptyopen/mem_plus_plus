import 'package:flutter/material.dart';
import 'pao_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/flash_card.dart';

class PAOFlashCard extends StatefulWidget {
  final PAOData paoEntry;
  final Function() callback;

  PAOFlashCard({this.paoEntry, this.callback});

  @override
  _PAOFlashCardState createState() => _PAOFlashCardState();
}

class _PAOFlashCardState extends State<PAOFlashCard> {
  final prefs = PrefsUpdater();

  void nextActivity() async {
    await prefs.updateActivityState('PAOEdit', 'review');
    await prefs.updateActivityState('PAOPractice', 'review');
    await prefs.updateActivityFirstView('PAOMultipleChoiceTest', true);
    await prefs.updateActivityVisible('PAOMultipleChoiceTest', true);
    await prefs.setBool('PAOPracticeComplete', true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return FlashCard(
      activityKey: 'PAO',
      entry: widget.paoEntry,
      callback: widget.callback,
      nextActivityCallback: nextActivity,
      familiarityTotal: 10000,
      color: Colors.pink[200]
    );
  }
}
