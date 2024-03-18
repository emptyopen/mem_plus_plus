import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../services/services.dart';

class InfoBox extends StatefulWidget {
  final String text;
  final String infoKey;
  final List<String> dependentInfoKeys;

  InfoBox({
    required this.text,
    required this.infoKey,
    this.dependentInfoKeys = const [],
  });

  @override
  _InfoBoxState createState() => _InfoBoxState();
}

class _InfoBoxState extends State<InfoBox> {
  final prefs = PrefsUpdater();
  bool infoKeyExists = true;

  @override
  initState() {
    super.initState();
    getInfoKey();
  }

  getInfoKey() async {
    infoKeyExists = await prefs.getBool(widget.infoKey) ?? false;
  }

  setInfoKey() async {
    await prefs.setBool(widget.infoKey, true);
    infoKeyExists = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (infoKeyExists) {
      return Container();
    }
    return MirrorAnimation<double>(
        // <-- specify type of animated variable
        tween: Tween(begin: 0, end: 5),
        duration: Duration(
          milliseconds: 500,
        ),
        builder: (context, child, value) {
          // <-- builder function
          return Container(
            padding: EdgeInsets.fromLTRB(
              5,
              value,
              5,
              value,
            ),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setInfoKey();
              },
              child: Stack(
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.fromLTRB(20, 10, 15, 5),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black.withAlpha(210),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '(tap this info to never see again)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  // add arrow
                  Positioned(
                    top: 2,
                    right: 8,
                    child: Icon(
                      MdiIcons.chevronUp,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
