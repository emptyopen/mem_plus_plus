import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class Lesson2Screen extends StatefulWidget {
  final Function callback;

  Lesson2Screen({this.callback});

  @override
  _Lesson2ScreenState createState() => _Lesson2ScreenState();
}

class _Lesson2ScreenState extends State<Lesson2Screen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int slideIndex = 0;
  bool firstTime = false;
  final IndexController indexController = IndexController();
  var prefs = PrefsUpdater();

  final List<Widget> headers = [
    Text(
      'Chapter 2: Quick Lesson',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'The Memory Palace',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          '    Today we\'re going to learn about something awesome, called the Memory Palace. '
          '*jazz fingers* Ooooooooooooohhhhh. \n\n    The Memory Palace is actually an ancient technique, '
          'been around since Ancient Roman times! I\'m not sure why this technique isn\'t taught to all '
          'children, but here we are!',
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
      '    Coming soon...',
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
    await prefs.updateActivityVisible(airportTimedTestPrepKey, true);
    await prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
    await prefs.updateActivityState(lesson2Key, 'review');
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
              Container(
                decoration: BoxDecoration(color: backgroundColor),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
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
                                  begin: 0.3,
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
                                  text: 'Bad developer! Shame!',
                                  color: colorChapter2Standard,
                                  splashColor: colorChapter2Darker,
                                  onPressed: completeLesson,
                                  padding: 10,
                                  fontSize: 28,
                                ),
                                position: info.position,
                                translationFactor: 300,
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: getSlideCircles(
                      information.length, slideIndex, colorChapter2Darker),
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
              title: Text('Chapter 2 Lesson'),
              backgroundColor: colorChapter2Darker,
            ),
            body: transformerPageView,
          );
  }
}
