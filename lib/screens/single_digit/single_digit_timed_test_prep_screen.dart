import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';


class SingleDigitTimedTestPrepScreen extends StatefulWidget {
  @override
  _SingleDigitTimedTestPrepScreenState createState() => _SingleDigitTimedTestPrepScreenState();
}

class _SingleDigitTimedTestPrepScreenState extends State<SingleDigitTimedTestPrepScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Single digit: timed test preparation'), actions: <Widget>[
        // action button
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) {
                return SingleDigitTimedTestPrepScreenHelp();
              }));
          },
        ),
      ]),
      body: Center(
        child: Text('hi')),
    );
  }
}

class SingleDigitTimedTestPrepScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: Text(
                      '    Welcome to your first timed test! \n\n'
                        '    Here we are going to present you with a 4 digit number. '
                        'Your goal is to memorize the number by converting the 4 digits '
                        'to their associated object. Then imagine a scene where the objects '
                        'are used in order. Once you are ready, the numbers will become unavailable '
                        'and in a couple hours you will have to decode the scene back into numbers. \n'
                        '    For example, let\'s look at the number 1234. Under the default '
                        'system, that would translate to stick, bird, bra, and sailboat. We '
                        'could imagine a stick falling out of the sky, landing and skewering a bird. Owch! '
                        'The bird is in a lot of pain. Luckily, it find a bra and makes a tourniquet out of it. '
                        'Now the bird can make it to the fancy dinner party on the sailboat tonight! Phew! \n'
                        '    Really think about that scene in your mind, and make it really vivid. Is the bird a '
                        'swan? How much does that swan squawk when it gets speared out of nowhere? '
                        'And boy oh boy does that swan want to make it to that party. \n'
                        '    Now let\'s attach that scene to this quiz. It\'s a timed test, so let\'s imagine '
                        'you up in the clouds, about to take this test. A huge timer clock is above you... ah, '
                        'yes, this is the place to take a timed test. And the first thing that happens is you '
                        'drop your pencil, and it rockets towards the earth, skewering that swan...',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                PopButton(
                  widget: Text('OK'),
                  color: Colors.amber[300],
                )
              ],
            ),
          ),
        ],
      ));
  }
}
