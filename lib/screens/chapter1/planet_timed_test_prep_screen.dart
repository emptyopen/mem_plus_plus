import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PlanetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PlanetTimedTestPrepScreen({this.callback});

  @override
  _PlanetTimedTestPrepScreenState createState() =>
      _PlanetTimedTestPrepScreenState();
}

class _PlanetTimedTestPrepScreenState extends State<PlanetTimedTestPrepScreen> {
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: 5) : Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
    prefs.checkFirstTime(context, planetTimedTestPrepFirstHelpKey,
        PlanetTimedTestPrepScreenHelp());
  }

  void updateStatus() async {
    await prefs.setBool(planetTestActiveKey, false);
    await prefs.updateActivityState(planetTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(planetTimedTestPrepKey, false);
    await prefs.updateActivityState(planetTimedTestKey, 'todo');
    await prefs.updateActivityVisible(planetTimedTestKey, true);
    await prefs.updateActivityFirstView(planetTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
        planetTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (planet) is ready!', 'Good luck!',
        planetTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Planet: timed test prep'),
          backgroundColor: colorChapter1Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PlanetTimedTestPrepScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        width: screenWidth,
        decoration: BoxDecoration(color: backgroundColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Text(
              'The orders of the planets are: ',
              style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
            )),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      '#',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '1',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '4',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '6',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '7',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '8',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Planet',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Mercury',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Venus',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Earth',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Mars',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Jupiter',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Saturn',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Uranus',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      'Neptune',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Size rank',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '1',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '4',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '8',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '7',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '6',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                    Text(
                      '5',
                      style: TextStyle(
                        fontSize: 24,
                        color: backgroundHighlightColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            BasicFlatButton(
              text: 'My story is ready!',
              color: colorChapter1Darker,
              splashColor: colorChapter1Standard,
              onPressed: () => showConfirmDialog(
                  context: context,
                  function: updateStatus,
                  confirmText:
                      'Have you got everything memorized? Got a beautiful, wacky scene with lots of details?',
                  confirmColor: colorChapter1Standard),
              fontSize: 26,
              padding: 10,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '(You\'ll be quizzed on this in thirty minutes!)',
                style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlanetTimedTestPrepScreenHelp extends StatelessWidget {
  final List<String> information = [
    '    Well, you may have the planets memorized already! No problem. Either way, let\'s memorize an additional property '
        'of the planets: the order of their size! Most likely if you ever did learn the order of the planets, it was '
        'through some mnemonic like "my very eager mother just served us nine pizzas". \n    Not bad, but a pretty inflexible '
        'way to remember!',
    '    Let\'s try another method. Let\'s create a visual scene using words or concepts that we can strongly tie '
        'to certain planets. And because we have so much power in creating these scenes in our heads, we can very easily attach '
        'our digit-objects for the planet\'s size ranking to the scenes! \n\n    Let\'s look at an example.',
    '    We start with the Sun, I suppose. Fiery hellfire will be our anchor. '
        'From there we go to Mercury. Maybe a big vat of silver liquid mercury getting boiled by the sun will do the trick! '
        '\n    Now we want to attach the digit '
        'representing how small the planet is, the number 1! My object for number 1 is a stick, so I\'ll just imagine I stir the '
        'vat with a giant stick until something emerges. ',
    '    Next is Venus, what might we think of for that? The Roman goddess '
        'of beauty? The shaving razor? Let\'s go with the goddess of beauty. So we stir the shimmering liquid mercury, '
        'until a smoking hot babe emerges. Wow, how can someone be that attractive? '
        'And of course she\'s only wearing a bra (bra is my object for 3, and Venus is the 3rd biggest planet). ',
    '    Where did she get that bra? It\'s so sexy! Oh, she\'s pulling something out of her bra... the whole Earth! '
        'What a magic trick!\n'
        '    Pulling the entire Earth out of your bra is pretty tiring, so she goes and relaxes on her huge, luxurious yacht (4 is sailboat for me). '
        'I picture her from a bird\'s-eye view, laying down on the deck, the sun reflecting in her black, sexy sunglasses. Next to her on the yacht '
        'is the entire Earth, looking very tranquil. Earth on a yacht (Earth = 4). ',
    '    The story continues like this. '
        'Maybe next it starts raining Mars bars, or a god of war commandeers the yacht (Mars is the god of war), but I think you get the idea.'
        '\n\n    This sounds insane, I know. But I promise, if you start using that creativity inside your brain, something is '
        'going to start clicking. The wild scenes you can create in your head can be insanely memorable, and we '
        'are going to unlock that. ',
        '    You can see that we can now add other details to the story which could signify ANYTHING! '
        'The weights, colors, sizes, chemical compositions, or distances from the Sun could be converted to sub-scenes and '
        'appended to the scenes with very little additional effort. But we\'re not here to memorize the solar system, we\'re here to change your life!'
        '\n    Baby steps, baby steps. We\'ll peak Everest eventually.'
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Planet Timed Test Preparation',
      information: information,
      buttonColor: colorChapter1Standard,
      buttonSplashColor: colorChapter1Darker,
      firstHelpKey: planetTimedTestPrepFirstHelpKey,
    );
  }
}
