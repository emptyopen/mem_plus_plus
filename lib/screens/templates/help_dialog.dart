import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/components/standard/sliding_tiles.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class HelpDialog extends StatefulWidget {
  final String title;
  final List<String> information;
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final Function? callback;

  HelpDialog({
    this.title = '',
    required this.information,
    required this.buttonColor,
    required this.buttonSplashColor,
    required this.firstHelpKey,
    this.callback,
  });

  @override
  _HelpDialogState createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  int slideIndex = 0;
  List<Widget> informationList = [];
  bool firstHelp = true;
  PrefsUpdater prefs = PrefsUpdater();
  final List<SlidingTileContent> tiles = [
    SlidingTileContent(
      header: 'Welcome to MEM++',
      content: [
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
    SlidingTileContent(
        header: '"Some people are just born with superior memories."',
        content: [
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
        ]),
    SlidingTileContent(
        header: '"It\'s too late for me, I\'ll never improve my memory."',
        content: [
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
        ]),
    SlidingTileContent(
        header: '"The brain can only store so much information."',
        content: [
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
        ]),
    SlidingTileContent(header: 'How this app works:', content: [
      Text(
        '    We\'ll start with some basic systems, and as you master them, new ones will unlock. Tests '
        'and lessons will be interspersed between the systems. '
        'In the main menu, you will be presented with a TO-DO section and a REVIEW section. \n    New '
        'systems and tasks will show up in the TO-DO section, and all systems and lessons you have mastered '
        'will still be available in the REVIEW section. \n'
        '    Okay, off you go!\n      - Matt',
        style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
      ),
    ]),
  ];

  @override
  void initState() {
    super.initState();

    // check if this is first time opening the screen
    checkFirstHelp();

    if (widget.information.length > 1) {
      informationList.add(Column(
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.information[0],
            style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '(Swipe for more information)',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ));
      widget.information.sublist(1).forEach((f) {
        informationList.add(Text(
          f,
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
          textAlign: TextAlign.left,
        ));
      });
    } else {
      informationList.add(Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.information[0],
            style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
            textAlign: TextAlign.left,
          ),
        ],
      ));
    }
  }

  checkFirstHelp() async {
    firstHelp = prefs.getBool(widget.firstHelpKey) == null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.75,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: SlidingTiles(
                        tiles: tiles,
                        showButtonEverySlide: (firstHelp &&
                                slideIndex == widget.information.length - 1) ||
                            debugModeEnabled ||
                            !firstHelp),
                  ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // (firstHelp && slideIndex == widget.information.length - 1) ||
                  //         debugModeEnabled ||
                  //         !firstHelp
                  //     ? HelpOKButton(
                  //         buttonColor: widget.buttonColor,
                  //         buttonSplashColor: widget.buttonSplashColor,
                  //         firstHelpKey: widget.firstHelpKey,
                  //         callback: widget.callback != null
                  //             ? widget.callback!
                  //             : () {},
                  //       )
                  //     : SizedBox(
                  //         height: 50,
                  //       ),
                ],
              ),
            ),
          ],
        ));
  }
}

class HelpOKButton extends StatelessWidget {
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final PrefsUpdater prefs = PrefsUpdater();
  final Function callback;

  HelpOKButton(
      {required this.buttonColor,
      required this.buttonSplashColor,
      required this.firstHelpKey,
      required this.callback});

  updateFirstHelp() {
    prefs.setBool(firstHelpKey, false);
  }

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        callback();
        updateFirstHelp();
        Navigator.pop(context);
      },
      text: 'OK',
      color: buttonColor,
      fontSize: 20,
      padding: 10,
    );
  }
}
