import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:math';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:flutter/services.dart';

class Face2TimedTestPrepScreen extends StatefulWidget {
  final Function callback;

  Face2TimedTestPrepScreen({Key key, this.callback}) : super(key: key);

  @override
  _Face2TimedTestPrepScreenState createState() => _Face2TimedTestPrepScreenState();
}

class _Face2TimedTestPrepScreenState extends State<Face2TimedTestPrepScreen> {
  String face1 = '';
  String name1 = '';
  String job1 = '';
  String age1 = '';
  String hometown1 = '';
  String face2 = '';
  String name2 = '';
  String job2 = '';
  String age2 = '';
  String hometown2 = '';
  var prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: 5) : Duration(hours: 3);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    await prefs.checkFirstTime(
        context, face2TimedTestPrepFirstHelpKey, Face2TimedTestPrepScreenHelp());
    bool face2TestIsActive = await prefs.getBool(face2TestActiveKey);
      if (face2TestIsActive == null || !face2TestIsActive) {
        print('no active test, setting new values');
        var random = new Random();
        var gender1IsMale = random.nextBool();
        var gender2IsMale = random.nextBool();
        String faceIndex1 = (random.nextInt(23) + 1).toString();
        String faceIndex2 = (random.nextInt(23) + 1).toString();
        while (faceIndex2 == faceIndex1) {
          faceIndex2 = (random.nextInt(23) + 1).toString();
        }
        if (gender1IsMale) {
          face1 = 'men/man$faceIndex1.jpg';
          String firstName = menNames[random.nextInt(menNames.length)];
          name1 = firstName;
          String lastName = lastNames[random.nextInt(menNames.length)];
          name1 = '$firstName $lastName';
        } else {
          face1 = 'women/woman$faceIndex1.jpg';
          String firstName = womenNames[random.nextInt(menNames.length)];
          name1 = firstName;
          String lastName = lastNames[random.nextInt(menNames.length)];
          name1 = '$firstName $lastName';
        }
        if (gender2IsMale) {
          face2 = 'men/man$faceIndex2.jpg';
          String firstName = menNames[random.nextInt(menNames.length)];
          name2 = firstName;
          String lastName = lastNames[random.nextInt(menNames.length)];
          name2 = '$firstName $lastName';
        } else {
          face2 = 'women/woman$faceIndex2.jpg';
          String firstName = womenNames[random.nextInt(menNames.length)];
          name2 = firstName;
          String lastName = lastNames[random.nextInt(menNames.length)];
          name2 = '$firstName $lastName';
        }
        age1 = (random.nextInt(20) + 18).toString();
        age2 = (random.nextInt(20) + 18).toString();
        job1 = jobs[random.nextInt(jobs.length)];
        job2 = jobs[random.nextInt(jobs.length)];
        hometown1 = cities[random.nextInt(cities.length)];
        hometown2 = cities[random.nextInt(cities.length)];
        prefs.setString('face2Face1', face1);
        prefs.setString('face2Name1', name1);
        prefs.setString('face2Age1', age1);
        prefs.setString('face2Job1', job1);
        prefs.setString('face2Hometown1', hometown1);
        prefs.setString('face2Face2', face2);
        prefs.setString('face2Name2', name2);
        prefs.setString('face2Age2', age2);
        prefs.setString('face2Job2', job2);
        prefs.setString('face2Hometown2', hometown2);
        prefs.setBool(face2TestActiveKey, true);
      } else {
        print('found active test, restoring values');
        face1 = await prefs.getString('face2Face1');
        name1 = await prefs.getString('face2Name1');
        age1 = await prefs.getString('face2Age1');
        job1 = await prefs.getString('face2Job1');
        hometown1 = await prefs.getString('face2Hometown1');
        face2 = await prefs.getString('face2Face2');
        name2 = await prefs.getString('face2Name2');
        age2 = await prefs.getString('face2Age2');
        job2 = await prefs.getString('face2Job2');
        hometown2 = await prefs.getString('face2Hometown2');
      }
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(face2TestActiveKey, false);
    await prefs.updateActivityState(face2TimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(face2TimedTestPrepKey, false);
    await prefs.updateActivityState(face2TimedTestKey, 'todo');
    await prefs.updateActivityVisible(face2TimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
        face2TimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Faces test (difficult) is ready!', 'Good luck!', face2TimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Faces (Difficult) Test Prep'),
            backgroundColor: colorChapter3Standard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return Face2TimedTestPrepScreenHelp();
                      }));
                },
              ),
            ]),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 60,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: backgroundSemiHighlightColor), borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(19),
                            child: Image(
                              height: 200,
                              image: AssetImage(
                                'assets/images/$face1',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          name1,
                          style: TextStyle(
                              fontSize: 22, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Age: $age1',
                          style: TextStyle(
                              fontSize: 22, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Job: $job1',
                          style: TextStyle(
                              fontSize: 20, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hometown: $hometown1',
                          style: TextStyle(
                              fontSize: 18, color: backgroundHighlightColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: backgroundSemiHighlightColor), borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(19),
                            child: Image(
                                height: 200,
                                image: AssetImage(
                                  'assets/images/$face2',
                                ),
                              ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          name2,
                          style: TextStyle(
                              fontSize: 22, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Age: $age2',
                          style: TextStyle(
                              fontSize: 22, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Job: $job2',
                          style: TextStyle(
                              fontSize: 20, color: backgroundHighlightColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Hometown: $hometown2',
                          style: TextStyle(
                              fontSize: 18, color: backgroundHighlightColor),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                BasicFlatButton(
                  text: 'I\'m ready!',
                  color: colorChapter3Standard,
                  splashColor: colorChapter3Darker,
                  onPressed: () => showConfirmDialog(
                      context: context,
                      function: updateStatus,
                      confirmText:
                          'Are you sure you\'d like to start this test? The names will no longer be available to view!',
                      confirmColor: colorChapter3Darker),
                  fontSize: 30,
                  padding: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(You\'ll be quizzed on this in 3 hours!)',
                  style:
                      TextStyle(fontSize: 18, color: backgroundHighlightColor),
                ),
                SizedBox(height: 40,),
              ],
            ), 
          ),
        ));
  }
}

class Face2TimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Welcome to hell-mode of the Faces test! Now, in addition to just a first name, we\'re '
    'going to memorize a last name, age, job, and hometown. Wow!'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Faces (Difficult) Timed Test Prep',
      information: information,
      buttonColor: colorChapter3Standard,
      buttonSplashColor: colorChapter3Darker,
      firstHelpKey: face2TimedTestPrepFirstHelpKey,
    );
  }
}
