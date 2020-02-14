import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/custom_memory/id_card.dart';
import 'package:mem_plus_plus/components/custom_memory/contact.dart';
import 'package:mem_plus_plus/components/custom_memory/other.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

// TODO: science!! USE fibonacci numbers?
// 30m - 2h - 12h - 48h
// 1h - 6h - 24h - 7d
// 2h - 24h - 7d - 21d

class CustomMemoryManagerScreen extends StatefulWidget {
  final Function callback;

  CustomMemoryManagerScreen({Key key, this.callback}) : super(key: key);

  @override
  _CustomMemoryManagerScreenState createState() =>
      _CustomMemoryManagerScreenState();
}

class _CustomMemoryManagerScreenState extends State<CustomMemoryManagerScreen> {
  Map customMemories = {};
  Column customMemoriesColumn = Column();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    new Timer.periodic(Duration(milliseconds: 100), (Timer t) {
      getCustomMemories();
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, 'CustomMemoryManagerFirstHelp', CustomMemoryManagerScreenHelp());

    if (prefs.getString(customMemoriesKey) == null) {
      customMemories = {};
      prefs.setString(customMemoriesKey, json.encode({}));
    } else {
      customMemories = json.decode(await prefs.getString(customMemoriesKey));
    }

    setState(() {});
  }

  void callback() async {
    var prefs = PrefsUpdater();
    customMemories = await prefs.getSharedPrefs(customMemoriesKey);
    setState(() {});
    widget.callback();
  }

  void getCustomMemories() {
    List<CustomMemoryTile> customMemoryTiles = [];
    for (String customMemoryKey in customMemories.keys) {
      var customMemory = customMemories[customMemoryKey];
      customMemoryTiles.add(CustomMemoryTile(
        customMemory: customMemory,
        callback: callback,
      ));
    }
    if (this.mounted) {
      setState(() {
        customMemoriesColumn = Column(children: customMemoryTiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Custom memory management'),
            backgroundColor: colorCustomMemoryStandard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomMemoryManagerScreenHelp();
                      }));
                },
              ),
            ]),
        body: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(child: customMemoriesColumn),
              Positioned(
                child: FlatButton(
                  color: colorCustomMemoryStandard,
                  splashColor: colorCustomMemoryDarker,
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    showDialog(
                        context: context,
                        child: MyDialogContent(
                          callback: callback,
                        ));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide()),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      children: <Widget>[
                        Center(child: Icon(Icons.add)),
                        SizedBox(width: 10,),
                        Text(
                          'memory',
                          style: TextStyle(fontSize: 24, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                right: 25,
                bottom: 25,
              )
            ],
          ),
        ));
  }
}

class CustomMemoryTile extends StatelessWidget {
  final Map customMemory;
  final Function callback;

  CustomMemoryTile({this.customMemory, this.callback});

  deleteCustomMemory() async {
    var prefs = PrefsUpdater();
    Map customMemories = await prefs.getSharedPrefs(customMemoriesKey);
    customMemories.remove(customMemory['title']);
    prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    callback();
  }

  String findRemainingTime() {
    var nextDateTime = findNextDatetime(
        customMemory['startDatetime'],
        customMemory['spacedRepetitionType'],
        customMemory['spacedRepetitionLevel']);
    var remainingTime = nextDateTime.difference(DateTime.now());
    if (!remainingTime.isNegative) {
      return 'Available in: ${durationToString(remainingTime)}';
    }
    return 'Available! (Main Menu)';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(customMemoryIconMap[customMemory['type']]),
        title: Text('${customMemory['title']}', style: TextStyle(fontSize: 20)),
        subtitle: Text(
          '${customMemory['type']}\n'
          '${findRemainingTime()}',
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 50,
              child: FlatButton(
                child: Icon(
                  Icons.remove_red_eye,
                  color: colorCustomMemoryStandard,
                ),
                onPressed: () => showConfirmDialog(
                    context: context,
                    function: null,
                    confirmText: 'Are you sure you\'d like to view this memory? Doing so '
                    'will reset the spaced repetition schedule back to the beginning!',
                ),
              ),
            ),
            Container(
              width: 50,
              child: FlatButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () => showConfirmDialog(
                  context: context,
                  function: deleteCustomMemory,
                  confirmText: 'Delete memory: ${customMemory['title']}?'
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyDialogContent extends StatefulWidget {
  final Function() callback;

  MyDialogContent({Key key, this.callback});

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  String dropdownValue = idCardString;

  @override
  void initState() {
    super.initState();
  }

  void callback() {
    widget.callback();
  }

  Widget getMemoryType() {
    switch (dropdownValue) {
      case contactString:
        return ContactInput(
          callback: callback,
        );
        break;
      case idCardString:
        return IDCardInput(
          callback: callback,
        );
      case otherString:
        return OtherInput(
          callback: callback,
        );
        break;
      default:
        return OtherInput(
          callback: callback,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 350.0,
        width: 300.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: dropdownValue,
                elevation: 16,
                style: TextStyle(color: colorCustomMemoryStandard),
                underline: Container(
                  height: 2,
                  color: colorCustomMemoryStandard,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  idCardString,
                  contactString,
                  otherString
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16, fontFamily: 'CabinSketch'),
                    ),
                  );
                }).toList(),
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(10),
                  child: getMemoryType()),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMemoryManagerScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Custom Memory Manager',
      information: [
        '    Welcome to custom memory management! A very exciting place. '
          'Here you can create new memories - learn your real credit cards and IDs, '
          'friends\' phone numbers and addresses, recipes, and anything else!',
        '    You can delete a memory by tapping the trash icon, and you can view a memory '
          'by tapping the eye icon. Tapping the eye icon will also reset the spaced '
          'repetition schedule, so only do so if you\'ve actually forgotten it!',
        '    A review on the spaced repetition choices that will be available for these '
          'custom memories.\n\n  30m-2h-12h-48h: Good for short term memories\n\n'
          '  1h-6h-24h-4d: Good for medium term memories ()\n\n'
          '  1h-2h-24h-7d-21d: Good for long term memories (IDs, recipes'
      ],
      buttonColor: colorCustomMemoryStandard,
      buttonSplashColor: colorCustomMemoryDarker,
    );
  }
}
