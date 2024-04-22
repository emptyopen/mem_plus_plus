import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class HelpDialog extends StatefulWidget {
  final String title;
  final List<String> information;
  final Color buttonColor;
  final Color buttonSplashColor;
  final String firstHelpKey;
  final Function? callback;

  HelpDialog({
    this.title = '',
    required this.information,
    required this.buttonColor,
    required this.buttonSplashColor,
    required this.firstHelpKey,
    this.callback,
  });

  @override
  _HelpDialogState createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  int slideIndex = 0;
  List<Widget> informationList = [];
  bool firstHelp = true;
  PrefsUpdater prefs = PrefsUpdater();

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
    firstHelp = prefs.getBool(widget.firstHelpKey) == null;
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
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.75,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    // child: transformerPageView,
                    child: Text('transformer was here'),
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
                          callback: widget.callback != null
                              ? widget.callback!
                              : () {},
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
