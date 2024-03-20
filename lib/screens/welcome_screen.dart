import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';

import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class WelcomeScreen extends StatefulWidget {
  final bool firstTime;
  final Function callback;
  final Function mainMenuFirstTimeCallback;

  WelcomeScreen(
      {this.firstTime = false,
      required this.callback,
      required this.mainMenuFirstTimeCallback});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  int slideIndex = 0;
  final IndexController indexController = IndexController();
  PrefsUpdater prefs = PrefsUpdater();

  final List<Widget> headers = [
    Text(
      'Welcome to MEM++',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      '"Some people are just born with superior memories."',
      style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      '"It\'s too late for me, I\'ll never improve my memory."',
      style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      '"The brain can only store so much information."',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'How this app works:',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          'So glad you could join us. \n\n'
          'We\'re going to get you a superpower.\n',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
          textAlign: TextAlign.center,
        ),
        Text(
          '(Swipe through this walkthrough)',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(
      children: <Widget>[
        Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
        SizedBox(
          height: 10,
        ),
        Text(
          '    Memory champions have become so in less than a year of training - '
          'and none of them have claimed to have photographic memory '
          '(something which doesn\'t actually exist). \n'
          '    They are just ordinary people who suddenly understand that they are capable, '
          'and make it their responsibility to improve their memory.',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
        SizedBox(
          height: 10,
        ),
        Text(
          '    I can tell you from personal experience that at the ripe old age of 29 '
          'I was resigned to have a terrible memory for the rest of my life. I had the worst memory '
          'among all my friends. \n'
          '    All I did was encounter these strategies by accident while waiting in line for ramen, '
          'and within months I was able to rapidly improve my memory beyond all recognition.'
          '\n\n   If I can do it, so can you. ',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
        SizedBox(
          height: 10,
        ),
        Text(
          '    Okay, not totally false. The brain does have a limit, but it is far beyond anyone\'s reach - '
          'scientists estimate somewhere between 1 terabyte and 2.5 petabytes. \n    But don\'t '
          'worry about filling your brain with short term data or trivial facts. '
          'If you store them correctly, vital information won\'t get pushed out of your brain.\n',
          style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
        ),
      ],
    ),
    Text(
      '    We\'ll start with some basic systems, and as you master them, new ones will unlock. Tests '
      'and lessons will be interspersed between the systems. '
      'In the main menu, you will be presented with a TO-DO section and a REVIEW section. \n    New '
      'systems and tasks will show up in the TO-DO section, and all systems and lessons you have mastered '
      'will still be available in the REVIEW section. \n'
      '    Okay, off you go!\n      - Matt',
      style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
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

  void goToMainMenu(BuildContext context) async {
    HapticFeedback.lightImpact();
    if (widget.firstTime) {
      prefs.setBool(firstTimeAppKey, false);
      widget.callback();
      widget.mainMenuFirstTimeCallback();
    }
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
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
//                        ParallaxContainer(
//                          child: icons[info.index],
//                          position: info.position,
//                          translationFactor: 50,
//                        ),
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
                        debugModeEnabled && info.index == 0
                            ? ParallaxContainer(
                                child: BasicFlatButton(
                                  text: 'Main Menu',
                                  color: Colors.green[200]!,
                                  onPressed: () => goToMainMenu(context),
                                  padding: 10,
                                  fontSize: 28,
                                ),
                                position: info.position,
                                translationFactor: 300,
                              )
                            : Container(),
                        info.index != headers.length - 1
                            ? Container()
                            : ParallaxContainer(
                                child: BasicFlatButton(
                                  text: 'Main Menu',
                                  color: Colors.green[200]!,
                                  onPressed: () => goToMainMenu(context),
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
                      information.length, slideIndex, Colors.green[300]!),
                ),
                alignment: Alignment.bottomCenter,
              )
            ],
          );
        }),
        itemCount: headers.length);

    return widget.firstTime
        ? Scaffold(
            backgroundColor: backgroundColor,
            body: transformerPageView,
          )
        : Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: Text('Welcome'),
              backgroundColor: Colors.green[200],
            ),
            body: transformerPageView,
          );
  }
}
