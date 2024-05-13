import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/components/standard/big_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/custom_memory/id_card.dart';
import 'package:mem_plus_plus/components/custom_memory/contact.dart';
import 'package:mem_plus_plus/components/custom_memory/other.dart';
import 'dart:async';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class CustomMemoryManagerScreen extends StatefulWidget {
  final Function callback;

  CustomMemoryManagerScreen({Key? key, required this.callback})
      : super(key: key);

  @override
  _CustomMemoryManagerScreenState createState() =>
      _CustomMemoryManagerScreenState();
}

class _CustomMemoryManagerScreenState extends State<CustomMemoryManagerScreen> {
  Map customMemories = {};
  Column customMemoriesColumn = Column();
  PrefsUpdater prefs = PrefsUpdater();

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
    prefs.checkFirstTime(context, customMemoryManagerFirstHelpKey,
        CustomMemoryManagerScreenHelp(callback: widget.callback));

    customMemories = json.decode((prefs.getString(customMemoriesKey)));

    setState(() {});
  }

  void callback() async {
    customMemories = prefs.getSharedPrefs(customMemoriesKey) as Map;
    setState(() {});
    widget.callback();
  }

  void getCustomMemories() {
    List<CustomMemoryTile> customMemoryTiles = [];
    for (String customMemoryKey in customMemories.keys) {
      var customMemory = customMemories[customMemoryKey];
      customMemoryTiles.add(
        CustomMemoryTile(
          customMemory: customMemory,
          callback: callback,
        ),
      );
    }
    if (this.mounted) {
      setState(() {
        customMemoriesColumn = Column(children: customMemoryTiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            title: Text('Custom memories', style: TextStyle(fontSize: 18)),
            backgroundColor: colorCustomMemoryStandard,
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomMemoryManagerScreenHelp(
                            callback: widget.callback);
                      }));
                },
              ),
            ]),
        body: Container(
          decoration: BoxDecoration(color: backgroundColor),
          child: Center(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      customMemoriesColumn,
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: backgroundSemiHighlightColor,
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Some ideas for custom memories: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '  - Phone numbers\n  - Birthdays\n  - Addresses\n'
                                  '  - Credit cards\n  - Checking/routing numbers\n  - Driver\'s license info\n  - Licence plates'
                                  '\n  - Recipes (template coming later)\n  - Flight confirmation numbers'
                                  '\n  - Security codes\n  - Padlock combinations\n  - Usernames/passwords\n\n... if you had to '
                                  'look it up recently, it\'s a good candidate!',
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: screenWidth * 0.8,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: backgroundSemiHighlightColor,
                              ),
                            ),
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Is it safe to type my info here?',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '    All custom memory data can be hashed using '
                                  'SHA-512 encryption, meaning nothing you type (for your choices of data) will ever '
                                  'be stored anywhere in plain text!\n    You can specify if you\'d like something '
                                  'cryptographically secured when storing the memory by toggling the SAFE symbol for that field. '
                                  'Keep in mind that if you do that, you won\'t be able to view it later even if you '
                                  'forget it, because only the hash value will be stored!\n    In general, this app does '
                                  'not communicate at all with any server, so all data is stored locally and never leaves.',
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  child: BigButton(
                    title: 'Add Memory',
                    function: () {
                      HapticFeedback.lightImpact();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return MyDialogContent(
                              callback: callback,
                            );
                          });
                    },
                    color1: Colors.purpleAccent,
                    color2: Colors.purple,
                  ),
                  right: 25,
                  bottom: 25,
                )
              ],
            ),
          ),
        ));
  }
}

class CustomMemoryTile extends StatelessWidget {
  final Map customMemory;
  final Function callback;
  final prefs = PrefsUpdater();

  CustomMemoryTile({required this.customMemory, required this.callback});

  deleteCustomMemory() async {
    Map customMemories = prefs.getSharedPrefs(customMemoriesKey) as Map;
    customMemories.remove(customMemory['title']);
    prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    callback();
  }

  confirmViewCustomMemory(BuildContext context) async {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(
            'Confirm',
            style: TextStyle(color: backgroundHighlightColor),
          ),
          content: Text(
            'Are you sure you\'d like to view this memory? Doing so '
            'will reset the spaced repetition schedule back to the beginning!',
            style: TextStyle(color: backgroundHighlightColor),
          ),
          actions: <Widget>[
            BasicFlatButton(
              text: 'Cancel',
              color: Colors.grey[300]!,
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
            ),
            BasicFlatButton(
              text: 'Confirm',
              color: colorCustomMemoryStandard,
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return viewCustomMemory(context);
                    }));
              },
            ),
          ],
        );
      },
    );
  }

  viewCustomMemory(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
                      width: screenWidth * 0.8,
                      height: 400,
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          customMemory['type'] == 'Contact'
                              ? Column(
                                  children: <Widget>[
                                    CustomMemoryViewPair(
                                      heading: 'Title:',
                                      subHeading: customMemory['title'],
                                    ),
                                    customMemory['birthday'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading: 'Birthday:',
                                            subHeading:
                                                customMemory['birthday'],
                                            encrypted:
                                                customMemory['birthdayEncrypt'],
                                          ),
                                    customMemory['phoneNumber'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading: 'Phone number:',
                                            subHeading:
                                                customMemory['phoneNumber'],
                                            encrypted: customMemory[
                                                'phoneNumberEncrypt'],
                                          ),
                                    customMemory['address'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading: 'Address:',
                                            subHeading: customMemory['address'],
                                            encrypted:
                                                customMemory['addressEncrypt'],
                                          ),
                                    customMemory['other'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading:
                                                customMemory['otherField'] +
                                                    ':',
                                            subHeading: customMemory['other'],
                                            encrypted:
                                                customMemory['otherEncrypt'],
                                          ),
                                  ],
                                )
                              : Container(),
                          customMemory['type'] == 'ID/Credit Card'
                              ? Column(
                                  children: <Widget>[
                                    CustomMemoryViewPair(
                                      heading: 'Title:',
                                      subHeading: customMemory['title'],
                                    ),
                                    CustomMemoryViewPair(
                                      heading: 'Number:',
                                      subHeading: customMemory['number'],
                                      encrypted: customMemory['numberEncrypt'],
                                    ),
                                    customMemory['expiration'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading: 'Expiration:',
                                            subHeading: customMemory[
                                                    'expirationEncrypt']
                                                ? 'ENCRYPTED'
                                                : datetimeToDateString(
                                                    customMemory['expiration']),
                                            encrypted: customMemory[
                                                'expirationEncrypt'],
                                          ),
                                    customMemory['other'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading:
                                                customMemory['otherField'] +
                                                    ':',
                                            subHeading: customMemory['other'],
                                            encrypted:
                                                customMemory['otherEncrypt'],
                                          ),
                                  ],
                                )
                              : Container(),
                          customMemory['type'] == 'Other'
                              ? Column(
                                  children: <Widget>[
                                    CustomMemoryViewPair(
                                      heading: 'Title:',
                                      subHeading: customMemory['title'],
                                    ),
                                    CustomMemoryViewPair(
                                      heading:
                                          customMemory['other1Field'] + ':',
                                      subHeading: customMemory['other1'],
                                      encrypted: customMemory['other1Encrypt'],
                                    ),
                                    customMemory['other2'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading:
                                                customMemory['other2Field'] +
                                                    ':',
                                            subHeading: customMemory['other2'],
                                            encrypted:
                                                customMemory['other2Encrypt'],
                                          ),
                                    customMemory['other3'] == ''
                                        ? Container()
                                        : CustomMemoryViewPair(
                                            heading:
                                                customMemory['other3Field'] +
                                                    ':',
                                            subHeading: customMemory['other3'],
                                            encrypted:
                                                customMemory['other3Encrypt'],
                                          ),
                                  ],
                                )
                              : Container(),
                        ],
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  BasicFlatButton(
                    text: 'OK',
                    fontSize: 24,
                    color: colorCustomMemoryStandard,
                    onPressed: () => resetCustomMemory(context),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  resetCustomMemory(BuildContext context) async {
    HapticFeedback.lightImpact();
    Map customMemories = prefs.getSharedPrefs(customMemoriesKey) as Map;
    customMemories[customMemory['title']]['spacedRepetitionLevel'] = 0;
    var spacedRepetitionType =
        customMemories[customMemory['title']]['spacedRepetitionType'];
    Duration firstSpacedRepetitionDuration =
        termDurationsMap[spacedRepetitionType][0];
    customMemories[customMemory['title']]['nextDatetime'] =
        DateTime.now().add(firstSpacedRepetitionDuration).toIso8601String();
    prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    callback();
    Navigator.of(context).pop();
  }

  String findRemainingTime() {
    var remainingTime =
        DateTime.parse(customMemory['nextDatetime']).difference(DateTime.now());
    if (!remainingTime.isNegative) {
      return 'Available in: ${durationToString(remainingTime)}';
    }
    return 'Available! (Main Menu)';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundSemiColor,
      child: ListTile(
        leading: Icon(
          customMemoryIconMap[customMemory['type']],
          color: backgroundHighlightColor,
        ),
        title: Text('${customMemory['title']}',
            style: TextStyle(fontSize: 20, color: backgroundHighlightColor)),
        subtitle: Text(
          '${findRemainingTime()}',
          style: TextStyle(fontSize: 14, color: backgroundHighlightColor),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 50,
              child: GestureDetector(
                child:
                    Icon(Icons.remove_red_eye, color: colorCustomMemoryDarker),
                onTap: () => confirmViewCustomMemory(context),
              ),
            ),
            Container(
              width: 50,
              child: GestureDetector(
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onTap: () => showConfirmDialog(
                    context: context,
                    function: deleteCustomMemory,
                    confirmText: 'Delete memory: ${customMemory['title']}?'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomMemoryViewPair extends StatelessWidget {
  final String heading;
  final String subHeading;
  final bool encrypted;

  CustomMemoryViewPair(
      {required this.heading,
      required this.subHeading,
      this.encrypted = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          heading,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        SizedBox(
          height: 3,
        ),
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(10),
            child: encrypted
                ? Container(
                    width: 120,
                    child: Stack(
                      children: <Widget>[
                        // Text(
                        //   subHeading.substring(0, 6),
                        //   style: TextStyle(color: Colors.black, fontSize: 20),
                        //   textAlign: TextAlign.center,
                        // ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(Icons.lock),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'ENCRYPTED',
                            style: TextStyle(color: Colors.red, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  )
                : Text(subHeading,
                    style: TextStyle(
                        fontSize: 20, color: backgroundHighlightColor))),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class MyDialogContent extends StatefulWidget {
  final Function() callback;

  MyDialogContent({Key? key, required this.callback});

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
      case idCardString:
        return IDCardInput(
          callback: callback,
        );
      case otherString:
        return OtherInput(
          callback: callback,
        );
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
      backgroundColor: backgroundColor,
      child: Container(
        height: 350.0,
        width: 300.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: backgroundColor,
                ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  iconEnabledColor: backgroundHighlightColor,
                  underline: Container(
                    height: 2,
                    color: colorCustomMemoryStandard,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[idCardString, contactString, otherString]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 22, fontFamily: 'Viga'),
                      ),
                    );
                  }).toList(),
                ),
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
  final Function callback;
  CustomMemoryManagerScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Custom Memory Manager',
      information: [
        '    Welcome to custom memory management! A very exciting place. '
            'Here you can create new memories - learn your real credit cards and IDs, '
            'friends\' phone numbers and addresses, recipes, and anything else!',
        '    You can delete a memory by tapping the trash icon, and you can view a memory '
            'by tapping the eye icon. Tapping the eye icon will also reset the spaced '
            'repetition schedule, so only do so if you\'ve actually forgotten it!',
      ],
      buttonColor: colorCustomMemoryStandard,
      buttonSplashColor: colorCustomMemoryDarker,
      firstHelpKey: customMemoryManagerFirstHelpKey,
      callback: callback,
    );
  }
}
