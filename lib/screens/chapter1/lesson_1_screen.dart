import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/lesson_screen.dart';

class Lesson1Screen extends StatefulWidget {
  final Function callback;
  final GlobalKey globalKey;

  Lesson1Screen({required this.callback, required this.globalKey});

  @override
  _Lesson1ScreenState createState() => _Lesson1ScreenState();
}

class _Lesson1ScreenState extends State<Lesson1Screen> {
  PrefsUpdater prefs = PrefsUpdater();

  final List<SlidingTileContent> tiles = [
    SlidingTileContent(
      header: 'Chapter 1: Quick Lessons',
      content: [
        Text(
          '    Welcome to the first Lesson! I\'m going to do my best to condense '
          'information, but there\'s a mountain of it out there. I\'ll also divide up the lessons '
          'so that they are "bite-size". ',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '(Swipe through this quick lesson)',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    SlidingTileContent(
      header: 'What\'s the point?',
      content: [
        Text(
          '    There are certainly some fun party tricks: memorizing '
          'a whole deck of cards, or reciting thousands of digits of pi (people usually lose interest after about 100 digits).\n\n'
          '    But the real benefit is the incredible quality-of-'
          'life improvement. Imagine effortlessly recalling your checking account and routing numbers. Names at a party. '
          'Licences, passports, and passwords. Grocery lists, recipes. Security code combinations. '
          '\n\n    I no longer have to rifle through ancient emails or text threads for obscure information. '
          'I don\'t forget things when I go shopping, and I always remember exactly where I parked my car. The list '
          'goes on, and on, and on. Memory is a part of everything we do!',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'The general gist',
      content: [
        Text(
          '    For a long time, I thought memory was about retrieval skills. How wrong I was. '
          'It turns out, the most important aspect of memory is about how you store memories in the first place! '
          '\n\n    When you get home, do you close your eyes and spin around and throw your keys in a random direction? '
          'No, you put it somewhere where it\'s easy to find again. When you store a file on your computer, do you just dump it on the desktop in a chaotic mess? '
          'Okay, maybe you\'re guilty of that, but then you should also be familiar with the difficulty in finding old documents.\n\n'
          '    Reduce the friction in your recall efforts by making memories easier to access!',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'The general process',
      content: [
        Text(
          '    In general, I would break down the process of remembering anything into these steps:'
          '\n      1) "Convert" the memory to a story'
          '\n      2) Add "emotional detail" to the story'
          '\n      3) "Anchor" that story'
          '\n\n    Don\'t worry, we\'ll go over each of these steps in detail, in time!',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'Pay attention!',
      content: [
        Text(
          '    Paying attention, of course, is critical. It seems obvious, but it bears repeating. You\'ll really '
          'be surprised at how much more you remember simply by making a conscious effort '
          'to pay attention to things more.'
          '\n\n    For example, when someone introduces themselves and says their name, we\'re not going to just '
          'sit there and let that name just float into and out of our ears. No! '
          'We\'re going to learn how to actively grab a hold of it, and wrestle it into submission.',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'Dividends',
      content: [
        Text(
          '    The added bonus to all of this is that even being aware of your own memory '
          'will in and of itself improve your memory (it\'s all very meta, I know). Remember to pay attention, remember more!',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'Perservere!',
      content: [
        Text(
          '    Finally, the most imporant advice I can give you is to not give up. We all still forget things, '
          'but when that happens don\'t blame your amazing brain. \n\n'
          '    As I went through this learning process, I would still forget things. I still forget things. '
          'But for the first time, I understood that the reason I forgot something was not because of chaos or cosmic forces, but only because '
          'I didn\'t try hard enough to remember it. \n\n    I didn\'t anchor the memory well '
          'enough, or I didn\'t visualize the scenes in enough detail, or I didn\'t test myself on the '
          'memory often enough. I did better next time, and forgot less.',
          style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
        ),
      ],
    ),
    SlidingTileContent(
      header: 'Let\'s go!',
      content: [
        Text(
          '    These tools that you will learn aren\'t silver bullets, but I think you\'ll find '
          'that if you stick with them, you will soon remember anything you set your mind to. Learn and practice these '
          'systems, and believe in yourself.\n    Alright, enough lessons! Let\'s practice with two tests, and then you\'ll be onto your next system!',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
      ],
    ),
  ];

  completeLesson() async {
    prefs.updateActivityVisible(faceTimedTestPrepKey, true);
    prefs.updateActivityVisible(planetTimedTestPrepKey, true);
    if (!prefs.getBool(lesson1CompleteKey)) {
      showSnackBar(
        context: context,
        snackBarText: 'Congratulations! You\'ve unlocked the Face test!',
        textColor: Colors.black,
        backgroundColor: colorChapter1Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      showSnackBar(
        context: context,
        snackBarText: 'Congratulations! You\'ve unlocked the Planet test!',
        textColor: Colors.black,
        backgroundColor: colorChapter1Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      prefs.setBool(lesson1CompleteKey, true);
    }
    prefs.updateActivityState(lesson1Key, 'review');
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LessonScreen(
      title: 'Lesson 1',
      colorStandard: colorChapter1Standard,
      colorDarker: colorChapter1Darker,
      tiles: tiles,
      completeLesson: completeLesson,
    );
  }
}
