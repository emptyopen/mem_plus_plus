import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BasicFlatButton extends StatelessWidget {

  final Color color;
  final Color splashColor;
  final String text;
  final double fontSize;
  final Function onPressed;
  final double padding;
  final Color textColor;

  BasicFlatButton({this.color = Colors.white, this.splashColor, this.text, this.fontSize, this.onPressed, this.padding = 0, this.textColor = Colors.black});

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide()),
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
  final Widget text;
  final Color color;
  final Widget route;
  final String activityStatesKey = 'ActivityStates';
  final Function() callback;
  final bool doubleIcon;

  MainMenuOption({
    Key key,
    this.activity,
    this.icon,
    this.text,
    this.color,
    this.route,
    this.callback,
    this.doubleIcon,
  });

  String generateTimeRemaining() {
    int hours = activity.visibleAfter.difference(DateTime.now()).inHours;
    int minutes = activity.visibleAfter.difference(DateTime.now()).inMinutes - hours * 60;
    int seconds = activity.visibleAfter.difference(DateTime.now()).inSeconds - minutes * 60 - hours * 3600;
    if (hours > 1) {
      return 'Available in ${hours}h ${minutes}m';
    } else if (minutes >= 1) {
      return 'Available in ${minutes}m ${seconds}s';
    } else {
      return 'Available in $seconds seconds!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 50,
      child: Stack(
        children: <Widget>[
          FlatButton(
            color: color,
            shape: RoundedRectangleBorder(
                side: BorderSide(), borderRadius: BorderRadius.circular(5)),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              if (activity.visibleAfter.compareTo(DateTime.now()) > 0) {
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
              children: <Widget>[
                icon,
                SizedBox(
                  width: 10,
                  height: 45,
                ),
                text,
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
                      color: Colors.red[200],
                    ),
                    child: Center(child: Text('new!', style: TextStyle(fontSize: 12, fontFamily: 'SpaceMono', color: Colors.black),)),
                  ),
                  left: 5,
                  top: 6)
              : Container(),
          activity.visibleAfter.compareTo(DateTime.now()) < 0
              ? Container()
              : Positioned(
                  child: Container(
                    // TODO: this needs to be variable
                    width: 330,
                    height: 37.5,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.85),
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                        child: Text( generateTimeRemaining(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                  ),
                  left: 5,
                  top: 5,
                )
        ],
      ),
    );
  }
}

class OKPopButton extends StatelessWidget {
  OKPopButton({Key key});

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        text: 'OK',
        color: Colors.amber[100],
        splashColor: Colors.amber[300],
        fontSize: 20,
        padding: 10,
    );
  }
}

