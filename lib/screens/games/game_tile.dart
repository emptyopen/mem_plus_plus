import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/components/standard/new_tag.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/screens/games/game_dialog_content.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class GameTile extends StatefulWidget {
  final String game;
  final String title;
  final String subtitle;
  final Icon icon;
  final bool firstView;
  final String firstViewKey;

  GameTile(
      {required this.game,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.firstView,
      required this.firstViewKey});

  @override
  State<GameTile> createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  PrefsUpdater prefs = PrefsUpdater();

  checkFirstView() {
    if (prefs.getBool(widget.firstViewKey) == true) {
      prefs.setBool(widget.firstViewKey, false);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        checkFirstView();
        HapticFeedback.lightImpact();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GameDialogContent(
              game: widget.game,
            );
          },
        );
      },
      child: Stack(
        children: <Widget>[
          Card(
            color: colorGamesLighter,
            child: ListTile(
              leading: widget.icon,
              title: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Text(widget.subtitle),
            ),
          ),
          this.widget.firstView ? NewTag(left: 10, top: 10) : Container(),
        ],
      ),
    );
  }
}
