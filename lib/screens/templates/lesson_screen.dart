import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class LessonScreen extends StatefulWidget {
  final String title;
  final List headers;
  final List information;
  final Function completeLesson;
  final Color colorStandard;
  final Color colorDarker;

  LessonScreen({this.title, this.headers, this.information, this.completeLesson, this.colorStandard, this.colorDarker});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  int slideIndex = 0;
  final IndexController indexController = IndexController();
  var prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(
        seconds: 5,
      ),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.colorDarker,
      ),
      body: TransformerPageView(
          pageSnapping: true,
          onPageChanged: (index) {
            setState(() {
              slideIndex = index;
            });
          },
          loop: false,
          controller: indexController,
          transformer: PageTransformerBuilder(
              builder: (Widget child, TransformInfo info) {
            return Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: backgroundColor),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ParallaxContainer(
                            child: info.index == 0
                                ? StaggerAnimation(
                                    widget: widget.headers[info.index],
                                    controller: animationController,
                                    begin: 0,
                                    end: 1,
                                  )
                                : widget.headers[info.index],
                            position: info.position,
                            translationFactor: 200,
                          ),
                          info.index == 0
                              ? SizedBox(
                                  height: 10,
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          ParallaxContainer(
                            child: info.index == 0
                                ? StaggerAnimation(
                                    widget: widget.information[info.index],
                                    controller: animationController,
                                    begin: 0.2,
                                    end: 1,
                                  )
                                : widget.information[info.index],
                            position: info.position,
                            translationFactor: 100,
                          ),
                          info.index != widget.headers.length - 1
                              ? Container()
                              : SizedBox(
                                  height: 10,
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          info.index != widget.headers.length - 1
                              ? Container()
                              : ParallaxContainer(
                                  child: BasicFlatButton(
                                    text: 'Onward!',
                                    color: widget.colorStandard,
                                    splashColor: widget.colorDarker,
                                    onPressed: widget.completeLesson,
                                    padding: 10,
                                    fontSize: 28,
                                  ),
                                  position: info.position,
                                  translationFactor: 300,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: getSlideCircles(
                        widget.information.length, slideIndex, widget.colorDarker),
                  ),
                  alignment: Alignment.bottomCenter,
                )
              ],
            );
          }),
          itemCount: widget.headers.length),
    );
  }
}
