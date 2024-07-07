import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/screens/games/game_tile.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class GamesScreen extends StatefulWidget {
  final Function callback;

  GamesScreen({Key? key, required this.callback}) : super(key: key);

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Widget> availableGameTiles = [];
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    getGames();
  }

  void getGames() async {
    prefs.checkFirstTime(
        context, gamesFirstHelpKey, GamesScreenHelp(callback: widget.callback));
    availableGameTiles = [];
    availableGameTiles.add(SizedBox(
      height: 10,
    ));
    if (prefs.getBool(fadeGameAvailableKey)) {
      availableGameTiles.add(
        GameTile(
          game: 'fade',
          title: 'FADE',
          subtitle: 'Catch the code before it fades!',
          icon: Icon(
            MdiIcons.shoePrint,
            size: 40,
          ),
          firstViewKey: fadeGameFirstViewKey,
          firstView: prefs.getBool(fadeGameFirstViewKey) == true,
        ),
      );
    }
    if (prefs.getBool(morseGameAvailableKey)) {
      availableGameTiles.add(
        GameTile(
          game: 'morse',
          title: 'END OF THE WORLD',
          subtitle: 'Solve the Morse code puzzle before it\'s too late!',
          icon: Icon(
            MdiIcons.accessPoint,
            size: 40,
          ),
          firstViewKey: morseGameFirstViewKey,
          firstView: prefs.getBool(morseGameFirstViewKey),
        ),
      );
    }
    if (prefs.getBool(irrationalGameAvailableKey)) {
      availableGameTiles.add(
        GameTile(
          game: 'irrational',
          title: 'IRRATIONAL!',
          subtitle: 'Test the upper bounds of your memory capacity!',
          icon: Icon(
            MdiIcons.pi,
            size: 40,
          ),
          firstViewKey: irrationalGameFirstViewKey,
          firstView: prefs.getBool(irrationalGameFirstViewKey),
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Mini games', style: TextStyle(fontSize: 18)),
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
                      return GamesScreenHelp(callback: widget.callback);
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
  final Function callback;
  GamesScreenHelp({Key? key, required this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Games',
      information: [
        '    Welcome, welcome. Are you ready to push yourself to the limit?\n\n    Here you can play games that you will '
            'unlock as you progress through the rest of the app. Simply pick a game and choose '
            'your difficulty.',
      ],
      buttonColor: colorGamesStandard,
      buttonSplashColor: colorGamesDarker,
      firstHelpKey: gamesFirstHelpKey,
      callback: callback,
    );
  }
}
