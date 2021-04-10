import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/screens/games/fade_game_screen.dart';
import 'package:mem_plus_plus/screens/games/morse_game_screen.dart';
import 'package:mem_plus_plus/screens/games/irrational_game_screen.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/components/standard.dart';

import '../../constants/keys.dart';
import 'fade_game_screen.dart';

class GamesScreen extends StatefulWidget {
  final Function callback;

  GamesScreen({Key key, this.callback}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Widget> availableGameTiles = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getGames();
  }

  void getGames() async {
    prefs.checkFirstTime(context, gamesFirstHelpKey, GamesScreenHelp());
    availableGameTiles = [];
    availableGameTiles.add(SizedBox(
      height: 10,
    ));
    if (await prefs.getBool(fadeGameAvailableKey) != null) {
      availableGameTiles.add(
        GameTile(
          game: 'fade',
          title: 'FADE',
          subtitle: 'Catch the code before it fades!',
          scaffoldKey: _scaffoldKey,
          icon: Icon(
            MdiIcons.shoePrint,
            size: 40,
          ),
          firstViewKey: fadeGameFirstViewKey,
          firstView: await prefs.getBool(fadeGameFirstViewKey) == true,
        ),
      );
    }
    if (await prefs.getBool(morseGameAvailableKey) != null) {
      availableGameTiles.add(
        GameTile(
          game: 'morse',
          title: 'END OF THE WORLD',
          subtitle: 'Solve the Morse code puzzle before it\'s too late!',
          scaffoldKey: _scaffoldKey,
          icon: Icon(
            MdiIcons.accessPoint,
            size: 40,
          ),
          firstViewKey: morseGameFirstViewKey,
          firstView: await prefs.getBool(morseGameFirstViewKey) == true,
        ),
      );
    }
    if (await prefs.getBool(irrationalGameAvailableKey) != null) {
      availableGameTiles.add(
        GameTile(
          game: 'irrational',
          title: 'IRRATIONAL!',
          subtitle: 'Test the outer limits of your memory capacity!',
          scaffoldKey: _scaffoldKey,
          icon: Icon(
            MdiIcons.pi,
            size: 40,
          ),
          firstViewKey: irrationalGameFirstViewKey,
          firstView: await prefs.getBool(irrationalGameFirstViewKey) == true,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Mini games'),
          backgroundColor: colorGamesDarker,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return GamesScreenHelp();
                    }));
              },
            ),
          ]),
      body: Column(
        children: availableGameTiles,
      ),
    );
  }
}

class GamesScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Games',
      information: [
        '    Welcome, welcome. Are you ready to push yourself to the limit?\n\n    Here you can play games that you will '
            'unlock as you progress through the rest of the app. Simply pick a game and choose '
            'your difficulty.',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: gamesFirstHelpKey,
    );
  }
}

class GameTile extends StatelessWidget {
  final String game;
  final String title;
  final String subtitle;
  final Icon icon;
  final GlobalKey scaffoldKey;
  final bool firstView;
  final String firstViewKey;

  GameTile(
      {this.game,
      this.title,
      this.subtitle,
      this.icon,
      this.scaffoldKey,
      this.firstView,
      this.firstViewKey});

  checkFirstView() async {
    var prefs = PrefsUpdater();
    if (await prefs.getBool(firstViewKey) == true) {
      await prefs.setBool(firstViewKey, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        checkFirstView();
        HapticFeedback.lightImpact();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialogContent(
              scaffoldKey: scaffoldKey,
              game: game,
            );
          },
        );
      },
      child: Stack(
        children: <Widget>[
          Card(
            color: colorGamesLighter,
            child: ListTile(
              leading: icon,
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              subtitle: Text(subtitle),
            ),
          ),
          this.firstView ? NewTag(left: 10, top: 10) : Container(),
        ],
      ),
    );
  }
}

class MyDialogContent extends StatelessWidget {
  final GlobalKey scaffoldKey;
  final String game;

  MyDialogContent({this.scaffoldKey, this.game});

  goToScreen(BuildContext context, int difficulty) {
    Navigator.pop(context);
    switch (game) {
      case 'fade':
        slideTransition(
          context,
          FadeGameScreen(
            difficulty: difficulty,
            scaffoldKey: scaffoldKey,
          ),
        );
        break;
      case 'morse':
        slideTransition(
          context,
          MorseGameScreen(
            difficulty: difficulty,
            scaffoldKey: scaffoldKey,
          ),
        );
        break;
      case 'irrational':
        slideTransition(
          context,
          IrrationalGameScreen(
            difficulty: difficulty,
            scaffoldKey: scaffoldKey,
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
              color: Colors.lightBlue[100],
              function: () => goToScreen(context, 0),
              completeKey: 'fade0Complete',
              availableKey: fadeGameAvailableKey,
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Medium',
              color: Colors.lightBlue[200],
              function: () => goToScreen(context, 1),
              completeKey: 'fade1Complete',
              availableKey: 'fade0Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Difficult',
              color: Colors.lightBlue[300],
              function: () => goToScreen(context, 2),
              completeKey: 'fade2Complete',
              availableKey: 'fade1Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Master',
              color: Colors.lightBlue[400],
              function: () => goToScreen(context, 3),
              completeKey: 'fade3Complete',
              availableKey: 'fade2Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Ancient God',
              color: Colors.lightBlue[500],
              function: () => goToScreen(context, 4),
              completeKey: 'fade4Complete',
              availableKey: 'fade3Complete',
              globalKey: scaffoldKey,
            ),
          ],
        );
        break;
      case 'morse':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DifficultySelection(
              text: 'Easy',
              color: Colors.lightBlue[100],
              function: () => goToScreen(context, 0),
              completeKey: 'morse0Complete',
              availableKey: morseGameAvailableKey,
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Medium',
              color: Colors.lightBlue[200],
              function: () => goToScreen(context, 1),
              completeKey: 'morse1Complete',
              availableKey: 'morse0Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Master',
              color: Colors.lightBlue[300],
              function: () => goToScreen(context, 2),
              completeKey: 'morse2Complete',
              availableKey: 'morse1Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: 'Ancient God',
              color: Colors.lightBlue[400],
              function: () => goToScreen(context, 3),
              completeKey: 'morse3Complete',
              availableKey: 'morse2Complete',
              globalKey: scaffoldKey,
            ),
          ],
        );
        break;
      case 'irrational':
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DifficultySelection(
              text: '200 digits of π',
              color: Colors.lightBlue[200],
              function: () => goToScreen(context, 0),
              completeKey: 'irrational0Complete',
              availableKey: irrationalGameAvailableKey,
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: '500 digits of π',
              color: Colors.lightBlue[300],
              function: () => goToScreen(context, 1),
              completeKey: 'irrational1Complete',
              availableKey: 'irrational0Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: '1000 digits of π',
              color: Colors.lightBlue[400],
              function: () => goToScreen(context, 2),
              completeKey: 'irrational2Complete',
              availableKey: 'irrational1Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: '200 digits of e',
              color: Colors.lightBlue[200],
              function: () => goToScreen(context, 3),
              completeKey: 'irrational3Complete',
              availableKey: irrationalGameAvailableKey,
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: '500 digits of e',
              color: Colors.lightBlue[300],
              function: () => goToScreen(context, 4),
              completeKey: 'irrational4Complete',
              availableKey: 'irrational3Complete',
              globalKey: scaffoldKey,
            ),
            DifficultySelection(
              text: '1000 digits of e',
              color: Colors.lightBlue[400],
              function: () => goToScreen(context, 5),
              completeKey: 'irrational5Complete',
              availableKey: 'irrational4Complete',
              globalKey: scaffoldKey,
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

class DifficultySelection extends StatefulWidget {
  final Function function;
  final Color color;
  final String text;
  final String completeKey;
  final String availableKey;
  final GlobalKey<ScaffoldState> globalKey;

  DifficultySelection(
      {this.text,
      this.color,
      this.function,
      this.completeKey,
      this.availableKey,
      this.globalKey});

  @override
  _DifficultySelectionState createState() => _DifficultySelectionState();
}

class _DifficultySelectionState extends State<DifficultySelection> {
  var prefs = PrefsUpdater();
  bool isComplete = false;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    if (await prefs.getBool(widget.completeKey) != null) {
      setState(() {
        isComplete = true;
      });
    }
    if (await prefs.getBool(widget.availableKey) != null) {
      setState(() {
        isAvailable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isComplete
            ? Container(
                height: 15,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    'COMPLETE',
                    style: TextStyle(fontSize: 8, fontFamily: 'Viga'),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container(),
        Container(
          height: 40,
          child: FlatButton(
            color: widget.color,
            highlightColor: Colors.transparent,
            onPressed: isAvailable
                ? () {
                    HapticFeedback.lightImpact();
                    widget.globalKey.currentState.hideCurrentSnackBar();
                    widget.function();
                  }
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                width: isComplete ? 3 : 1,
                color: isComplete ? Colors.amberAccent : Colors.black,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: AutoSizeText(
                widget.text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
