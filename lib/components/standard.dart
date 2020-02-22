import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mem_plus_plus/constants/keys.dart';

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
  final Color complete1;
  final Color complete2;
  final Widget route;
  final Function() callback;
  final bool complete;
  final String activityStatesKey = 'ActivityStates';

  MainMenuOption({
    Key key,
    this.activity,
    this.icon,
    this.text,
    this.color,
    this.splashColor,
    this.complete1,
    this.complete2,
    this.route,
    this.complete,
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
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
              gradient: complete ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.46, 1.5),
                colors: [
                  complete1,
                  complete2,
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ) : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.52, 0.0),
                colors: [
                  color,
                  color,
                ], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
            ),
            child: FlatButton(
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
                        minHeight: 46,
                        maxHeight: 46,
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
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      )),
                    ),
                  ),
                  left: 3,
                  top: 4)
              : Container(),
          activity.visibleAfterTime.compareTo(DateTime.now()) < 0
              ? Container()
              : Container(
                width: screenWidth * 0.85,
                height: 48,
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
        ],
      ),
    );
  }
}

class CondensedMainMenuButtons extends StatelessWidget {
  final Activity editActivity;
  final Activity practiceActivity;
  final Activity testActivity;
  final Activity timedTestPrepActivity;
  final Icon testIcon;
  final String text;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonSplashColor;
  final Widget editRoute;
  final Widget practiceRoute;
  final Widget testRoute;
  final Widget timedTestPrepRoute;
  final Function() callback;
  var prefs = PrefsUpdater();

  CondensedMainMenuButtons({
    Key key,
    this.editActivity,
    this.practiceActivity,
    this.testActivity,
    this.timedTestPrepActivity,
    this.testIcon,
    this.text,
    this.backgroundColor,
    this.buttonColor,
    this.buttonSplashColor,
    this.editRoute,
    this.practiceRoute,
    this.testRoute,
    this.timedTestPrepRoute,
    this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: screenWidth * 0.85,
          decoration: BoxDecoration(
              border: Border.all(),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.52, 0.0),
                colors: [backgroundColor, buttonSplashColor], // whitish to gray
                tileMode:
                    TileMode.repeated, // repeats the gradient over the canvas
              ),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
                child: Text(text,
                    style: TextStyle(fontSize: 24), textAlign: TextAlign.start),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CondensedMenuButton(
                    activity: editActivity,
                    callback: callback,
                    route: editRoute,
                    icon: editIcon,
                    color: buttonColor,
                  ),
                  CondensedMenuButton(
                    activity: practiceActivity,
                    callback: callback,
                    route: practiceRoute,
                    icon: practiceIcon,
                    color: buttonColor,
                  ),
                  CondensedMenuButton(
                    activity: testActivity,
                    callback: callback,
                    route: testRoute,
                    icon: testIcon,
                    color: buttonColor,
                  ),
                  CondensedMenuButton(
                    activity: timedTestPrepActivity,
                    callback: callback,
                    route: timedTestPrepRoute,
                    icon: timedTestPrepIcon,
                    color: buttonColor,
                    testPrepAvailable: timedTestPrepActivity.visible,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 3,
        )
      ],
    );
  }
}

class CondensedMenuButton extends StatelessWidget {
  final Activity activity;
  final Function callback;
  final Widget route;
  final Icon icon;
  final Color color;
  final bool testPrepAvailable;
  final prefs = PrefsUpdater();

  CondensedMenuButton(
      {this.activity,
      this.callback,
      this.route,
      this.icon,
      this.color,
      this.testPrepAvailable = true});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 10,
      child: RaisedButton(
        child: icon,
        onPressed: testPrepAvailable
            ? () async {
                HapticFeedback.heavyImpact();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => route));
              }
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(),
        ),
        color: color,
      ),
    );
  }
}

class OKPopButton extends StatelessWidget {
  final Color color;
  final Color splashColor;

  OKPopButton(
      {Key key, this.color = Colors.white, this.splashColor = Colors.grey});

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
