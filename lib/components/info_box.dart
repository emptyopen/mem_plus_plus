import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
// import 'package:simple_animations/simple_animations.dart';

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
  PrefsUpdater prefs = PrefsUpdater();
  bool infoKeyExists = true;

  @override
  initState() {
    super.initState();
    getInfoKey();
  }

  getInfoKey() async {
    infoKeyExists = prefs.getBool(widget.infoKey);
  }

  setInfoKey() async {
    prefs.setBool(widget.infoKey, true);
    infoKeyExists = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (infoKeyExists) {
      return Container();
    }
    return Text('mirror animation was here');
    // return MirrorAnimation<double>(
    //     // <-- specify type of animated variable
    //     tween: Tween(begin: 0, end: 5),
    //     duration: Duration(
    //       milliseconds: 500,
    //     ),
    //     builder: (context, child, value) {
    //       // <-- builder function
    //       return Container(
    //         padding: EdgeInsets.fromLTRB(
    //           5,
    //           value,
    //           5,
    //           value,
    //         ),
    //         child: GestureDetector(
    //           onTap: () {
    //             HapticFeedback.lightImpact();
    //             setInfoKey();
    //           },
    //           child: Stack(
    //             children: [
    //               Container(
    //                 height: 60,
    //                 padding: EdgeInsets.fromLTRB(20, 10, 15, 5),
    //                 decoration: BoxDecoration(
    //                   border: Border.all(),
    //                   borderRadius: BorderRadius.circular(5),
    //                   color: Colors.black.withAlpha(210),
    //                 ),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     Text(
    //                       widget.text,
    //                       style: TextStyle(
    //                         color: Colors.white,
    //                         fontSize: 14,
    //                       ),
    //                     ),
    //                     Text(
    //                       '(tap this info to never see again)',
    //                       style: TextStyle(
    //                         color: Colors.grey,
    //                         fontSize: 12,
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               // add arrow
    //               Positioned(
    //                 top: 2,
    //                 right: 8,
    //                 child: Icon(
    //                   MdiIcons.chevronUp,
    //                   color: Colors.white,
    //                   size: 16,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
