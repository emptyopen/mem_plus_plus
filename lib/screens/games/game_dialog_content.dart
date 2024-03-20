import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/screens/games/difficulty_selection.dart';
import 'package:mem_plus_plus/screens/games/fade_game_screen.dart';
import 'package:mem_plus_plus/screens/games/irrational_game_screen.dart';
import 'package:mem_plus_plus/screens/games/morse_game_screen.dart';
import 'package:mem_plus_plus/services/services.dart';

class GameDialogContent extends StatelessWidget {
  final String game;

  GameDialogContent({required this.game});

  goToScreen(BuildContext context, int difficulty) {
    Navigator.pop(context);
    switch (game) {
      case 'fade':
        slideTransition(
          context,
          FadeGameScreen(
            difficulty: difficulty,
          ),
        );
        break;
      case 'morse':
        slideTransition(
          context,
          MorseGameScreen(
            difficulty: difficulty,
          ),
        );
        break;
      case 'irrational':
        slideTransition(
          context,
          IrrationalGameScreen(
            difficulty: difficulty,
          ),
        );
        break;
    }
  }

  getDifficulties(BuildContext context) {
    switch (game) {
      case 'fade':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DifficultySelection(
              text: 'Easy',
              color: Colors.lightBlue[100]!,
              function: () => goToScreen(context, 0),
              completeKey: 'fade0Complete',
              availableKey: fadeGameAvailableKey,
            ),
            DifficultySelection(
              text: 'Medium',
              color: Colors.lightBlue[200]!,
              function: () => goToScreen(context, 1),
              completeKey: 'fade1Complete',
              availableKey: 'fade0Complete',
            ),
            DifficultySelection(
              text: 'Difficult',
              color: Colors.lightBlue[300]!,
              function: () => goToScreen(context, 2),
              completeKey: 'fade2Complete',
              availableKey: 'fade1Complete',
            ),
            DifficultySelection(
              text: 'Master',
              color: Colors.lightBlue[400]!,
              function: () => goToScreen(context, 3),
              completeKey: 'fade3Complete',
              availableKey: 'fade2Complete',
            ),
            DifficultySelection(
              text: 'Ancient God',
              color: Colors.lightBlue[500]!,
              function: () => goToScreen(context, 4),
              completeKey: 'fade4Complete',
              availableKey: 'fade3Complete',
            ),
          ],
        );
      case 'morse':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DifficultySelection(
              text: 'Easy',
              color: Colors.lightBlue[100]!,
              function: () => goToScreen(context, 0),
              completeKey: 'morse0Complete',
              availableKey: morseGameAvailableKey,
            ),
            DifficultySelection(
              text: 'Medium',
              color: Colors.lightBlue[200]!,
              function: () => goToScreen(context, 1),
              completeKey: 'morse1Complete',
              availableKey: 'morse0Complete',
            ),
            DifficultySelection(
              text: 'Master',
              color: Colors.lightBlue[300]!,
              function: () => goToScreen(context, 2),
              completeKey: 'morse2Complete',
              availableKey: 'morse1Complete',
            ),
            DifficultySelection(
              text: 'Ancient God',
              color: Colors.lightBlue[400]!,
              function: () => goToScreen(context, 3),
              completeKey: 'morse3Complete',
              availableKey: 'morse2Complete',
            ),
          ],
        );
      case 'irrational':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DifficultySelection(
              text: '200 digits of π',
              color: Colors.lightBlue[200]!,
              function: () => goToScreen(context, 0),
              completeKey: 'irrational0Complete',
              availableKey: irrationalGameAvailableKey,
            ),
            DifficultySelection(
              text: '500 digits of π',
              color: Colors.lightBlue[300]!,
              function: () => goToScreen(context, 1),
              completeKey: 'irrational1Complete',
              availableKey: 'irrational0Complete',
            ),
            DifficultySelection(
              text: '1000 digits of π',
              color: Colors.lightBlue[400]!,
              function: () => goToScreen(context, 2),
              completeKey: 'irrational2Complete',
              availableKey: 'irrational1Complete',
            ),
            DifficultySelection(
              text: '200 digits of e',
              color: Colors.lightBlue[200]!,
              function: () => goToScreen(context, 3),
              completeKey: 'irrational3Complete',
              availableKey: irrationalGameAvailableKey,
            ),
            DifficultySelection(
              text: '500 digits of e',
              color: Colors.lightBlue[300]!,
              function: () => goToScreen(context, 4),
              completeKey: 'irrational4Complete',
              availableKey: 'irrational3Complete',
            ),
            DifficultySelection(
              text: '1000 digits of e',
              color: Colors.lightBlue[400]!,
              function: () => goToScreen(context, 5),
              completeKey: 'irrational5Complete',
              availableKey: 'irrational4Complete',
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: backgroundColor,
      child: Container(
        height: 400.0,
        width: 300.0,
        child: getDifficulties(context),
      ),
    );
  }
}
