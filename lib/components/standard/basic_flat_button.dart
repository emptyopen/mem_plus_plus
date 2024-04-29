import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicFlatButton extends StatelessWidget {
  final Color color;
  final String text;
  final double fontSize;
  final Function onPressed;
  final double padding;
  final Color textColor;
  final String fontFamily;

  BasicFlatButton({
    this.color = Colors.white,
    required this.text,
    this.fontSize = 14,
    required this.onPressed,
    this.padding = 0,
    this.textColor = Colors.black,
    this.fontFamily = 'Viga',
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: color),
      onPressed: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
