import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/components/standard.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int _slideIndex = 0;
  final IndexController indexController = IndexController();

  final List<Widget> headers = [
    Text(
      'Welcome to MEM++',
      style: TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
    ),
    Text(
      'Myth-busting! (1/2)',
      style: TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
    ),
    Text(
      'Myth-busting! (2/2)',
      style: TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
    ),
    Text(
      'Pay attention, and visualize!',
      style: TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
    ),
    Text(
      'Invest!',
      style: TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
    ),
    Text(
      'How this app works:',
      style: TextStyle(fontSize: 32),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Icon> icons = [
    Icon(Icons.people, size: 60),
    Icon(Icons.cancel, size: 60),
    Icon(Icons.cancel, size: 60),
    Icon(Icons.remove_red_eye, size: 60),
    Icon(Icons.attach_money, size: 60),
    Icon(Icons.info, size: 60),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          'You\'re going to get a superpower! \n\n'
          'But let\'s resolve some myths first...\n',
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        Text(
          '(Swipe through this walkthrough)',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        )
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          '"My memory is bad, and there\'s nothing I can do about it."',
          style: TextStyle(fontSize: 22),
        ),
        Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
        Text(
          '    Memory champions have become so in less than a year of training - '
          'and none of them have claimed to have photographic memory '
          '(something which doesn\'t actually exist). '
          'They are just ordinary people who suddenly understand that they are capable, '
          'and make it their responsibility to improve their memory.\n'
          '    I can tell you from personal experience that at the age of 29 '
          'I was resigned to have a terrible memory for the rest of my life. '
          'All I did was encounter these strategies by accident while waiting in line for ramen, '
          'and within months I was able to rapidly improve my memory beyond all recognition.'
          '\n   If I can do it, so can you. - Matt',
          style: TextStyle(fontSize: 17),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          '"The brain can only store so much information."',
          style: TextStyle(fontSize: 22),
        ),
        Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
        Text(
          '    Okay, not totally false. The brain does have a limit, but it is far beyond anyone\'s reach - '
          'scientists estimate somewhere between 1 terabyte and 2.5 petabytes. \n    But don\'t '
          'worry about filling your brain with short term data, or trivial facts (10,000 digits of pi, no problem). '
          'If you store them correctly, more vital information won\'t get pushed out of your brain.\n'
          '    This is actually a good time to compare our brains to a computer. You wouldn\'t '
          'save every file onto your desktop in a disorganized mess, would you? '
          'Then let\'s not do that with our memories. You\'ll practice methods to compartmentalize down the line.'
          '',
          style: TextStyle(fontSize: 17),
        ),
      ],
    ),
    Text(
      '    You\'ll be surprised at how much more you remember simply by making a conscious effort '
      'to pay attention to things more. Even thinking about your memory like you are now '
      'will in and of itself improve your memory (it\'s all very meta, I know). '
      'Now, when you visualize in your brain what you\'re paying attention to, really amp up those details. '
      'Make it zanier and more visceral than real life. Make it sexual, noisy, violent, fragrant. \n'
      '    Let\'s look at an example. Your friend introduces you to her friend Henry... Henry, Henry, Henry. '
      'King Henry? Let\'s put a big gold crown on his big ol\' head (in our mind), and watch him sit down on '
      'his massive thrown. He bellows out to his people, "I AM YOUR KING!" (spit flying everywhere) '
      '"NOW BEHEAD THEM ALL!!"... and now maybe you\'re not going to have to ask his name '
      'again in three minutes when you end up talking to him by the fridge.',
      style: TextStyle(fontSize: 17),
    ),
    Text(
      '    A lot of techniques that you will learn require an investment of time. Not much though, '
      'and the benefits pay for life! Besides, the '
      'point of this app is to make it as easy as possible to break into this. '
      'Trust me, once you\'ve achieved some proficiency in the some of these systems, '
      'you\'ll be glad you did. \n    Never pull out a credit card, a passport, or a license for those pesky numbers'
      'and expiration dates. Remember everyone\'s name at a new party, '
      'and put on a performace by memorizing a deck of cards in less than '
      'a minute. Never again walk into a room and forget what you needed to do. Save yourself the hassle of running '
      'around the supermarket with your phone out. Recall your parking spot in the huge garage with ease. \n\n'
      '    Believe in yourself. Invest in yourself.',
      style: TextStyle(fontSize: 17),
    ),
    Text(
      '    We\'ll start with some basic systems, and as you master them, new ones will unlock. '
      'In the main menu, you will be presented with a TO-DO section and a REVIEW section. \n'
      '    New systems and tasks will show up in the TO-DO section, and all systems you have mastered '
      'will still be available in the REVIEW section. \n'
      '    When you start a new system, please click the information button in the menu bar '
      'to find out what\'s going on there. You\'ll know it when you see it! \n\n    Okay, off you go!',
      style: TextStyle(fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: indexController,
        transformer:
            PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
          return Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
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
                      ),
                      info.index == 0
                          ? SizedBox(
                              height: 40,
                            )
                          : Container(),
                      ParallaxContainer(
                        child: icons[info.index],
                        position: info.position,
                        translationFactor: 300,
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
                        translationFactor: 10,
                      ),
                      info.index != headers.length - 1
                          ? Container()
                          : SizedBox(
                              height: 10,
                            ),
                      info.index != headers.length - 1
                          ? Container()
                          : ParallaxContainer(
                              child: FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: BasicContainer(
                                  text: 'Main Menu',
                                  color: Colors.amber[50],
                                  fontSize: 28,
                                ),
                              ),
                              position: info.position,
                              translationFactor: 300,
                            ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: Text('${info.index + 1}/${headers.length}'),
                right: 10,
                bottom: 10,
              )
            ],
          );
        }),
        itemCount: headers.length);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      backgroundColor: Colors.white,
      body: transformerPageView,
    );
  }
}
