import 'package:flutter/material.dart';
import 'pao_data.dart';
import 'package:mem_plus_plus/components/templates/edit_card.dart';

class PAOEditCard extends StatefulWidget {
  final PAOData paoData;
  final Function(List<PAOData>) callback;

  PAOEditCard({this.paoData, this.callback});

  @override
  _PAOEditCardState createState() => _PAOEditCardState();
}

class _PAOEditCardState extends State<PAOEditCard> {

  callback(List<PAOData> data) {
    widget.callback(data);
  }

  Widget build(BuildContext context) {
    return EditCard(
      entry: widget.paoData,
      activityKey: 'PAO',
      callback: callback,
    );
  }
}
