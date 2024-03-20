import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewTag extends StatelessWidget {
  final double left;
  final double top;

  NewTag({this.left = 10, this.top = 5});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Container(
        width: 50,
        height: 25,
        decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          //color: Color.fromRGBO(255, 105, 180, 1),
          color: Color.fromRGBO(255, 255, 255, 0.85),
        ),
        child: Shimmer.fromColors(
          period: Duration(seconds: 3),
          baseColor: Colors.black,
          highlightColor: Colors.greenAccent,
          child: Center(
              child: Text(
            'new!',
            style: TextStyle(fontSize: 14, color: Colors.red),
          )),
        ),
      ),
      left: left,
      top: top,
    );
  }
}
