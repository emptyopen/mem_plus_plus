import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/services.dart';

class DeckTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  DeckTimedTestScreen({this.callback, this.globalKey});

  @override
  _DeckTimedTestScreenState createState() => _DeckTimedTestScreenState();
}

class _DeckTimedTestScreenState extends State<DeckTimedTestScreen> {
  String card1 = '';
  String card2 = '';
  String card3 = '';
  String card4 = '';
  String card5 = '';
  String card6 = '';
  String card7 = '';
  String card8 = '';
  String card9 = '';
  List<String> dropdownDigit = ['A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A'];
  List<String> dropdownSuit = ['S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S', 'S'];
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, deckTimedTestFirstHelpKey, DeckTimedTestScreenHelp());
    // grab the digits
    card1 = await prefs.getString('deckTestDigits1');
    card2 = await prefs.getString('deckTestDigits2');
    card3 = await prefs.getString('deckTestDigits3');
    card4 = await prefs.getString('deckTestDigits4');
    card5 = await prefs.getString('deckTestDigits5');
    card6 = await prefs.getString('deckTestDigits6');
    card7 = await prefs.getString('deckTestDigits7');
    card8 = await prefs.getString('deckTestDigits8');
    card9 = await prefs.getString('deckTestDigits9');
    print(
        'real answer: $card1$card2$card3 $card4$card5$card6 $card7$card8$card9');
    setState(() {});
  }

  void checkAnswer() async {
    HapticFeedback.heavyImpact();
    if (dropdownDigit[0] + dropdownSuit[0] == '$card1' &&
    dropdownDigit[1] + dropdownSuit[1] == '$card2' &&
    dropdownDigit[2] + dropdownSuit[2] == '$card3' &&
    dropdownDigit[3] + dropdownSuit[3] == '$card4' &&
    dropdownDigit[4] + dropdownSuit[4] == '$card5' &&
    dropdownDigit[5] + dropdownSuit[5] == '$card6' &&
    dropdownDigit[6] + dropdownSuit[6] == '$card7' &&
    dropdownDigit[7] + dropdownSuit[7] == '$card8' &&
    dropdownDigit[8] + dropdownSuit[8] == '$card9') {
      await prefs.updateActivityVisible(deckTimedTestKey, false);
      await prefs.updateActivityVisible(deckTimedTestPrepKey, true);
      if (await prefs.getActivityState(deckTimedTestKey) == 'todo') {
        await prefs.updateActivityState(deckTimedTestKey, 'review');
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations! Now go practice on an entire real deck! You\'ve unlocked the XXX test!',
          textColor: Colors.black,
          backgroundColor: Colors.yellow,
          durationSeconds: 4,
          isSuper: true,
        );
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Congratulations! Now go practice on an entire real deck! ',
          textColor: Colors.black,
          backgroundColor: colorDeckStandard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.heavyImpact();
    await prefs.updateActivityState(deckTimedTestKey, 'review');
    await prefs.updateActivityVisible(deckTimedTestKey, false);
    await prefs.updateActivityVisible(deckTimedTestPrepKey, true);
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'The correct answers were: \n$card1 $card2 $card3\n$card4 $card5 $card6\n$card7 $card8 $card9\nTry the timed test again to unlock the next system.',
        backgroundColor: colorIncorrect,
        durationSeconds: 8);
    Navigator.pop(context);
    widget.callback();
  }

  dropDownPair(index) {
    double fontSize = 20;
    return Container(
      height: 120,
      width: 80,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(), borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[100],
            ),
            child: DropdownButton<String>(
              value: dropdownDigit[index],
              elevation: 16,
              style: TextStyle(color: colorDeckStandard),
              iconEnabledColor: Colors.black,
              underline: Container(
                height: 2,
                color: colorDeckStandard,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownDigit[index] = newValue;
                });
              },
              items: <String>[
                'A',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10',
                'J',
                'Q',
                'K'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black, fontSize: fontSize),
                  ),
                );
              }).toList(),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: backgroundColor,
            ),
            child: DropdownButton<String>(
              value: dropdownSuit[index],
              elevation: 16,
              style: TextStyle(color: colorDeckStandard),
              iconEnabledColor: Colors.black,
              underline: Container(
                height: 2,
                color: colorDeckStandard,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownSuit[index] = newValue;
                });
              },
              items: <String>[
                'S',
                'H',
                'C',
                'D',
              ].map<DropdownMenuItem<String>>((String value) {
                var suitSymbol = Icon(
                  MdiIcons.cardsDiamond,
                  size: fontSize,
                  color: Colors.red,
                );
                switch (value) {
                  case 'S':
                    suitSymbol = Icon(MdiIcons.cardsSpade,
                        size: fontSize, color: Colors.black);
                    break;
                  case 'H':
                    suitSymbol = Icon(MdiIcons.cardsHeart,
                        size: fontSize, color: Colors.red);
                    break;
                  case 'C':
                    suitSymbol = Icon(MdiIcons.cardsClub,
                        size: fontSize, color: Colors.black);
                    break;
                  default:
                    suitSymbol = Icon(MdiIcons.cardsDiamond,
                        size: fontSize, color: Colors.red);
                }
                return DropdownMenuItem<String>(
                  value: value,
                  child: suitSymbol,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Deck: timed test'),
          backgroundColor: colorDeckDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return DeckTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(color: backgroundColor),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Choose the cards:',
                  style:
                      TextStyle(fontSize: 30, color: backgroundHighlightColor),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    dropDownPair(0),
                    SizedBox(width: 10,),
                    dropDownPair(1),
                    SizedBox(width: 10,),
                    dropDownPair(2),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    dropDownPair(3),
                    SizedBox(width: 10,),
                    dropDownPair(4),
                    SizedBox(width: 10,),
                    dropDownPair(5),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    dropDownPair(6),
                    SizedBox(width: 10,),
                    dropDownPair(7),
                    SizedBox(width: 10,),
                    dropDownPair(8),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BasicFlatButton(
                      text: 'Give up',
                      onPressed: () => giveUp(),
                      color: Colors.grey[200],
                      splashColor: Colors.grey,
                      padding: 10,
                      fontSize: 24,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    BasicFlatButton(
                      text: 'Submit',
                      onPressed: () => checkAnswer(),
                      color: colorDeckStandard,
                      splashColor: colorDeckDarker,
                      padding: 10,
                      fontSize: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeckTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Deck Timed Test',
      information: [
        '    Time to recall your story! If you recall this correctly, you\'ll '
            'unlock the next system! Good luck!'
      ],
      buttonColor: colorDeckStandard,
      buttonSplashColor: colorDeckDarker,
      firstHelpKey: deckTimedTestFirstHelpKey,
    );
  }
}
