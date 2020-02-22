import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/services.dart';

class CustomMemoryTestScreen extends StatefulWidget {
  final Function callback;
  final Map customMemory;
  final GlobalKey<ScaffoldState> globalKey;

  CustomMemoryTestScreen(
      {Key key, this.callback, this.customMemory, this.globalKey})
      : super(key: key);

  @override
  _CustomMemoryTestScreenState createState() => _CustomMemoryTestScreenState();
}

class _CustomMemoryTestScreenState extends State<CustomMemoryTestScreen> {
  Map customMemories = {};
  var field1TextController = TextEditingController();
  var field2TextController = TextEditingController();
  var field3TextController = TextEditingController();
  var field4TextController = TextEditingController();
  var field5TextController = TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    print('real answer: ${widget.customMemory}');
  }

  @override
  void dispose() {
    field1TextController.dispose();
    field2TextController.dispose();
    field3TextController.dispose();
    field4TextController.dispose();
    field5TextController.dispose();
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();

    customMemories = await prefs.getSharedPrefs(customMemoriesKey);

    setState(() {});
  }

  checkResult(memory, success) async {
    var prefs = PrefsUpdater();
    if (success) {
      // check if beat the last level
      if (memory['spacedRepetitionLevel'] + 1 ==
          termDurationsMap[memory['spacedRepetitionType']].length) {
        customMemories.remove(memory['title']);
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'You\'ve completed this memory! Congratulations, you\'ve burned ${memory['title']} into your memory!',
          textColor: Colors.white,
          backgroundColor: Colors.black,
          durationSeconds: 7,
          isSuper: true,
        );
        Navigator.pop(context);
      } else {
        memory['spacedRepetitionLevel'] += 1;
        var nextDuration = termDurationsMap[memory['spacedRepetitionType']]
            [memory['spacedRepetitionLevel']];
        memory['nextDatetime'] =
            DateTime.now().add(nextDuration).toIso8601String();
        customMemories[memory['title']] = memory;
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText:
              'Correct! Another test is coming in ${durationToString(nextDuration)}!',
          textColor: Colors.black,
          backgroundColor: colorCorrect,
          durationSeconds: 3,
        );
        notifyDuration(
            nextDuration,
            'Ready to be tested on your \'${memory["title"]}\' memory?',
            'Good luck!',
            homepageKey);
        Navigator.pop(context);
      }
      await prefs.writeSharedPrefs(customMemoriesKey, customMemories);
      widget.callback();
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
      );
      globalKey.currentState.showSnackBar(snackBar);
    }
  }

  bool stringsAreEqual(String string1, String string2) {
    if (string1.toLowerCase().trim() == string2.toLowerCase().trim()) {
      return true;
    } else {
      return false;
    }
  }

  checkAnswer() async {
    HapticFeedback.heavyImpact();
    var memory = widget.customMemory;
    switch (memory['type']) {
      case 'Contact':
        bool success = true;
        if (memory['birthday'] != '' &&
            !stringsAreEqual(datetimeToDateString(field1TextController.text), datetimeToDateString(memory['birthday']))) {
          success = false;
        }
        if (memory['phoneNumber'] != '' &&
            !stringsAreEqual(
                field2TextController.text, memory['phoneNumber'])) {
          success = false;
        }
        if (memory['address'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['address'])) {
          success = false;
        }
        if (memory['other'] != '' &&
            !stringsAreEqual(field4TextController.text, memory['other'])) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'ID/Credit Card':
        bool success = true;
        if (memory['number'] != '' &&
            !stringsAreEqual(field1TextController.text, memory['number'])) {
          success = false;
        }
        if (memory['expiration'] != '' &&
            !stringsAreEqual(datetimeToDateString(field2TextController.text), datetimeToDateString(memory['expiration']))) {
          success = false;
        }
        if (memory['other'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['other'])) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'Other':
        bool success = true;
        if (memory['other1'] != '' &&
            !stringsAreEqual(field1TextController.text, memory['other1'])) {
          success = false;
        }
        if (memory['other2'] != '' &&
            !stringsAreEqual(field2TextController.text, memory['other2'])) {
          success = false;
        }
        if (memory['other3'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['other3'])) {
          success = false;
        }
        checkResult(memory, success);
        break;
    }
  }

  Widget getTest() {
    var memory = widget.customMemory;
    switch (memory['type']) {
      case 'Contact':
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                memory['title'],
                style: TextStyle(fontSize: 30, color: backgroundHighlightColor),
              ),
              SizedBox(
                height: 20,
              ),
              memory['birthday'] == ''
                  ? Container()
                  : PromptPair(
                      title: 'Birthday:',
                      textController: field1TextController,
                      inputType: 'date',
                    ),
              memory['phoneNumber'] == ''
                  ? Container()
                  : PromptPair(
                      title: 'Phone number:',
                      textController: field2TextController,
                    ),
              memory['address'] == ''
                  ? Container()
                  : PromptPair(
                      title: 'Address:',
                      textController: field3TextController,
                    ),
              memory['other'] == ''
                  ? Container()
                  : PromptPair(
                      title: memory['otherField'] + ':',
                      textController: field4TextController,
                    ),
              BasicFlatButton(
                text: 'Submit',
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      case 'ID/Credit Card':
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                memory['title'],
                style: TextStyle(fontSize: 30, color: backgroundHighlightColor),
              ),
              SizedBox(
                height: 20,
              ),
              memory['number'] == ''
                  ? Container()
                  : PromptPair(
                      title: 'Number:',
                      textController: field1TextController,
                    ),
              memory['expiration'] == ''
                  ? Container()
                  : PromptPair(
                      title: 'Expiration:',
                      textController: field2TextController,
                      inputType: 'date',
                    ),
              memory['other'] == ''
                  ? Container()
                  : PromptPair(
                      title: memory['otherField'] + ':',
                      textController: field3TextController,
                    ),
              BasicFlatButton(
                text: 'Submit',
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
      default:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                memory['title'],
                style: TextStyle(fontSize: 30, color: backgroundHighlightColor),
              ),
              SizedBox(
                height: 20,
              ),
              memory['other1'] == ''
                  ? Container()
                  : PromptPair(
                      title: memory['other1Field'] + ':',
                      textController: field1TextController,
                    ),
              memory['other2'] == ''
                  ? Container()
                  : PromptPair(
                      title: memory['other2Field'] + ':',
                      textController: field2TextController,
                    ),
              memory['other3'] == ''
                  ? Container()
                  : PromptPair(
                      title: memory['other3Field'] + ':',
                      textController: field3TextController,
                    ),
              BasicFlatButton(
                text: 'Submit',
                fontSize: 22,
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        key: globalKey,
        appBar: AppBar(
            title: Text(
                'Custom ${widget.customMemory['type']}: ${widget.customMemory['title']}'),
            backgroundColor: Colors.purple[200],
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomMemoryTestScreenHelp();
                      }));
                },
              ),
            ]),
        body: Center(
          child: getTest(),
        ));
  }
}

class PromptPair extends StatefulWidget {
  final String inputType;
  final String title;
  final TextEditingController textController;
  final double containerWidth;

  PromptPair(
      {this.inputType,
      this.title,
      this.textController,
      this.containerWidth = 250});

  @override
  _PromptPairState createState() => _PromptPairState();
}

class _PromptPairState extends State<PromptPair> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.title,
            style: TextStyle(fontSize: 24, color: backgroundHighlightColor)),
        Container(
          width: widget.containerWidth,
          height: 40,
          child: widget.inputType == 'date'
              ? BasicFlatButton(
                  color: backgroundSemiColor,
                  textColor: backgroundHighlightColor,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      print('confirm $date');
                      widget.textController.text = date.toIso8601String();
                      setState(() {});
                    }, currentTime: DateTime.now());
                  },
                  text: widget.textController.text == ''
                      ? 'Pick Date'
                      : datetimeToDateString(widget.textController.text),
                  fontSize: 18,
                  padding: 5,
                )
              : TextField(
                  style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                  controller: widget.textController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor))),
                ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class CustomMemoryTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Custom Memory Manager',
      information: [
        '    This is a custom memory test! Hope you put those scenes somewhere accessible!'
      ],
      buttonColor: Colors.purple[100],
      buttonSplashColor: Colors.purple[300],
      firstHelpKey: customMemoryTestFirstHelpKey,
    );
  }
}
