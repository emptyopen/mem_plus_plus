import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BigButton extends StatelessWidget {
  final String title;
  final Function function;
  final Color color1;
  final Color color2;

  BigButton(
      {required this.title,
      required this.function,
      required this.color1,
      required this.color2});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        function();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color1,
              color2,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
