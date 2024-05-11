import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';

import 'package:mem_plus_plus/components/data/deck_data.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class MultipleChoiceCard extends StatefulWidget {
  final Key key;
  final String systemKey;
  final dynamic entry;
  final List<dynamic> shuffledChoices;
  final Function callback;
  final Function nextActivityCallback;
  final int familiarityTotal;
  final Color color;
  final Color lighterColor;
  final bool isLastCard;
  final List results;

  MultipleChoiceCard({
    required this.key,
    required this.systemKey,
    required this.entry,
    required this.shuffledChoices,
    required this.callback,
    required this.nextActivityCallback,
    required this.familiarityTotal,
    required this.color,
    required this.lighterColor,
    this.isLastCard = false,
    required this.results,
  });

  @override
  _MultipleChoiceCardState createState() => _MultipleChoiceCardState();
}

class _MultipleChoiceCardState extends State<MultipleChoiceCard> {
  int attempts = 0;
  bool isValueToProperty = true; // i.e. is Digit -> Object
  String paoChoice = 'person';
  var paoChoices = [
    'person',
    'action',
    'object',
  ];
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  getSharedPrefs() async {
    var random = Random();

    // randomize digit/digitSuit -> object/PAO/card, card/PAO/object -> digit/digitSuit
    switch (widget.systemKey) {
      case singleDigitKey:
        isValueToProperty = random.nextBool();
        break;
      case paoKey:
        isValueToProperty = random.nextBool();
        paoChoice = paoChoices[Random().nextInt(paoChoices.length)];
        break;
      case deckKey:
        isValueToProperty = random.nextBool();
        paoChoice = paoChoices[Random().nextInt(paoChoices.length)];
        break;
    }

    setState(() {
      attempts = 0;
      widget.results.forEach((attempt) {
        if (attempt != null) {
          attempts += 1;
        }
      });
    });
  }

  String getTitleType() {
    if (widget.systemKey == paoKey) {
      return isValueToProperty ? 'Digit:' : paoChoice;
    } else if (widget.systemKey == deckKey) {
      return isValueToProperty ? 'Card:' : paoChoice;
    }
    return isValueToProperty ? 'Digit' : 'Object:';
  }

  Widget getTitle() {
    if (widget.systemKey == paoKey) {
      switch (paoChoice) {
        case 'person':
          return Center(
            child: Text(
              isValueToProperty ? widget.entry.digits : widget.entry.person,
              style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
              textAlign: TextAlign.center,
            ),
          );
        case 'action':
          return Center(
            child: Text(
              isValueToProperty ? widget.entry.digits : widget.entry.action,
              style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
              textAlign: TextAlign.center,
            ),
          );
        case 'object':
          return Center(
            child: Text(
              isValueToProperty ? widget.entry.digits : widget.entry.object,
              style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
              textAlign: TextAlign.center,
            ),
          );
      }
    } else if (widget.systemKey == deckKey) {
      switch (paoChoice) {
        case 'person':
          return isValueToProperty
              ? Center(child: getDeckCard(widget.entry.digitSuit, 'small'))
              : Center(
                  child: Text(
                    isValueToProperty
                        ? widget.entry.digits
                        : widget.entry.person,
                    style: TextStyle(
                        fontSize: 40, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                );
        case 'action':
          return isValueToProperty
              ? Center(child: getDeckCard(widget.entry.digitSuit, 'small'))
              : Center(
                  child: Text(
                    isValueToProperty
                        ? widget.entry.digits
                        : widget.entry.action,
                    style: TextStyle(
                        fontSize: 34, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                );
        case 'object':
          return isValueToProperty
              ? Center(child: getDeckCard(widget.entry.digitSuit, 'small'))
              : Center(
                  child: Text(
                    isValueToProperty
                        ? widget.entry.digits
                        : widget.entry.object,
                    style: TextStyle(
                        fontSize: 34, color: backgroundHighlightColor),
                    textAlign: TextAlign.center,
                  ),
                );
      }
    }
    return isValueToProperty
        ? Center(
            child: Text(
              isValueToProperty ? widget.entry.digits : widget.entry.digits,
              style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
              textAlign: TextAlign.center,
            ),
          )
        : Center(
            child: Text(
              isValueToProperty ? widget.entry.digits : widget.entry.object,
              style: TextStyle(fontSize: 50, color: backgroundHighlightColor),
              textAlign: TextAlign.center,
            ),
          );
  }

  Widget getChoice(int index) {
    if (widget.systemKey == paoKey) {
      String text = '';
      switch (paoChoice) {
        case 'person':
          text = widget.shuffledChoices[attempts][index].person;
          break;
        case 'action':
          text = widget.shuffledChoices[attempts][index].action;
          break;
        case 'object':
          text = widget.shuffledChoices[attempts][index].object;
          break;
      }
      return BasicFlatButton(
        color: colorPAOStandard,
        text: isValueToProperty
            ? text
            : widget.shuffledChoices[attempts][index].digits,
        fontSize: 28,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        onPressed: () => checkResult(index),
        useConstrained: true,
      );
    } else if (widget.systemKey == deckKey) {
      String text = '';
      switch (paoChoice) {
        case 'person':
          text = widget.shuffledChoices[attempts][index].person;
          break;
        case 'action':
          text = widget.shuffledChoices[attempts][index].action;
          break;
        case 'object':
          text = widget.shuffledChoices[attempts][index].object;
          break;
      }
      return isValueToProperty
          ? BasicFlatButton(
              color: colorDeckStandard,
              text: text,
              fontSize: 30,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              onPressed: () => checkResult(index),
              useConstrained: true,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorDeckStandard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(),
                ),
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                checkResult(index);
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: getDeckCard(
                    widget.shuffledChoices[attempts][index].digitSuit, 'small'),
              ),
            );
    } else if (widget.systemKey == tripleDigitKey) {
      String text = '';
      switch (paoChoice) {
        case 'person':
          text = widget.shuffledChoices[attempts][index].person;
          break;
        case 'action':
          text = widget.shuffledChoices[attempts][index].action;
          break;
        case 'object':
          text = widget.shuffledChoices[attempts][index].object;
          break;
      }
      return BasicFlatButton(
        color: colorTripleDigitStandard,
        text: isValueToProperty
            ? text
            : widget.shuffledChoices[attempts][index].digits,
        fontSize: 30,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        onPressed: () => checkResult(index),
      );
    }
    return BasicFlatButton(
      color: colorSingleDigitStandard,
      text: isValueToProperty
          ? widget.shuffledChoices[attempts][index].object
          : widget.shuffledChoices[attempts][index].digits,
      fontSize: 30,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      onPressed: () => checkResult(index),
    );
  }

  void checkResult(int index) {
    if (widget.shuffledChoices[attempts][index].index == widget.entry.index) {
      showSnackBar(
          context: context,
          snackBarText: 'Correct!',
          backgroundColor: colorCorrect,
          durationSeconds: 1);
      widget.callback(true);
      setState(() {});
    } else {
      String value = '';
      String property = '';
      switch (widget.systemKey) {
        case singleDigitKey:
          value = widget.entry.digits;
          property = widget.entry.object;
          break;
        case paoKey:
          value = widget.entry.digits;
          switch (paoChoice) {
            case 'person':
              property = widget.entry.person;
              break;
            case 'action':
              property = widget.entry.action;
              break;
            case 'object':
              property = widget.entry.object;
              break;
          }
          break;
        case deckKey:
          value = widget.entry.digitSuit;
          switch (paoChoice) {
            case 'person':
              property = widget.entry.person;
              break;
            case 'action':
              property = widget.entry.action;
              break;
            case 'object':
              property = widget.entry.object;
              break;
          }
          break;
      }
      showSnackBar(
          context: context,
          snackBarText: 'Incorrect!   $value = $property',
          backgroundColor: colorIncorrect,
          durationSeconds: 2);
      widget.callback(false);
      setState(() {});
    }
    if (debugModeEnabled && attempts >= 2) {
      showSnackBar(
          context: context,
          snackBarText:
              'Debug: Congratulations, you aced it! Next up is a timed test!',
          backgroundColor: widget.color,
          durationSeconds: 3);
      widget.nextActivityCallback();
      Navigator.pop(context);
    }
    if (widget.isLastCard) {
      int score = 0;
      widget.results.forEach((v) {
        if (v) {
          score += 1;
        }
      });
      if (score == widget.results.length) {
        showSnackBar(
            context: context,
            snackBarText:
                'Congratulations, you aced it! Next up is a timed test!',
            backgroundColor: widget.color,
            durationSeconds: 3);
        widget.nextActivityCallback();
        Navigator.pop(context);
      } else {
        showSnackBar(
            context: context,
            snackBarText:
                'Try again! You got this. Score: $score/${widget.results.length}',
            backgroundColor: colorIncorrect,
            durationSeconds: 3);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Text(
                  getTitleType(),
                  style:
                      TextStyle(fontSize: 26, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              getTitle(),
              SizedBox(
                height: 40,
              ),
              getChoice(0),
              SizedBox(
                height: 20,
              ),
              getChoice(1),
              SizedBox(
                height: 20,
              ),
              getChoice(2),
              SizedBox(
                height: 20,
              ),
              getChoice(3),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
