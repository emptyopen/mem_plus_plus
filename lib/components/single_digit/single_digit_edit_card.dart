import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';

class SingleDigitEditCard extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(List<SingleDigitData>) callback;

  SingleDigitEditCard({this.singleDigitData, this.callback});

  @override
  _SingleDigitEditCardState createState() => _SingleDigitEditCardState();
}

class _SingleDigitEditCardState extends State<SingleDigitEditCard> {


  callback(List<SingleDigitData> data) {
    widget.callback(data);
  }

  Widget build(BuildContext context) {
    return EditCard(
      entry: widget.singleDigitData,
      activityKey: 'SingleDigit',
      callback: callback,
    );
  }
}
