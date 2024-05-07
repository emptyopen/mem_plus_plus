import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/keys.dart';
import 'dart:math';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';

class FaceTimedTestPrepScreen extends StatefulWidget {
  final Function callback;

  FaceTimedTestPrepScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _FaceTimedTestPrepScreenState createState() =>
      _FaceTimedTestPrepScreenState();
}

class _FaceTimedTestPrepScreenState extends State<FaceTimedTestPrepScreen> {
  String face1 = '';
  String face2 = '';
  String name1 = '';
  String name2 = '';
  bool ready = false;
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration = debugModeEnabled
      ? Duration(seconds: debugTestTime)
      : Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    await prefs.checkFirstTime(context, faceTimedTestPrepFirstHelpKey,
        FacesTimedTestPrepScreenHelp(callback: widget.callback));
    if (!prefs.getBool(faceTestActiveKey)) {
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
        //String lastName = lastNames[random.nextInt(menNames.length)];
        // name1 = '$firstName $lastName';
      } else {
        face1 = 'women/woman$faceIndex1.jpg';
        String firstName = womenNames[random.nextInt(menNames.length)];
        name1 = firstName;
        // String lastName = lastNames[random.nextInt(menNames.length)];
        // name1 = '$firstName $lastName';
      }
      if (gender2IsMale) {
        face2 = 'men/man$faceIndex2.jpg';
        String firstName = menNames[random.nextInt(menNames.length)];
        name2 = firstName;
        // String lastName = lastNames[random.nextInt(menNames.length)];
        // name2 = '$firstName $lastName';
      } else {
        face2 = 'women/woman$faceIndex2.jpg';
        String firstName = womenNames[random.nextInt(menNames.length)];
        name2 = firstName;
        // String lastName = lastNames[random.nextInt(menNames.length)];
        // name2 = '$firstName $lastName';
      }
      prefs.setString('face1', face1);
      prefs.setString('face2', face2);
      prefs.setString('name1', name1);
      prefs.setString('name2', name2);
      prefs.setBool(faceTestActiveKey, true);
    } else {
      print('found active test, restoring values');
      face1 = (prefs.getString('face1'));
      face2 = (prefs.getString('face2'));
      name1 = (prefs.getString('name1'));
      name2 = (prefs.getString('name2'));
    }
    setState(() {
      ready = true;
    });
  }

  void updateStatus() async {
    prefs.setBool(faceTestActiveKey, false);
    prefs.updateActivityState(faceTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(faceTimedTestPrepKey, false);
    prefs.updateActivityState(faceTimedTestKey, 'todo');
    prefs.updateActivityVisible(faceTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
        faceTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, () {
      widget.callback();
    });
    notifyDuration(testDuration, 'Timed test (face) is ready!', 'Good luck!',
        faceTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Faces Test Prep'),
            backgroundColor: colorChapter1Standard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return FacesTimedTestPrepScreenHelp(
                            callback: widget.callback);
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
                ready
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: backgroundSemiHighlightColor),
                                    borderRadius: BorderRadius.circular(20)),
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
                                    fontSize: 22,
                                    color: backgroundHighlightColor),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: backgroundSemiHighlightColor),
                                    borderRadius: BorderRadius.circular(20)),
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
                                    fontSize: 22,
                                    color: backgroundHighlightColor),
                              )
                            ],
                          )
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 40,
                ),
                BasicFlatButton(
                  text: 'I\'m ready!',
                  color: colorChapter1Standard,
                  onPressed: () => showConfirmDialog(
                      context: context,
                      function: updateStatus,
                      confirmText:
                          'Are you sure you\'d like to start this test? The names will no longer be available to view!',
                      confirmColor: colorChapter1Darker),
                  fontSize: 30,
                  padding: 10,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  '(You\'ll be quizzed on this in thirty minutes!)',
                  textAlign: TextAlign.center,
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
  final Function callback;
  FacesTimedTestPrepScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Let\'s start with something practical, memorizing names! '
        'The best way to do this is to identify a permanent(ish) feature of the person, and link some scene '
        'to that feature. A deep voice, high cheekbones, green eyes, a distinctive mole, or something else unique! '
        'Never, ever, EVER (under any circumstances!) tell people their identifying feature!',
    '    For example, let\'s imagine someone named Fred. Maybe his nose is a little more squished than '
        'the average person, and he has prominent cheekbones. The name Fred might remind you of Fred Flintstone, so you could '
        'imagine Fred Flintstone flinging some rocks with prominent ridges at poor Fred. \n    All the rocks kept smashing '
        'his nose in! His cheekbones are prominent and strong, and deflected all stones from Fred Flintstone.',
    '    Or maybe you\'re at a party, and your friend Cassie introduces you to her friend Henry. Henry, Henry... sounds like a '
        'king\'s name. You imagine someone putting a big crown on his big head, and he sits down on a golden throne. Clutching his '
        'staff, he bellows to his peasants, spit flying everywhere: \n    "WE SHALL BEHEAD OUR ENEMIES!!"\n\n    And maybe now you '
        'won\'t have to ask Henry\'s name again when you\'re talking by the fridge in ten minutes.',
    '    If their name is in a language foreign to yours, imagine something that has a similar sound to their name. '
        'You can also break up the name into parts if the whole name is too difficult! '
        '\n    For example, \'Sifiso\' could be remembered with \'Sci-fi sew(ing)\', and a visualization for \'Anatoliy\' could '
        'include a scene with \'a Natalie (Portman)\'.'
        '\n    I know that this seems like it it would take a long time to think of scenes like the example, but you '
        'will get better and faster at it! ',
    '    Two final tips: attach the scene you concoct to some permanent feature of their face, not their clothing.\n\n    And never, ever '
        'explain the attachment feature to the person themself! They may be self-conscious of that feature, and it would be awkward, so just never do it.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Faces - Timed Test Preparation',
      information: information,
      buttonColor: colorChapter1Standard,
      buttonSplashColor: colorChapter1Darker,
      firstHelpKey: faceTimedTestPrepFirstHelpKey,
      callback: callback,
    );
  }
}
