import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

class OKPopButton extends StatelessWidget {
  final Color color;
  final Color splashColor;

  OKPopButton(
      {Key? key, this.color = Colors.white, this.splashColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      text: 'OK',
      color: color,
      fontSize: 20,
      padding: 10,
    );
  }
}
