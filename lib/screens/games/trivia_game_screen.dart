import 'package:flutter/material.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

import 'package:mem_plus_plus/services/services.dart';

class TriviaGameScreen extends StatefulWidget {
  final String
      triviaType; // US presidents (45), periodic table of elements (118), countries, capitals, flags? (195)
  final int difficulty; // easy, hard, ancient god
  final scaffoldKey;

  TriviaGameScreen(
      {Key? key,
      required this.triviaType,
      required this.difficulty,
      this.scaffoldKey})
      : super(key: key);

  @override
  _TriviaGameScreenState createState() => _TriviaGameScreenState();
}

class _TriviaGameScreenState extends State<TriviaGameScreen>
    with SingleTickerProviderStateMixin {
  String difficultyName = '';
  bool started = false;
  bool complete = false;
  List columns = [];
  String question1 = '';
  String question2 = '';
  String question3 = '';
  String question4 = '';
  String question5 = '';
  String answer1 = '';
  String answer2 = '';
  String answer3 = '';
  String answer4 = '';
  String answer5 = '';
  var guess1 = TextEditingController();
  var guess2 = TextEditingController();
  var guess3 = TextEditingController();
  var guess4 = TextEditingController();
  var guess5 = TextEditingController();
  late AnimationController animationController;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    initializeQA();
  }

  @override
  void dispose() {
    guess1.dispose();
    guess2.dispose();
    guess3.dispose();
    guess4.dispose();
    guess5.dispose();
    animationController.dispose();
    super.dispose();
  }

  initializeQA() {
    if (widget.triviaType == 'presidents') {
      prefs.checkFirstTime(context, presidentsTriviaGameFirstHelpKey,
          PresidentsTriviaGameScreenHelp());
    }
    if (widget.triviaType == 'elements') {
      prefs.checkFirstTime(context, elementsTriviaGameFirstHelpKey,
          ElementsTriviaGameScreenHelp());
    }
    if (widget.triviaType == 'countries') {
      prefs.checkFirstTime(context, countriesTriviaGameFirstHelpKey,
          CountriesTriviaGameScreenHelp());
    }

    // initialize questions and answers
    if (widget.triviaType == 'presidents') {
      if (widget.difficulty == 1) {
        // 3 questions, match president to face and what year
      } else if (widget.difficulty == 2) {
        // 4 questions, match president to face and what year
      } else {
        // 5 questions, match president to face and what year
      }
    } else if (widget.triviaType == 'elements') {
      if (widget.difficulty == 1) {
        // 3 questions, abbreviation and atomic number
      } else if (widget.difficulty == 2) {
        // 4 questions, abbreviation, atomic number, weight
      } else {
        // 5 questions, abbreviation, atomic number, weight
      }
    } else {
      // countries
      if (widget.difficulty == 1) {
        // 3 questions, match country to flag
      } else if (widget.difficulty == 2) {
        // 4 questions, match country to flag, write capital for country
      } else {
        // 5 questions, match country to flag, write capital for country
      }
    }
  }

  checkAnswers(BuildContext context) async {
    if (guess1.text.trim() == answer1 &&
        guess2.text.trim() == answer2 &&
        guess3.text.trim() == answer3 &&
        guess4.text.trim() == answer4 &&
        guess5.text.trim() == answer5) {
      if (!prefs.getBool('fade${widget.difficulty}Complete')) {
        showSnackBar(
          context: context,
          snackBarText: 'Congrats! You\'ve beaten $difficultyName difficulty!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
          isSuper: true,
        );
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congrats! You\'re a beast!',
          backgroundColor: colorGamesDarker,
          textColor: Colors.white,
        );
      }
      prefs.setBool("fade${widget.difficulty}Complete", true);
    } else {
      showSnackBar(
        context: context,
        snackBarText: 'Incorrect. Try again sometime!',
        backgroundColor: colorIncorrect,
        textColor: Colors.black,
      );
    }
    Navigator.pop(context);
  }

  Widget getPrep() {
    return Text('start');
  }

  Widget getQuiz() {
    return Text('submit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Fade'),
          backgroundColor: colorGamesDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      if (widget.triviaType == 'presidents') {
                        return PresidentsTriviaGameScreenHelp();
                      }
                      if (widget.triviaType == 'elements') {
                        return ElementsTriviaGameScreenHelp();
                      }
                      return CountriesTriviaGameScreenHelp();
                    },
                  ),
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              started ? Container() : getPrep(),
              started ? getQuiz() : Container(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PresidentsTriviaGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Presidents Trivia',
      information: [
        '    EASY mode: memorize the first 15 presidents, their face, and the first year of their presidency.\n'
            '    HARD mode: memorize the first 25 presidents, their face, and the first year of their presidency.\n'
            '    ANCIENT GOD mode: memorize all presidents, their face, and the first year of their presidency.'
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: presidentsTriviaGameFirstHelpKey,
      callback: () {},
    );
  }
}

class ElementsTriviaGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Elements Trivia',
      information: [
        '    EASY mode: memorize the first 40 elements: their abbreviation, and atomic number.\n'
            '    HARD mode: memorize the first 60 elements: their abbreviation, atomic number, and atomic weight.\n'
            '    ANCIENT GOD mode: memorize all elements: their abbreviation, atomic number, and atomic weight.'
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: elementsTriviaGameFirstHelpKey,
      callback: () {},
    );
  }
}

class CountriesTriviaGameScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Countries Trivia',
      information: [
        '    EASY mode: memorize the biggest 50 countries (by population) and their flags.\n'
            '    HARD mode: memorize the biggest 90 countries, their flags, and their capitals.\n'
            '    ANCIENT GOD mode: memorize all 196 countries, their flags, and their capitals.',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: countriesTriviaGameFirstHelpKey,
      callback: () {},
    );
  }
}
