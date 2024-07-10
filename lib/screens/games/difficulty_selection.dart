import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

class DifficultySelection extends StatefulWidget {
  final Function function;
  final Color color;
  final String text;
  final String completeKey;
  final String availableKey;

  DifficultySelection({
    required this.text,
    required this.color,
    required this.function,
    required this.completeKey,
    required this.availableKey,
  });

  @override
  _DifficultySelectionState createState() => _DifficultySelectionState();
}

class _DifficultySelectionState extends State<DifficultySelection> {
  PrefsUpdater prefs = PrefsUpdater();
  bool isComplete = false;
  bool isAvailable = false;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() {
    if (prefs.getBool(widget.completeKey)) {
      setState(() {
        isComplete = true;
      });
    }
    if (prefs.getBool(widget.availableKey)) {
      setState(() {
        isAvailable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        isComplete
            ? Container(
                height: 15,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                ),
                child: Center(
                  child: Text(
                    'COMPLETE',
                    style: TextStyle(fontSize: 8, fontFamily: 'Viga'),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container(),
        Container(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAvailable ? widget.color : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                  width: isComplete ? 3 : 1,
                  color: isComplete ? Colors.amberAccent : Colors.black,
                ),
              ),
            ),
            onPressed: isAvailable
                ? () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    widget.function();
                  }
                : () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: AutoSizeText(
                widget.text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
