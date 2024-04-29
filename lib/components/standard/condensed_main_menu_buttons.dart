import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/standard/condensed_menu_button.dart';

import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class CondensedMainMenuButtons extends StatelessWidget {
  final Activity editActivity;
  final Activity practiceActivity;
  final Activity testActivity;
  final Activity timedTestPrepActivity;
  final IconData testIcon;
  final String text;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonSplashColor;
  final Widget editRoute;
  final Widget practiceRoute;
  final Widget testRoute;
  final Widget timedTestPrepRoute;
  final Function callback;
  final PrefsUpdater prefs = PrefsUpdater();

  CondensedMainMenuButtons({
    Key? key,
    required this.editActivity,
    required this.practiceActivity,
    required this.testActivity,
    required this.timedTestPrepActivity,
    required this.testIcon,
    required this.text,
    required this.backgroundColor,
    required this.buttonColor,
    required this.buttonSplashColor,
    required this.editRoute,
    required this.practiceRoute,
    required this.testRoute,
    required this.timedTestPrepRoute,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        Container(
          height: 90,
          width: screenWidth * 0.85,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text(text,
                    style: TextStyle(fontSize: 14), textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CondensedMenuButton(
                    activity: editActivity,
                    callback: callback,
                    route: editRoute,
                    icon: editIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: practiceActivity,
                    callback: callback,
                    route: practiceRoute,
                    icon: practiceIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: testActivity,
                    callback: callback,
                    route: testRoute,
                    icon: testIcon,
                    color: backgroundColor,
                  ),
                  CondensedMenuButton(
                    activity: timedTestPrepActivity,
                    callback: callback,
                    route: timedTestPrepRoute,
                    icon: timedTestPrepIcon,
                    color: backgroundColor,
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
