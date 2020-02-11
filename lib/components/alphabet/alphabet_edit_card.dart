import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';

class AlphabetEditCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function(List<AlphabetData>) callback;

  AlphabetEditCard({this.alphabetData, this.callback});

  @override
  _AlphabetEditCardState createState() => _AlphabetEditCardState();
}

class _AlphabetEditCardState extends State<AlphabetEditCard> {

  callback(List<AlphabetData> data) {
    widget.callback(data);
  }

  Widget build(BuildContext context) {
    return EditCard(
      entry: widget.alphabetData,
      activityKey: 'Alphabet',
      callback: callback,
    );
  }
}
