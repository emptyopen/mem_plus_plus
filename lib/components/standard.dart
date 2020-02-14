import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';

class BasicFlatButton extends StatelessWidget {
  final Color color;
  final Color splashColor;
  final String text;
  final double fontSize;
  final Function onPressed;
  final double padding;
  final Color textColor;

  BasicFlatButton(
      {this.color = Colors.white,
      this.splashColor,
      this.text,
      this.fontSize,
      this.onPressed,
      this.padding = 0,
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      splashColor: splashColor,
      highlightColor: Colors.transparent,
      onPressed: () {
        HapticFeedback.heavyImpact();
        onPressed();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), side: BorderSide()),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: textColor),
        ),
      ),
    );
  }
}

class MainMenuOption extends StatelessWidget {
  final Activity activity;
  final Icon icon;
  final String text;
  final Color color;
  final Color splashColor;
  final Widget route;
  final Function() callback;
  final String activityStatesKey = 'ActivityStates';

  MainMenuOption({
    Key key,
    this.activity,
    this.icon,
    this.text,
    this.color,
    this.splashColor,
    this.route,
    this.callback,
  });

  String generateTimeRemaining() {
    return durationToString(
        activity.visibleAfterTime.difference(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 50,
      width: screenWidth * 0.85,
      child: Stack(
        children: <Widget>[
          FlatButton(
            color: color,
            splashColor: splashColor,
            highlightColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                side: BorderSide(), borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              if (activity.visibleAfterTime.compareTo(DateTime.now()) > 0) {
                return null;
              }
              if (activity.firstView) {
                // TODO: universal
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var rawMap = json.decode(prefs.getString(activityStatesKey))
                    as Map<String, dynamic>;
                Map<String, Activity> activityStates =
                    rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
                activityStates[activity.name].firstView = false;
                prefs.setString(
                    activityStatesKey,
                    json.encode(
                      activityStates.map((k, v) => MapEntry(k, v.toJson())),
                    ));
                callback();
              }
              final result = Navigator.push(
                  context, MaterialPageRoute(builder: (context) => route));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                icon,
                ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: screenWidth * .65,
                      maxWidth: screenWidth * .65,
                      minHeight: 45.0,
                      maxHeight: 45.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          text,
                          style: TextStyle(fontSize: 41),
                          maxLines: 1,
                          maxFontSize: 24,
                        ),
                      ],
                    )),
              ],
            ),
          ),
          activity.firstView
              ? Positioned(
                  child: Container(
                    width: 40,
                    height: 20,
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
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.red),
                      )),
                    ),
                  ),
                  left: 3,
                  top: 4)
              : Container(),
          activity.visibleAfterTime.compareTo(DateTime.now()) < 0
              ? Container()
              : Positioned(
                  child: Container(
                    width: screenWidth * 0.83,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.85),
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text(
                      generateTimeRemaining(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                  left: 0,
                  top: 0,
                ),
        ],
      ),
    );
  }
}

class OKPopButton extends StatelessWidget {
  final Color color;
  final Color splashColor;

  OKPopButton({Key key, this.color = Colors.white, this.splashColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        Navigator.pop(context);
      },
      text: 'OK',
      color: color,
      splashColor: splashColor,
      fontSize: 20,
      padding: 10,
    );
  }
}
