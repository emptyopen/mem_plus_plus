import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class Lesson3Screen extends StatefulWidget {
  final Function callback;
  final GlobalKey globalKey;

  Lesson3Screen({this.callback, this.globalKey});

  @override
  _Lesson3ScreenState createState() => _Lesson3ScreenState();
}

class _Lesson3ScreenState extends State<Lesson3Screen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int slideIndex = 0;
  bool firstTime = false;
  final IndexController indexController = IndexController();
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
    await prefs.updateActivityVisible(piTimedTestPrepKey, true);
    await prefs.updateActivityVisible(face2TimedTestPrepKey, true);
    await prefs.updateActivityState(lesson3Key, 'review');
    await prefs.setBool(customMemoryManagerAvailableKey, true);
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
      snackBarText: 'Congratulations! You\'ve unlocked the Pi test!',
      textColor: Colors.black,
      backgroundColor: colorChapter3Darker,
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
                                    begin: 0.2,
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
                                    text: 'Gimme!',
                                    color: colorChapter3Standard,
                                    splashColor: colorChapter3Darker,
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
                      information.length, slideIndex, colorChapter3Darker),
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
              title: Text('Chapter 3 Lesson'),
              backgroundColor: colorChapter3Darker,
            ),
            body: transformerPageView,
          );
  }
}
