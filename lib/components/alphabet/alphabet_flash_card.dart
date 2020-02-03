import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/templates/flash_card.dart';
import 'package:mem_plus_plus/services/services.dart';

class AlphabetFlashCard extends StatefulWidget {
  final AlphabetData alphabetEntry;
  final Function() callback;

  AlphabetFlashCard({this.alphabetEntry, this.callback});

  @override
  _AlphabetFlashCardState createState() => _AlphabetFlashCardState();
}

class _AlphabetFlashCardState extends State<AlphabetFlashCard> {
  final prefs = PrefsUpdater();

  void nextActivity() async {
    await prefs.setBool('AlphabetPracticeComplete', true);
    await prefs.updateActivityState('AlphabetEdit', 'review');
    await prefs.updateActivityState('AlphabetPractice', 'review');
    await prefs.updateActivityVisible('AlphabetWrittenTest', true);
    await prefs.updateActivityFirstView('AlphabetWrittenTest', true);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return FlashCard(
      activityKey: 'Alphabet',
      entry: widget.alphabetEntry,
      callback: widget.callback,
      nextActivityCallback: nextActivity,
      familiarityTotal: 2600,
      color: Colors.blue[200],
    );
  }
}
