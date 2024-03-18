import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/lesson_screen.dart';

class Lesson3Screen extends StatefulWidget {
  final Function callback;
  final GlobalKey globalKey;

  Lesson3Screen({required this.callback, required this.globalKey});

  @override
  _Lesson3ScreenState createState() => _Lesson3ScreenState();
}

class _Lesson3ScreenState extends State<Lesson3Screen> {
  bool alreadyComplete = false;
  var prefs = PrefsUpdater();

  final List<Widget> headers = [
    Text(
      'Chapter 3: Spaced Repetition',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Spaced Repetition in a Graph',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Learn it for life',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Lucky you!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          '    Spaced Repetition is a really cool concept. It\'s something that is intuitive, but also optimizable. '
          'Basically, it\'s the idea that you can maximize the speed in learning things by spacing out the '
          'reviews in increasing intervals. '
          '\n    I think the quickest way to understand is to look at a graph.',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '(Swipe through this quick lesson)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Image(
          image: AssetImage(
            'assets/images/spaced_repetition.png',
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '    As you can see in the graph, your ability recall a memory improves each time you review. '
          'Critically, that means we can review in increasingly longer spaced intervals.',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Text(
      '    You might review just ten minutes after you learn something the first time, quickly replaying '
      'the scene back over in your head. Then a review an hour after that will probably lock the memory '
      'in for eight hours. Then two days, two weeks, two months, two years. \n\n'
      '    If you memorize things efficiently, you can memorize something for life (easily) with less than ten '
      'reviews! Isn\'t that crazy?',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
    Text(
      '    You are an especially lucky winner, because upon completing this lesson you will unlock the Custom Memory Manager! '
      'You can create any type of memory you\'d like, and the tool will automatically take care of the spaced '
      'repetition schedule for you! ',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
  ];

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
    alreadyComplete = await prefs.getBool(lesson3CompleteKey) != null;
  }

  completeLesson() async {
    await prefs.updateActivityVisible(piTimedTestPrepKey, true);
    await prefs.updateActivityVisible(face2TimedTestPrepKey, true);
    await prefs.updateActivityState(lesson3Key, 'review');
    await prefs.setBool(customMemoryManagerAvailableKey, true);
    if (!alreadyComplete) {
      await prefs.setBool(customMemoryManagerFirstHelpKey, true);
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Congratulations! You\'ve unlocked the Custom Memory Manager!',
        textColor: Colors.white,
        backgroundColor: Colors.purple,
        durationSeconds: 3,
        isSuper: true,
      );
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Face (hard) test!',
        textColor: Colors.black,
        backgroundColor: colorChapter3Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Pi test!',
        textColor: Colors.black,
        backgroundColor: colorChapter3Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      await prefs.setBool(lesson3CompleteKey, true);
    }
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LessonScreen(
      title: 'Lesson 3',
      headers: headers,
      information: information,
      completeLesson: completeLesson,
      colorDarker: colorChapter3Darker,
      colorStandard: colorChapter3Standard,
    );
  }
}
