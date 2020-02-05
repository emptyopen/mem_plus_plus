import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/custom_memory/id_card.dart';
import 'package:mem_plus_plus/components/custom_memory/contact.dart';
import 'package:mem_plus_plus/components/custom_memory/other.dart';

const String contactString = 'Contact';
const String idCardString = 'ID/Credit Card';
const String recipeString = 'Recipe';
const String otherString = 'Other';

Map testIconMap = {
  contactString: Icon(Icons.add),
  idCardString: Icon(Icons.multiline_chart),
  recipeString: Icon(Icons.add),
  otherString: Icon(Icons.add),
};

class CustomTestManagerScreen extends StatefulWidget {
  final Function callback;

  CustomTestManagerScreen({Key key, this.callback}) : super(key: key);

  @override
  _CustomTestManagerScreenState createState() =>
      _CustomTestManagerScreenState();
}

// TODO: science!! USE fibonacci numbers?
// 30m - 2h - 12h - 48h
// 1h - 6h - 24h - 7d
// 2h - 24h - 7d - 21d

class _CustomTestManagerScreenState extends State<CustomTestManagerScreen> {
  Map customTests = {};
  String customTestsKey = 'CustomTests';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(
        context, 'CustomTestManagerFirstHelp', CustomTestManagerScreenHelp());

    if (prefs.getString(customTestsKey) == null) {
      customTests = {};
      prefs.setString(customTestsKey, json.encode({}));
    } else {
      customTests = json.decode(await prefs.getString(customTestsKey));
    }

    setState(() {});
  }

  void callback() async {
    var prefs = PrefsUpdater();
    customTests = await prefs.getSharedPrefs(customTestsKey);
    setState(() {});
  }

  Widget getCustomTests() {
    List<CustomTestItem> customTestItems = [];
    for (String customTestKey in customTests.keys) {
      var customTest = customTests[customTestKey];
      customTestItems.add(CustomTestItem(
        customTest: customTest,
        callback: callback,
      ));
    }
    return Column(children: customTestItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Custom test management'),
          backgroundColor: Colors.purple[200],
          actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return CustomTestManagerScreenHelp();
                  }));
            },
          ),
        ]),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BasicFlatButton(
                text: 'Add new memory!',
                onPressed: () {
                  showDialog(
                      context: context,
                      child: MyDialogContent(
                        callback: callback,
                      ));
                },
                color: Colors.purple[100],
                splashColor: Colors.amber[200],
                padding: 10,
                fontSize: 20,
              ),
              SizedBox(
                height: 30,
              ),
              getCustomTests(),
            ],
          ),
        ));
  }
}

class CustomTestItem extends StatelessWidget {
  final Map customTest;
  final Function callback;

  CustomTestItem({this.customTest, this.callback});

  deleteCustomTest() async {
    var prefs = PrefsUpdater();
    Map customTests = await prefs.getSharedPrefs('CustomTests');
    customTests.remove(customTest['title']);
    prefs.writeSharedPrefs('CustomTests', customTests);
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: testIconMap[customTest['type']],
      title: Text('${customTest['title']}', style: TextStyle(fontSize: 20)),
      subtitle: Text(
        '${customTest['type']}',
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
                color: Colors.deepPurpleAccent,
              ),
              onPressed: () => showConfirmDialog(
                  context,
                  null,
                  'Are you sure you\'d like to view this memory? Doing so '
                  'will reset the spaced repetition schedule back to the beginning!'),
            ),
          ),
          Container(
            width: 50,
            child: FlatButton(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => showConfirmDialog(context, deleteCustomTest,
                  'Delete memory: ${customTest['title']}?'),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTestManagerScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Custom Test Manager',
      information: [
        '    Welcome to custom test management! A very exciting place. '
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
  String dropdownValue = 'Contact';

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
        return ContactInput();
        break;
      case idCardString:
        return IDCardInput(
          callback: callback,
        );
      case otherString:
        return OtherInput();
        break;
      default:
        return ContactInput();
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
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>[
                  contactString,
                  idCardString,
                  recipeString,
                  otherString
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16, fontFamily: 'Rajdhani'),
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
