import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/services.dart';
import 'package:password/password.dart';

class CustomMemoryTestScreen extends StatefulWidget {
  final Function callback;
  final Map customMemory;
  final GlobalKey<ScaffoldState> globalKey;

  CustomMemoryTestScreen(
      {Key? key,
      required this.callback,
      required this.customMemory,
      required this.globalKey})
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
    PrefsUpdater prefs = PrefsUpdater();

    customMemories = prefs.getSharedPrefs(customMemoriesKey) as Map;

    setState(() {});
  }

  checkResult(memory, success) async {
    PrefsUpdater prefs = PrefsUpdater();
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
      prefs.writeSharedPrefs(customMemoriesKey, customMemories);
      widget.callback();
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect. Try again!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'CabinSketch',
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: colorIncorrect,
      );
      globalKey.currentState.showSnackBar(snackBar);
    }
  }

  bool stringsAreEqual(String string1, String string2, bool isEncrypted) {
    if (isEncrypted) {
      string1 = Password.hash(string1, PBKDF2());
    }
    if (string1.toLowerCase().trim() == string2.toLowerCase().trim()) {
      return true;
    } else {
      return false;
    }
  }

  checkAnswer() async {
    HapticFeedback.lightImpact();
    var memory = widget.customMemory;
    switch (memory['type']) {
      case 'Contact':
        bool success = true;
        if (memory['birthday'] != '' &&
            !stringsAreEqual(
                datetimeToDateString(field1TextController.text),
                datetimeToDateString(memory['birthday']),
                memory['birthdayEncrypt'])) {
          success = false;
        }
        if (memory['phoneNumber'] != '' &&
            !stringsAreEqual(field2TextController.text, memory['phoneNumber'],
                memory['phoneNumberEncrypt'])) {
          success = false;
        }
        if (memory['address'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['address'],
                memory['addressEncrypt'])) {
          success = false;
        }
        if (memory['other'] != '' &&
            !stringsAreEqual(field4TextController.text, memory['other'],
                memory['otherEncrypt'])) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'ID/Credit Card':
        bool success = true;
        if (memory['number'] != '' &&
            !stringsAreEqual(field1TextController.text, memory['number'],
                memory['numberEncrypt'])) {
          success = false;
        }
        if (memory['expiration'] != '' &&
            !stringsAreEqual(
                datetimeToDateString(field2TextController.text),
                datetimeToDateString(memory['expiration']),
                memory['expirationEncrypt'])) {
          success = false;
        }
        if (memory['other'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['other'],
                memory['otherEncrypt'])) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'Other':
        bool success = true;
        if (memory['other1'] != '' &&
            !stringsAreEqual(field1TextController.text, memory['other1'],
                memory['other1Encrypt'])) {
          success = false;
        }
        if (memory['other2'] != '' &&
            !stringsAreEqual(field2TextController.text, memory['other2'],
                memory['other2Encrypt'])) {
          success = false;
        }
        if (memory['other3'] != '' &&
            !stringsAreEqual(field3TextController.text, memory['other3'],
                memory['other3Encrypt'])) {
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
                      mapKey: 'birthday',
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
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomMemoryTestScreenHelp();
                      }));
                },
              ),
            ]),
        body: Center(
          child: Column(
            children: <Widget>[
              getTest(),
              BasicFlatButton(
                text: 'Submit',
                fontSize: 20,
                onPressed: () => checkAnswer(),
                color: Colors.purple[100]!,
                padding: 10,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ));
  }
}

class PromptPair extends StatefulWidget {
  final String inputType;
  final String mapKey;
  final String title;
  final TextEditingController textController;
  final double containerWidth;

  PromptPair(
      {this.inputType,
      this.mapKey,
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
        Text(
          widget.title,
          style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: widget.containerWidth,
          height: 40,
          child: widget.inputType == 'date'
              ? BasicFlatButton(
                  color: backgroundSemiColor,
                  textColor: backgroundHighlightColor,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      onChanged: (date) {},
                      onConfirm: (date) {
                        widget.textController.text = date.toIso8601String();
                        setState(() {});
                      },
                      currentTime: widget.mapKey == 'birthday'
                          ? DateTime.parse('1990-01-01')
                          : DateTime.now(),
                    );
                  },
                  text: widget.textController.text == ''
                      ? 'Pick Date'
                      : datetimeToDateString(widget.textController.text),
                  fontSize: 18,
                  padding: 5,
                )
              : TextField(
                  style:
                      TextStyle(fontSize: 18, color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                  controller: widget.textController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
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
      buttonColor: Colors.purple[100]!,
      buttonSplashColor: Colors.purple[300]!,
      firstHelpKey: customMemoryTestFirstHelpKey,
    );
  }
}
