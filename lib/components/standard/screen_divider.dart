import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class ScreenDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3,
      width: 280,
      decoration: BoxDecoration(
        color: backgroundHighlightColor,
        border: Border.all(),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
