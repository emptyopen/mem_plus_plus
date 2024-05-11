import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/sliding_tile_content.dart';
import 'package:mem_plus_plus/components/standard/sliding_tiles.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class LessonScreen extends StatefulWidget {
  final String title;
  final List<SlidingTileContent> tiles;
  final Function completeLesson;
  final Color colorStandard;
  final Color colorDarker;

  LessonScreen({
    required this.title,
    required this.tiles,
    required this.completeLesson,
    required this.colorStandard,
    required this.colorDarker,
  });

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.colorDarker,
        automaticallyImplyLeading: false,
      ),
      body: SlidingTiles(
        tiles: widget.tiles,
        showButtonEverySlide: true,
        buttonText: 'Done',
        callback: widget.completeLesson,
      ),
    );
  }
}
