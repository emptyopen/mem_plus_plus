import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class Lesson1Screen extends StatefulWidget {
  final Function callback;
  final GlobalKey globalKey;

  Lesson1Screen({this.callback, this.globalKey});

  @override
  _Lesson1ScreenState createState() => _Lesson1ScreenState();
}

class _Lesson1ScreenState extends State<Lesson1Screen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int slideIndex = 0;
  bool firstTime = false;
  final IndexController indexController = IndexController();
  var prefs = PrefsUpdater();

  final List<Widget> headers = [
    Text(
      'Chapter 1: Quick Lessons',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'What\'s the point?',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'The general gist.',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Pay attention!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Perservere!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          '    I know how much we all hate reading walls of text! I\'m going to do my best to condense '
          'information, but there\'s a mountain of it out there. I\'ll also divide up the lessons '
          'so that they are "bite-size". ',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '(Swipe through this quick lesson)',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        )
      ],
    ),
    Text(
      '    My favorite demonstration that I use to get people invested into their memories is memorizing '
      'a deck of cards in ten minutes. I also tell them about the time I learned '
      '200 digits of pi in a few hours, but they never want to check :(\n\n'
      '    But those are just party tricks. The real value, at least for me, was the incredible quality-of-'
      'life improvement I started to experience. I started effortlessly recalling my credit card numbers, '
      'expiration dates. Licences and passports. Names and passwords. Grocery lists, recipes.'
      ' Security code combinations. Checking account and routing numbers. '
      '\n    I no longer have to painfully search through ancient emails or text threads for obscure information. '
      'I don\'t forget things when I go shopping, and I always remember exactly where I parked my car. The list '
      'goes on, and on, and on. Memory is a part of everything we do!',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
    Text(
      '    For a long time, I thought memory was about retrieval skills. How wrong I was. '
      'It turns out, the most important aspect of memory is about how you STORE it in the first place! '
      'When we store a file on our computer, do we just put everything on the desktop in a '
      'chaotic mess? No, of course not, it would be impossible to find anything!'
      '\n\n    In general, I would break down the process of remembering ANYTHING into these steps:'
      '\n      - Convert the memory to a story'
      '\n      - Add visceral detail to the story'
      '\n      - Anchor that story'
      '\n\n    Don\'t worry, we\'ll go over each of these steps in detail, in time!',
      style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
    ),
    Text(
      '    Paying attention, of course, is critical. It seems obvious, but it bears repeating. You\'ll really '
      'be surprised at how much more you remember simply by making a conscious effort '
      'to pay attention to things more.'
      '\n    For example, when someone introduces themselves and they say their name, we\'re not going to just '
      'sit there and let that name just float into our ears. No! '
      'We\'re going to learn how to actively grab a hold of it, and wrestle it into submission.'
      '\n    The added bonus about all of this is that simply thinking about your own memory '
      'will in and of itself improve your memory (it\'s all very meta, I know). Remember to pay attention, remember more!',
      style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
    ),
    Text(
      '    Finally, the most imporant advice I can give you is to not give up. We all still forget things, '
      'but when that happens don\'t blame your amazing, awesome brain. \n'
      '    When I got frustrated that I forgot something, I had to understand and '
      'accept that I simply didn\'t anchor the memory well '
      'enough, or I didn\'t visualize the scenes in enough detail, or I didn\'t test myself on the '
      'memory enough. \n    These tools that you will learn to wield aren\'t silver bullets, but I think you\'ll find '
      'that if you stick with them, you will soon remember anything you set your mind to. Learn and practice these '
      'systems, and believe in yourself. '
      '\n\n    Alright, enough lessons! Let\'s practice with two tests, and then you\'ll be onto your next system!',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
  ];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(
        seconds: 5,
      ),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  completeLesson() async {
    await prefs.updateActivityVisible(faceTimedTestPrepKey, true);
    await prefs.updateActivityVisible(planetTimedTestPrepKey, true);
    if (await prefs.getBool(lesson1CompleteKey) == null) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Face test!',
        textColor: Colors.black,
        backgroundColor: colorChapter1Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Planet test!',
        textColor: Colors.black,
        backgroundColor: colorChapter1Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      await prefs.setBool(lesson1CompleteKey, true);
    }
    await prefs.updateActivityState(lesson1Key, 'review');
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            slideIndex = index;
          });
        },
        loop: false,
        controller: indexController,
        transformer:
            PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(color: backgroundColor),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          ParallaxContainer(
                            child: info.index == 0
                                ? StaggerAnimation(
                                    widget: headers[info.index],
                                    controller: animationController,
                                    begin: 0,
                                    end: 1,
                                  )
                                : headers[info.index],
                            position: info.position,
                            translationFactor: 200,
                          ),
                          info.index == 0
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          ParallaxContainer(
                            child: info.index == 0
                                ? StaggerAnimation(
                                    widget: information[info.index],
                                    controller: animationController,
                                    begin: 0.1,
                                    end: 1,
                                  )
                                : information[info.index],
                            position: info.position,
                            translationFactor: 100,
                          ),
                          info.index != headers.length - 1
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          info.index != headers.length - 1
                              ? Container()
                              : ParallaxContainer(
                                  child: BasicFlatButton(
                                    text: 'Let\'s go!',
                                    color: colorChapter1Standard,
                                    splashColor: colorChapter1Darker,
                                    onPressed: completeLesson,
                                    padding: 10,
                                    fontSize: 28,
                                  ),
                                  position: info.position,
                                  translationFactor: 300,
                                ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: getSlideCircles(
                      information.length, slideIndex, colorChapter1Darker),
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          );
        }),
        itemCount: headers.length);

    return firstTime
        ? Scaffold(
            backgroundColor: backgroundColor,
            body: transformerPageView,
          )
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text('Chapter 1 Lesson'),
              backgroundColor: colorChapter1Darker,
            ),
            body: transformerPageView,
          );
  }
}
