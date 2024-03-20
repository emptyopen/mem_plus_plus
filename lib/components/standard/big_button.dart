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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color1,
            color2,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          function();
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
