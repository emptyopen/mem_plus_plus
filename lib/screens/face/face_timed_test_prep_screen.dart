import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:math';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:flutter/services.dart';

class FaceTimedTestPrepScreen extends StatefulWidget {
  final Function callback;

  FaceTimedTestPrepScreen({Key key, this.callback}) : super(key: key);

  @override
  _FaceTimedTestPrepScreenState createState() => _FaceTimedTestPrepScreenState();
}

class _FaceTimedTestPrepScreenState extends State<FaceTimedTestPrepScreen> {
  String face1 = '';
  String face2 = '';
  String name1 = '';
  String name2 = '';
  var prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: 5) : Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    await prefs.checkFirstTime(
        context, faceTimedTestPrepFirstHelpKey, FacesTimedTestPrepScreenHelp());
    bool faceTestIsActive = await prefs.getBool(faceTestActiveKey);
      if (faceTestIsActive == null || !faceTestIsActive) {
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
          String lastName = lastNames[random.nextInt(menNames.length)];
          name1 = '$firstName $lastName';
        } else {
          face1 = 'women/woman$faceIndex1.jpg';
          String firstName = womenNames[random.nextInt(menNames.length)];
          String lastName = lastNames[random.nextInt(menNames.length)];
          name1 = '$firstName $lastName';
        }
        if (gender2IsMale) {
          face2 = 'men/man$faceIndex2.jpg';
          String firstName = menNames[random.nextInt(menNames.length)];
          String lastName = lastNames[random.nextInt(menNames.length)];
          name2 = '$firstName $lastName';
        } else {
          face2 = 'women/woman$faceIndex2.jpg';
          String firstName = womenNames[random.nextInt(menNames.length)];
          String lastName = lastNames[random.nextInt(menNames.length)];
          name2 = '$firstName $lastName';
        }
        prefs.setString('face1', face1);
        prefs.setString('face2', face2);
        prefs.setString('name1', name1);
        prefs.setString('name2', name2);
        prefs.setBool(faceTestActiveKey, true);
      } else {
        print('found active test, restoring values');
        face1 = await prefs.getString('face1');
        face2 = await prefs.getString('face2');
        name1 = await prefs.getString('name1');
        name2 = await prefs.getString('name2');
      }
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(faceTestActiveKey, false);
    await prefs.updateActivityState(faceTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(faceTimedTestPrepKey, false);
    await prefs.updateActivityState(faceTimedTestKey, 'todo');
    await prefs.updateActivityVisible(faceTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
        faceTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (face) is ready!', 'Good luck!', faceTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Faces Test Prep'),
            backgroundColor: colorFaceStandard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return FacesTimedTestPrepScreenHelp();
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
                Row(
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
                      ],
                    ),
                    SizedBox(
                      width: 30,
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
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                BasicFlatButton(
                  text: 'I\'m ready!',
                  color: colorFaceStandard,
                  splashColor: colorFaceDarker,
                  onPressed: () => showConfirmDialog(
                      context: context,
                      function: updateStatus,
                      confirmText:
                          'Are you sure you\'d like to start this test? The names will no longer be available to view!',
                      confirmColor: colorFaceDarker),
                  fontSize: 30,
                  padding: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(You\'ll be quizzed on this in thirty minutes!)',
                  style:
                      TextStyle(fontSize: 18, color: backgroundHighlightColor),
                ),
              ],
            ), 
          ),
        ));
  }
}

class FacesTimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Awesome job getting here! Now we\'re going to do something practical, memorizing names! '
    'The best way to do this is to identify a permanent(ish) feature of the person, and link some scene '
    'to that feature. A deep voice, high cheekbones, green eyes, a distinctive mole, or something else unique! '
    'Never, ever, EVER (under any circumstances!) tell people their identifying feature!',
    '    For example, let\'s imagine someone named Fred. Maybe his nose is a little more squished than '
    'the average person, and he has prominent cheekbones. The name Fred might remind you of Fred Flintstone, so you could '
    'imagine Fred Flintstone flinging some rocks with prominent ridges at poor Fred. \n    All the rocks kept smashing '
    'his nose in! His cheekbones are prominent and strong, and deflected all stones from Fred Flintstone.',
    '    If their name is in a language foreign to yours, imagine something that has a similar sound to their name. '
    'You can also break up the name into parts if the whole name is too difficult! '
    'For example, \'Sifiso\' could be remembered with \'Sci-fi sew(ing)\', and a visualization for \'Anatoliy\' could '
    'include a scene with \'a Natalie (Portman)\'.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Face Timed Test Preparation',
      information: information,
      buttonColor: colorFaceStandard,
      buttonSplashColor: colorFaceDarker,
      firstHelpKey: faceTimedTestPrepFirstHelpKey,
    );
  }
}
