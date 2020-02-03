import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';

import 'package:mem_plus_plus/components/custom_memory/id_card.dart';
import 'package:mem_plus_plus/components/custom_memory/contact.dart';
import 'package:mem_plus_plus/components/custom_memory/other.dart';

const String contactString = 'Contact';
const String idCardString = 'ID/Credit Card';
const String recipeString = 'Recipe';
const String otherString = 'Other';

class CustomTestManagerScreen extends StatefulWidget {
  CustomTestManagerScreen({Key key}) : super(key: key);

  @override
  _CustomTestManagerScreenState createState() =>
      _CustomTestManagerScreenState();
}

class _CustomTestManagerScreenState extends State<CustomTestManagerScreen> {

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    setState(() {});
  }

  // TODO: create dialog popup
  // types: phone number, credit card / passport (number with expiration), other text
  // default space-repetitions if select non-custom
  // TODO: USE fibonacci numbers
  // 30m - 2h - 12h - 48h
  // 1h - 6h - 24h - 7d
  // 2h - 24h - 7d - 21d

  void callback(Map map) {
    String memoryType = map['type'];
    switch (memoryType) {
      case (contactString):
        print('it is contact');
        break;
      case (idCardString):
        print('it is ID');

        break;
      case (recipeString):
        print('it is recipe');
        break;
      default:
        print('it is other');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text('Custom test management'), actions: <Widget>[
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
                  showDialog(context: context, child: MyDialogContent(
                    callback: callback,
                  ));
                },
                color: Colors.grey[200],
                splashColor: Colors.amber[200],
                padding: 20,
                fontSize: 20,
              )
            ],
          ),
        ));
  }
}

class CustomTestManagerScreenHelp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      information: ['yo'],
    );
  }
}


class MyDialogContent extends StatefulWidget {
  final Function(Map) callback;

  MyDialogContent({Key key, this.callback});

  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}

class _MyDialogContentState extends State<MyDialogContent> {
  String dropdownValue = 'Contact';

  @override
  void initState(){
    super.initState();
  }

  void callback(Map map) {
    widget.callback(map);
  }

  Widget getMemoryType() {
    switch (dropdownValue) {
      case contactString:
        return ContactInput(

        );
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
              items: <String>[contactString, idCardString, recipeString, otherString]
                .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 16, fontFamily: 'Rajdhani'),),
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
          ],
        ),
      ),
    );
  }
}