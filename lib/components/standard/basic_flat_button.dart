import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicFlatButton extends StatelessWidget {
  final Color color;
  final String text;
  final double fontSize;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final Color textColor;
  final String fontFamily;

  BasicFlatButton({
    this.color = Colors.white,
    required this.text,
    this.fontSize = 14,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    this.textColor = Colors.black,
    this.fontFamily = 'Viga',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            padding: padding,
            child: Center(
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
          ),
        ],
      ),
    );
  }
}
