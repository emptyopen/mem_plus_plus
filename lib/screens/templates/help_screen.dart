import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'package:mem_plus_plus/services/services.dart';

class HelpScreen extends StatefulWidget {
  final String title;
  final List<String> information;
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final Function? callback;

  HelpScreen({
    this.title = '',
    required this.information,
    required this.buttonColor,
    required this.buttonSplashColor,
    required this.firstHelpKey,
    this.callback,
  });

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int slideIndex = 0;
  final IndexController indexController = IndexController();
  List<Widget> informationList = [];
  bool firstHelp = true;

  @override
  void initState() {
    super.initState();

    // check if this is first time opening the screen
    checkFirstHelp();

    if (widget.information.length > 1) {
      informationList.add(Column(
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.information[0],
            style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '(Swipe for more information)',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ));
      widget.information.sublist(1).forEach((f) {
        informationList.add(Text(
          f,
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
          textAlign: TextAlign.left,
        ));
      });
    } else {
      informationList.add(Column(
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 28, color: backgroundHighlightColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.information[0],
            style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
            textAlign: TextAlign.left,
          ),
        ],
      ));
    }
  }

  checkFirstHelp() async {
    PrefsUpdater prefs = PrefsUpdater();
    firstHelp = prefs.getBool(widget.firstHelpKey) == null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TransformerPageView transformerPageView = TransformerPageView(
      pageSnapping: true,
      onPageChanged: (index) {
        setState(() {
          slideIndex = index;
        });
      },
      loop: false,
      controller: indexController,
      transformer:
          PageTransformerBuilder(builder: (Widget child, TransformInfo info) {
        return Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ParallaxContainer(
                          child: informationList[info.index],
                          position: info.position,
                          translationFactor: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              widget.information.length > 1
                  ? Padding(
                      padding: const EdgeInsets.all(13),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: getSlideCircles(widget.information.length,
                            slideIndex, widget.buttonColor),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      }),
      itemCount: widget.information.length,
    );

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
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.75,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: transformerPageView,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  (firstHelp && slideIndex == widget.information.length - 1) ||
                          debugModeEnabled ||
                          !firstHelp
                      ? HelpOKButton(
                          buttonColor: widget.buttonColor,
                          buttonSplashColor: widget.buttonSplashColor,
                          firstHelpKey: widget.firstHelpKey,
                          callback: widget.callback,
                        )
                      : SizedBox(
                          height: 50,
                        ),
                ],
              ),
            ),
          ],
        ));
  }
}

class HelpOKButton extends StatelessWidget {
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final PrefsUpdater prefs = PrefsUpdater();
  final Function callback;

  HelpOKButton(
      {required this.buttonColor,
      required this.buttonSplashColor,
      required this.firstHelpKey,
      required this.callback});

  updateFirstHelp() {
    prefs.setBool(firstHelpKey, false);
  }

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        callback();
        updateFirstHelp();
        Navigator.pop(context);
      },
      text: 'OK',
      color: buttonColor,
      fontSize: 20,
      padding: 10,
    );
  }
}
