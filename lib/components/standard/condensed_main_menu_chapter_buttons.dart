import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/activities.dart';
import 'package:mem_plus_plus/components/standard/condensed_menu_button.dart';

import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class CondensedMainMenuChapterButtons extends StatelessWidget {
  final Activity lesson;
  final Activity activity1;
  final Activity activity2;
  final IconData activity1Icon;
  final IconData activity2Icon;
  final String text;
  final Color standardColor;
  final Color darkerColor;
  final Widget lessonRoute;
  final Widget activity1Route;
  final Widget activity2Route;
  final Function() callback;
  final PrefsUpdater prefs = PrefsUpdater();

  CondensedMainMenuChapterButtons({
    Key? key,
    required this.lesson,
    required this.activity1,
    required this.activity2,
    required this.activity1Icon,
    required this.activity2Icon,
    required this.text,
    required this.standardColor,
    required this.darkerColor,
    required this.lessonRoute,
    required this.activity1Route,
    required this.activity2Route,
    required this.callback,
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
                end: Alignment.bottomRight,
                colors: [standardColor, darkerColor], // whitish to gray
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
                    style: TextStyle(fontSize: text.length > 24 ? 22 : 24),
                    textAlign: TextAlign.start),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CondensedMenuButton(
                    activity: lesson,
                    callback: callback,
                    route: lessonRoute,
                    icon: lessonIcon,
                    color: standardColor,
                  ),
                  CondensedMenuButton(
                    activity: activity1,
                    callback: callback,
                    route: activity1Route,
                    icon: activity1Icon,
                    color: standardColor,
                    testPrepAvailable: activity1.visible,
                  ),
                  CondensedMenuButton(
                    activity: activity2,
                    callback: callback,
                    route: activity2Route,
                    icon: activity2Icon,
                    color: standardColor,
                    testPrepAvailable: activity2.visible,
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
