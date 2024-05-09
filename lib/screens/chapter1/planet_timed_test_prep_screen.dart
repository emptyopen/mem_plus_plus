import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class PlanetTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  PlanetTimedTestPrepScreen({required this.callback});

  @override
  _PlanetTimedTestPrepScreenState createState() =>
      _PlanetTimedTestPrepScreenState();
}

class _PlanetTimedTestPrepScreenState extends State<PlanetTimedTestPrepScreen> {
  PrefsUpdater prefs = PrefsUpdater();
  Duration testDuration = debugModeEnabled
      ? Duration(seconds: debugTestTime)
      : Duration(minutes: 30);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
    prefs.checkFirstTime(context, planetTimedTestPrepFirstHelpKey,
        PlanetTimedTestPrepScreenHelp(callback: widget.callback));
  }

  void updateStatus() async {
    prefs.setBool(planetTestActiveKey, false);
    prefs.updateActivityState(planetTimedTestPrepKey, 'review');
    prefs.updateActivityVisible(planetTimedTestPrepKey, false);
    prefs.updateActivityState(planetTimedTestKey, 'todo');
    prefs.updateActivityVisible(planetTimedTestKey, true);
    prefs.updateActivityFirstView(planetTimedTestKey, true);
    prefs.updateActivityVisibleAfter(
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
    double photoHeight =
        screenWidth / 0.3397435897; // ratio is 265 x 780 = 0.3397435897
    //print(photoHeight); // 1211
    double availableHeight = photoHeight - 414;

    // photo is determined by width
    // 30 + 34 + 30 + 30 * 8 + 80 = 414
    // 1211 - 414 = available space

    SizedBox sizedBoxHeight2 = SizedBox(height: availableHeight * 0.049);
    // planets
    SizedBox sizedBoxHeight3 = SizedBox(height: availableHeight * 0.04);
    SizedBox sizedBoxHeight4 = SizedBox(height: availableHeight * 0.037);
    SizedBox sizedBoxHeight5 = SizedBox(height: availableHeight * 0.044);
    SizedBox sizedBoxHeight6 = SizedBox(height: availableHeight * 0.04);
    // jupiter
    SizedBox sizedBoxHeight7 = SizedBox(height: availableHeight * 0.15);
    SizedBox sizedBoxHeight8 = SizedBox(height: availableHeight * 0.26);
    SizedBox sizedBoxHeight9 = SizedBox(height: availableHeight * 0.19);
    SizedBox sizedBoxHeight10 = SizedBox(height: availableHeight * 0.05);
    SizedBox sizedBoxHeight11 = SizedBox(height: availableHeight * 0.08);

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
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return PlanetTimedTestPrepScreenHelp(
                          callback: widget.callback);
                    }));
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/images/planets.png',
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                // 34?
                Container(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'The orders of the planets are: ',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                sizedBoxHeight2,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    Column(
                      children: <Widget>[
                        PlanetText(text: 'Planet:'),
                        sizedBoxHeight3,
                        PlanetText(text: 'Mercury'),
                        sizedBoxHeight4,
                        PlanetText(text: 'Venus'),
                        sizedBoxHeight5,
                        PlanetText(text: 'Earth'),
                        sizedBoxHeight6,
                        PlanetText(text: 'Mars'),
                        sizedBoxHeight7,
                        PlanetText(text: 'Jupiter'),
                        sizedBoxHeight8,
                        PlanetText(text: 'Saturn'),
                        sizedBoxHeight9,
                        PlanetText(text: 'Uranus'),
                        sizedBoxHeight10,
                        PlanetText(text: 'Neptune'),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        PlanetText(
                          text: 'Size:',
                          width: 75,
                        ),
                        sizedBoxHeight3,
                        PlanetText(
                          text: '1',
                          width: 30,
                        ),
                        sizedBoxHeight4,
                        PlanetText(
                          text: '3',
                          width: 30,
                        ),
                        sizedBoxHeight5,
                        PlanetText(
                          text: '4',
                          width: 30,
                        ),
                        sizedBoxHeight6,
                        PlanetText(
                          text: '2',
                          width: 30,
                        ),
                        sizedBoxHeight7,
                        PlanetText(
                          text: '8',
                          width: 30,
                        ),
                        sizedBoxHeight8,
                        PlanetText(
                          text: '7',
                          width: 30,
                        ),
                        sizedBoxHeight9,
                        PlanetText(
                          text: '6',
                          width: 30,
                        ),
                        sizedBoxHeight10,
                        PlanetText(
                          text: '5',
                          width: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                sizedBoxHeight11,
                BasicFlatButton(
                  text: 'My story is ready!',
                  color: colorChapter1Darker,
                  onPressed: () => showConfirmDialog(
                      context: context,
                      function: updateStatus,
                      confirmText:
                          'Have you got everything memorized? Got a beautiful, wacky scene with lots of details?',
                      confirmColor: colorChapter1Standard),
                  fontSize: 22,
                ),
                SizedBox(height: 10),
                Container(
                  child: Text(
                    '(You\'ll be quizzed on this in thirty minutes!)',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlanetText extends StatelessWidget {
  final String text;
  final double width;

  PlanetText({required this.text, this.width = 110});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class PlanetTimedTestPrepScreenHelp extends StatelessWidget {
  final Function callback;
  PlanetTimedTestPrepScreenHelp({Key? key, required this.callback})
      : super(key: key);
  final List<String> information = [
    '    Well, you may have the planets memorized already! No problem. Either way, let\'s memorize an additional property '
        'of the planets: the order of their size!\n    If you ever did learn the order of the planets, it was likely '
        'through some mnemonic like "my very eager mother just served us nine pizzas". \n    Not bad, but a pretty inflexible '
        'way to remember!',
    '    Let\'s try another method. Let\'s create a visual scene using words or concepts that we can strongly tie '
        'to certain planets. And because we have so much power in creating these scenes in our heads, we can very easily attach '
        'our digit-objects for the planet\'s size ranking to the scenes! \n\n    Let\'s look at an example.',
    '    We start with the Sun. Fiery hellfire will be our anchor. '
        'From there we go to Mercury. Maybe a big vat of silver liquid mercury getting boiled by the sun will do the trick! '
        '\n    Now we want to attach the digit '
        'representing how small the planet is, the number 1! My object for number 1 is a stick, so I\'ll '
        'just imagine that I\'m stirring the vat of MERCURY with a giant STICK until something emerges. ',
    '    Next is Venus, what might we think of for that? The Roman goddess '
        'of beauty? The shaving razor? Let\'s go with the goddess of beauty.\n    So we stir the shimmering liquid mercury, '
        'until a smoking hot babe emerges. Wow, how can someone be that attractive? '
        'And of course VENUS is only wearing a BRA (bra is my object for 3, and Venus is the 3rd biggest planet). ',
    '    Where did she get that bra? It\'s so sexy! Oh, she\'s pulling something out of her bra... the whole Earth! '
        'What a magic trick!\n'
        '    Pulling the entire Earth out of your bra is pretty tiring, so she goes and relaxes on her huge, luxurious yacht (4 is sailboat for me). '
        'I picture her from a bird\'s-eye view, laying down on the deck, the sun reflecting in her black, sexy sunglasses. Next to her on the yacht '
        'is the entire Earth, looking very tranquil. EARTH on a YACHT (Earth = 4). ',
    '    The story continues like this. '
        'Maybe next it starts raining MARS bars into the mouths of BIRDS (my #2), or a god of war commandeers the yacht (Mars is the god of war), but I think you get the idea.'
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
    return HelpDialog(
      title: 'Planets - Timed Test Preparation',
      information: information,
      buttonColor: colorChapter1Standard,
      buttonSplashColor: colorChapter1Darker,
      firstHelpKey: planetTimedTestPrepFirstHelpKey,
      callback: callback,
    );
  }
}
