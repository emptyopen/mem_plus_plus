import 'package:flutter/material.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';

class HelpScreen extends StatefulWidget {
  final String title;
  final List<String> information;
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;

  HelpScreen(
      {this.title = '',
      this.information,
      this.buttonColor,
      this.buttonSplashColor,
      this.firstHelpKey});

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
          Icon(Icons.arrow_forward),
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
      informationList.add(Text(
        widget.information[0],
        style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        textAlign: TextAlign.left,
      ));
    }
  }

  checkFirstHelp() async {
    var prefs = PrefsUpdater();
    firstHelp = await prefs.getBool(widget.firstHelpKey) == null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
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
                        slideIndex == 0
                            ? Column(
                                children: <Widget>[
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: backgroundHighlightColor
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : Container(),
                        ParallaxContainer(
                          child: informationList[info.index],
                          position: info.position,
                          translationFactor: 100,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Text('${info.index + 1}/${widget.information.length}', style: TextStyle(color: backgroundHighlightColor),),
                right: 23,
                bottom: 17,
              ),
            ],
          );
        }),
        itemCount: widget.information.length);

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
                      height: 400,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: transformerPageView),
                  SizedBox(
                    height: 15,
                  ),
                  firstHelp &&
                          slideIndex == widget.information.length - 1
                      ? HelpOKButton(
                          buttonColor: widget.buttonColor,
                          buttonSplashColor: widget.buttonSplashColor,
                          firstHelpKey: widget.firstHelpKey,
                        )
                      : Container(),
                  firstHelp &&
                          slideIndex != widget.information.length - 1
                      ? SizedBox(height: 48,) : Container(),
                  firstHelp
                      ? Container()
                      : HelpOKButton(
                          buttonColor: widget.buttonColor,
                          buttonSplashColor: widget.buttonSplashColor,
                          firstHelpKey: widget.firstHelpKey,
                        )
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
  final prefs = PrefsUpdater();

  HelpOKButton({this.buttonColor, this.buttonSplashColor, this.firstHelpKey});

  updateFirstHelp() async {
    await prefs.setBool(firstHelpKey, false);
  }

  @override
  Widget build(BuildContext context) {
    return BasicFlatButton(
      onPressed: () {
        updateFirstHelp();
        Navigator.pop(context);
      },
      text: 'OK',
      color: buttonColor,
      splashColor: buttonSplashColor,
      fontSize: 20,
      padding: 10,
    );
  }
}
