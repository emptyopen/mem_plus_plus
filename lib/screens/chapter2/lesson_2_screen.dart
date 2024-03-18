import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/templates/lesson_screen.dart';

class Lesson2Screen extends StatefulWidget {
  final Function callback;
  final GlobalKey globalKey;

  Lesson2Screen({required this.callback, required this.globalKey});

  @override
  _Lesson2ScreenState createState() => _Lesson2ScreenState();
}

class _Lesson2ScreenState extends State<Lesson2Screen> {
  PrefsUpdater prefs = PrefsUpdater();

  final List<Widget> headers = [
    Text(
      'Chapter 2: The Memory Palace',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'What is it?',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Getting started',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Example, please!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Setting up the location!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Sample apartment',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Mash it all together',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Keep mashing!',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Final mash',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
    Text(
      'Wrapping up',
      style: TextStyle(fontSize: 32, color: backgroundHighlightColor),
      textAlign: TextAlign.center,
    ),
  ];

  final List<Widget> information = [
    Column(
      children: <Widget>[
        Text(
          '    Today we\'re going to learn about the Memory Palace, an incredibly powerful tool for our toolkit. '
          'You may have heard of it before, maybe online, in a conversation, or in a Netflix documentary.'
          '\n\n    The Memory Palace is actually an ancient technique, and has '
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
      '    The memory palace is extremely powerful only because all of us are so good at remembering the exact '
      'layout of places we are familiar with. \n    Close your eyes and imagine any home or apartment you\'ve lived in, even as a younger child. '
      'Can you remember where your bedroom was compared to the kitchen? Of course! You remember where the fridge '
      'was in relation to the dishwasher and the microwave! You even remember the orientation of the toilet in the bathroom. '
      '\n    It doesn\'t even have to be a home! Maybe it\'s a train line that you\'ve taken every day of your life. '
      'As long as you can recall all of the stops in perfect order, feel free to use something like that, too!',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
    Text(
      '    What we are going to do with this method is assign a scene to particular sublocations in your memory palace. '
      '\n    We might want to start at the front door, and work our way clockwise around the room(s). We can go room by room, '
      'or we can break it down into smaller pieces, even using appliances or pieces of furniture! '
      '\n    Whatever the scene is, we want to "entangle" the memory to that sublocation. We\'ll go over an example in a '
      'moment, don\'t worry! \n    The point is, this method will become a powerful tool for recalling lists of items or '
      'sequences of events.',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          '    Alright! Since we only have the single digit and alphabet system mastered right now, '
          'let\'s take a look at remembering this shopping list: ',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        Text(
          '\n    - 2 gallons of milk\n    - a bunch of toilet paper'
          '\n    - 4 lbs of chicken breast'
          '\n    - some cilantro\n    - dish soap',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
          textAlign: TextAlign.start,
        ),
        Text(
          '\n    Oh, and on the way home let\'s stop by the cake shop to pick up Margaret\'s birthday cake! '
          'It\'s gonna be a fun party if we\'re getting this much chicken! ',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Text(
      '    A little tougher than your last timed test, huh! Not to worry, Memory Palace to the rescue! For the purposes '
      'of this example, let\'s imagine a simple apartment.\n\n    A front door entrance leads into a kitchen, which contains a '
      'fridge and a sink. If we keep moving clockwise around the apartment, we might choose the sofa in the living room, '
      'then the TV. The we go to the bedroom which contains our comfy bed, and finally the toilet in the bathroom!',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
    Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              child: Image(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                  'assets/images/room.png',
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          '    That\'s a pretty horrendous drawing by Matt! Is he trying to pull that blob off as a bed? It\'s not '
          'every day you see something this bad, haha. ',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          '    OK! Now we simply go from sub-location to sub-location, attaching our concocted scenes:\n\n',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        Text(
          '    2 gallons of milk / front door:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    We have to attach 2 gallons of milk to the front door. The ways we can do this are endless! I '
          'think if we just remember the number 2, we\'ll probably be able to figure out we were thinking about '
          'gallons.\n    My go-to objects for 2 are birds, so I might imagine a swan bringing a jug of milk '
          'and splashing the door with the milk. How rude! The swan then looks me square in the eyes and smugly smirks. '
          'Wow! Worst roommate ever. ',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          '    a bunch of toilet paper / fridge:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    Now we\'re at the fridge. We open the door, and toilet paper comes exploding outwards! Who put this much '
          'toilet paper in the fridge? It was probably the swan. And - oh GROSS! '
          'The toilet paper is USED! Briefly imagine the stench! You\'re not forgetting that one!',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        Text(
          '\n    4 lbs of chicken breast / sink:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    Onto the sink! The chickens are all lounging in your sink like it\'s a jacuuzi! They sure are making '
          'themselves feel at home, but that\'s fine. You are an impeccable host.\n    How many chickens did we '
          'need to get again? Let\'s put some of the chickens on a raft or a sailboat in the jacuzzi (for me, 4 = sailboat). '
          'Really picture all the chicken buddies having a good time together.',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          '    cilantro / sofa:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    Cilantro in the sofa cracks! Overflowing with cilantro. You sit down on the sofa and your pants turn green. '
          'Kick your legs up on the ottoman and inhale the pungency of cilantro.',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        Text(
          '\n    dish soap / bed:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    You go to lie down in your comfy bed to get away from the craziness, but unfortunately it\'s soaked with dish detergent. '
          'Luckily you are actually a plate, so now you\'re going to be squeaky clean!',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        Text(
          '\n    birthday cake / toilet:',
          style: TextStyle(fontSize: 22, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '    And finally we walk into the bathroom and what do we see? An edible toilet! Truly amazing, '
          'red velvet on the inside! Really delicious. Happy birthday Margaret!',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
      ],
    ),
    Text(
      '    You\'ll get a chance to practice this right away with the NATO phonetic alphabet and Morse code test! '
      'There are many variations and uses of the Memory Palace, but I think you get the general idea. \n'
      '    Two tests, and then you are onto one of the most exciting and powerful systems! ',
      style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
    ),
  ];

  completeLesson() async {
    prefs.updateActivityVisible(airportTimedTestPrepKey, true);
    prefs.updateActivityVisible(phoneticAlphabetTimedTestPrepKey, true);
    if (prefs.getBool(lesson1CompleteKey) == null) {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the NATO/Morse test!',
        textColor: Colors.black,
        backgroundColor: colorChapter2Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Congratulations! You\'ve unlocked the Airport test!',
        textColor: Colors.black,
        backgroundColor: colorChapter2Darker,
        durationSeconds: 3,
        isSuper: true,
      );
      prefs.setBool(lesson2CompleteKey, true);
    }
    prefs.updateActivityState(lesson2Key, 'review');
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LessonScreen(
      title: 'Lesson 2',
      headers: headers,
      information: information,
      colorStandard: colorChapter2Standard,
      colorDarker: colorChapter2Darker,
      completeLesson: completeLesson,
    );
  }
}
