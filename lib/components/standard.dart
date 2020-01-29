import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BasicContainer extends StatelessWidget {
  BasicContainer({Key key, this.text, this.color, this.fontSize});

  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
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

  MainMenuOption({
    Key key,
    this.activity,
    this.icon = const Icon(Icons.access_alarm),
    this.text,
    this.color,
    this.route,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlatButton(
            onPressed: () async {
              if (activity.firstView) {
                // TODO: universal
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var rawMap = json.decode(prefs.getString(activityStatesKey))
                    as Map<String, dynamic>;
                Map<String, Activity> activityStates =
                    rawMap.map((k, v) => MapEntry(k, Activity.fromJson(v)));
                activityStates[activity.name].firstView = false;
                callback();
                prefs.setString(
                    activityStatesKey,
                    json.encode(
                      activityStates.map((k, v) => MapEntry(k, v.toJson())),
                    ));
              }
              final result = Navigator.push(
                  context, MaterialPageRoute(builder: (context) => route));
            },
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(width: 2),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Row(
                children: <Widget>[
                  icon,
                  SizedBox(
                    width: 20,
                  ),
                  text,
                ],
              ),
            )),
        activity.firstView
            ? Positioned(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      '!!',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                left: 5,
                top: 10)
            : Container()
      ],
    );
  }
}

class PopButton extends StatelessWidget {
  PopButton({Key key, this.widget, this.color});

  final Widget widget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Container(
            decoration: BoxDecoration(
              color: color,
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: widget));
  }
}
