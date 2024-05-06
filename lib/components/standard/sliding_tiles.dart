import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class SlidingTiles extends StatefulWidget {
  final List<SlidingTileContent> tiles;
  final bool showButtonEverySlide;
  final String buttonText;
  const SlidingTiles(
      {required this.tiles,
      required this.showButtonEverySlide,
      required this.buttonText,
      Key? key})
      : super(key: key);

  @override
  State<SlidingTiles> createState() => _SlidingTilesState();
}

class _SlidingTilesState extends State<SlidingTiles> {
  PrefsUpdater prefs = PrefsUpdater();
  int _currentIndex = 0;

  void goToMainMenu(BuildContext context) async {
    HapticFeedback.lightImpact();
    if (!prefs.getBool(firstTimeAppKey) ||
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
                        style: TextStyle(fontSize: 24),
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
        widget.tiles.length > 1
            ? SlidingTileBubbles(
                currentIndex: _currentIndex,
                numTiles: widget.tiles.length,
              )
            : Container(),
        widget.tiles.length > 1 ? SizedBox(height: 30) : Container(),
        _currentIndex == widget.tiles.length - 1 || widget.showButtonEverySlide
            ? SizedBox(
                height: buttonHeight,
                child: BasicFlatButton(
                  text: widget.buttonText,
                  color: Colors.green[200]!,
                  onPressed: () => goToMainMenu(context),
                  padding: 10,
                  fontSize: 20,
                ))
            : SizedBox(height: buttonHeight),
        SizedBox(height: 15),
      ],
    );
  }
}

class SlidingTileBubbles extends StatelessWidget {
  final int currentIndex;
  final int numTiles;
  const SlidingTileBubbles(
      {required this.currentIndex, required this.numTiles, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = [];
    for (int i = 0; i < numTiles; i++) {
      bubbles.add(Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        width: 10.0,
        height: 10.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: i == currentIndex
              ? Colors.green.withAlpha(140)
              : Colors.grey.withAlpha(100),
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: bubbles,
    );
  }
}
