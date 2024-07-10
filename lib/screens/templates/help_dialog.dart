import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/sliding_tiles.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class HelpDialog extends StatefulWidget {
  final String title;
  final List<String> information;
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final Function callback;

  HelpDialog({
    this.title = '',
    required this.information,
    required this.buttonColor,
    required this.buttonSplashColor,
    required this.firstHelpKey,
    required this.callback,
  });

  @override
  _HelpDialogState createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  int slideIndex = 0;
  List<Widget> informationList = [];
  bool firstHelp = true;
  PrefsUpdater prefs = PrefsUpdater();
  List<SlidingTileContent> tiles = [];

  @override
  void initState() {
    super.initState();
    checkFirstHelp();
    widget.information.forEach((String info) {
      tiles.add(SlidingTileContent(
          header: widget.title,
          content: [Text(info, style: TextStyle(fontSize: 20))]));
    });
  }

  checkFirstHelp() {
    firstHelp = !prefs.getBool(widget.firstHelpKey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  width: screenWidth * 0.90,
                  height: screenHeight * 0.75,
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: SlidingTiles(
                    tiles: tiles,
                    showButtonEverySlide: (firstHelp &&
                            slideIndex == widget.information.length - 1) ||
                        debugModeEnabled ||
                        !firstHelp,
                    buttonText: 'Done',
                    callback: () {
                      widget.callback();
                      // mark help as completed
                      prefs.setBool(widget.firstHelpKey, true);
                      Navigator.pop(context);
                    },
                    helpStyle: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
