import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/sliding_tiles.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen();

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<SlidingTileContent> tiles = [
    SlidingTileContent(
      header: 'Welcome to MEM++',
      content: [
        Text(
          'So glad you could join us. \n\n'
          'We\'re going to get you a superpower. But first, let\'s clear up some common misconceptions about memory.\n',
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
            'and none of them have claimed to have "photographic" memory '
            '(something which doesn\'t actually exist - another common myth). \n'
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
            '    I can tell you from personal experience that at the ripe old age of 30 '
            'I was resigned to have a terrible memory for the rest of my life. I had the worst memory '
            'among all my friends. \n'
            '    All I did was encounter these strategies by accident while waiting in line for ramen, '
            'and within months I was able to rapidly improve my memory beyond all recognition.'
            '\n\n   If I can do it, so can you. ',
            style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
          ),
        ]),
    SlidingTileContent(
        header:
            '"If I learn something new, it pushes something old out of my brain."',
        content: [
          Text('FALSE!', style: TextStyle(fontSize: 28, color: Colors.red)),
          SizedBox(
            height: 10,
          ),
          Text(
            '    Okay, not totally false. The brain does have a theoretical information storage limit, but it is far beyond anyone\'s reach - '
            'researchers estimate somewhere between 1 terabyte and 2.5 petabytes. \n    But don\'t '
            'worry about filling your brain over capacity with short term data or trivial facts. '
            'If you store memories correctly, vital information won\'t get pushed out of your brain.\n',
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
        '    Okay, off you go!',
        style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Colors.green[200],
        automaticallyImplyLeading: false,
      ),
      body: SlidingTiles(
        tiles: tiles,
        showButtonEverySlide: true,
        buttonText: 'Main Menu',
      ),
    );
  }
}
