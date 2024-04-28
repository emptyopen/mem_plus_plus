import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class SlidingTiles extends StatefulWidget {
  final List<SlidingTileContent> tiles;
  final bool showButtonEverySlide;
  const SlidingTiles(
      {required this.tiles, required this.showButtonEverySlide, Key? key})
      : super(key: key);

  @override
  State<SlidingTiles> createState() => _SlidingTilesState();
}

class _SlidingTilesState extends State<SlidingTiles> {
  PrefsUpdater prefs = PrefsUpdater();
  int _currentIndex = 0;

  void goToMainMenu(BuildContext context) async {
    HapticFeedback.lightImpact();
    if (prefs.getBool(firstTimeAppKey) == null ||
        prefs.getBool(firstTimeAppKey) == true) {
      prefs.setBool(firstTimeAppKey, false);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double buttonHeight = 50;
    return Column(
      children: [
        Flexible(
          child: PageView.builder(
            itemCount: widget.tiles.length,
            controller: PageController(
              viewportFraction: 1,
              initialPage: _currentIndex,
            ),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.tiles[index].header,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28.0),
                      ),
                      SizedBox(height: 30),
                      Column(
                        children: widget.tiles[index].content,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _currentIndex == widget.tiles.length - 1 || widget.showButtonEverySlide
            ? SizedBox(
                height: buttonHeight,
                child: BasicFlatButton(
                  text: 'Main Menu',
                  color: Colors.green[200]!,
                  onPressed: () => goToMainMenu(context),
                  padding: 10,
                  fontSize: 15,
                ))
            : SizedBox(height: buttonHeight),
        SizedBox(height: 25),
      ],
    );
  }
}
