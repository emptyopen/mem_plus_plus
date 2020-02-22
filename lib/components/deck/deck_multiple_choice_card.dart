import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/deck/deck_data.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:math';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class DeckMultipleChoiceCard extends StatefulWidget {
  final DeckData deckData;
  final Function(BuildContext, bool) callback;

  DeckMultipleChoiceCard({this.deckData, this.callback});

  @override
  _DeckMultipleChoiceCardState createState() => _DeckMultipleChoiceCardState();
}

class _DeckMultipleChoiceCardState extends State<DeckMultipleChoiceCard> {
  bool done = false;
  int attempts = 0;
  DeckData fakeDeckChoice1;
  DeckData fakeDeckChoice2;
  DeckData fakeDeckChoice3;
  List<DeckData> deckDataList;
  List<DeckData> shuffledOptions = [
    DeckData(0, '0', 'nobody', 'does nothing', 'nothing', 0),
    DeckData(1, '0', 'nobody', 'does nothing', 'nothing', 0),
    DeckData(2, '0', 'nobody', 'does nothing', 'nothing', 0),
    DeckData(3, '0', 'nobody', 'does nothing', 'nothing', 0),
  ];
  String mapChoice;
  var mapChoices = [
    'digitToPersonActionObject',
    'personActionObjectToDigit',
  ];
  var deckChoices = [
    'person',
    'action',
    'object',
  ];
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  randomDeckChoice(deckEntry) {
    var deckChoice = deckChoices[Random().nextInt(deckChoices.length)];
    switch (deckChoice) {
      case 'person':
        return deckEntry.person;
        break;
      case 'action':
        return deckEntry.action;
        break;
      default:
        return deckEntry.object;
        break;
    }
  }

  Future<Null> getSharedPrefs() async {
    deckDataList = await prefs.getSharedPrefs(deckKey);

    mapChoice = mapChoices[Random().nextInt(mapChoices.length)];

    if (mapChoice == 'digitToPersonActionObject') {
      List<int> notAllowed = [widget.deckData.index];
      while (fakeDeckChoice1 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeDeckChoice1 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeDeckChoice2 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeDeckChoice2 = candidate;
          notAllowed.add(candidate.index);
        }
      }
      while (fakeDeckChoice3 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.index)) {
          fakeDeckChoice3 = candidate;
          notAllowed.add(candidate.index);
        }
      }
    } else {
      List<String> notAllowed = [widget.deckData.digitSuit];
      while (fakeDeckChoice1 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.digitSuit)) {
          fakeDeckChoice1 = candidate;
          notAllowed.add(candidate.digitSuit);
        }
      }
      while (fakeDeckChoice2 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.digitSuit)) {
          fakeDeckChoice2 = candidate;
          notAllowed.add(candidate.digitSuit);
        }
      }
      while (fakeDeckChoice3 == null) {
        DeckData candidate =
            deckDataList[Random().nextInt(deckDataList.length)];
        if (!notAllowed.contains(candidate.digitSuit)) {
          fakeDeckChoice3 = candidate;
          notAllowed.add(candidate.digitSuit);
        }
      }
    }

    setState(() {
      shuffledOptions = [
        widget.deckData,
        fakeDeckChoice1,
        fakeDeckChoice2,
        fakeDeckChoice3
      ];
      shuffledOptions = shuffle(shuffledOptions);
    });
  }

  List shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  void checkResult(int index) {
    if (shuffledOptions[index].digitSuit == widget.deckData.digitSuit) {
      final snackBar = SnackBar(
        content: Text(
          'Correct!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: colorCorrect,
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect! ${widget.deckData.digitSuit}: ${widget.deckData.person}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: colorIncorrect,
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        widget.callback(context, false);
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return done
        ? Container()
        : Container(
            height: screenHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(
                    mapChoice == 'digitToPersonActionObject' ? 'Card:' : 'PAO:',
                    style: TextStyle( 
                        fontSize: 26, color: backgroundHighlightColor),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: mapChoice == 'digitToPersonActionObject'
                        ? getDeckCard(widget.deckData.digitSuit, 'small')
                        : Text(
                            randomDeckChoice(widget.deckData),
                            style: TextStyle(
                                fontSize: 30, color: backgroundHighlightColor),
                            textAlign: TextAlign.center,
                          )),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: colorDeckStandard,
                  splashColor: colorDeckDarker,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    checkResult(0);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: mapChoice == 'digitToPersonActionObject'
                        ? Text(
                            randomDeckChoice(shuffledOptions[0]),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          )
                        : getDeckCard(shuffledOptions[0].digitSuit, 'small'),
                  ),
                ),
                FlatButton(
                  color: colorDeckStandard,
                  splashColor: colorDeckDarker,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    checkResult(1);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: mapChoice == 'digitToPersonActionObject'
                        ? Text(
                            randomDeckChoice(shuffledOptions[1]),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          )
                        : getDeckCard(shuffledOptions[1].digitSuit, 'small'),
                  ),
                ),
                FlatButton(
                  color: colorDeckStandard,
                  splashColor: colorDeckDarker,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    checkResult(2);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: mapChoice == 'digitToPersonActionObject'
                        ? Text(
                            randomDeckChoice(shuffledOptions[2]),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          )
                        : getDeckCard(shuffledOptions[2].digitSuit, 'small'),
                  ),
                ),
                FlatButton(
                  color: colorDeckStandard,
                  splashColor: colorDeckDarker,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    checkResult(3);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: mapChoice == 'digitToPersonActionObject'
                        ? Text(
                            randomDeckChoice(shuffledOptions[3]),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                            textAlign: TextAlign.center,
                          )
                        : getDeckCard(shuffledOptions[3].digitSuit, 'small'),
                  ),
                ),
                SizedBox(height: 60,)
              ],
            ));
  }
}
