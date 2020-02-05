import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';

class IDCardInput extends StatefulWidget {
  final Function() callback;

  IDCardInput({this.callback});

  @override
  _IDCardInputState createState() => _IDCardInputState();
}

class _IDCardInputState extends State<IDCardInput> {

  final idCardTitleTextController = TextEditingController();
  final idCardNumberTextController = TextEditingController();
  final idCardExpirationTextController = TextEditingController();
  final idCardOtherTextController = TextEditingController();
  String spacedRepetitionChoice = '30m-2h-12h-48h';
  String beginner = '30m-2h-12h-48h';
  String intermediate = '1h-6h-24h-4d';
  String expert = '1h-6h-24h-7d-21d';

  @override
  void dispose() {
    idCardTitleTextController.dispose();
    idCardNumberTextController.dispose();
    idCardExpirationTextController.dispose();
    idCardOtherTextController.dispose();
    super.dispose();
  }

  addMemory() async {
    var prefs = PrefsUpdater();
    if (idCardNumberTextController.text == '') {
      print('need number');
      return false;
    } else if (idCardExpirationTextController.text == '') {
      print('need expiration');
      return false;
    }
    var customTests = await prefs.getSharedPrefs('CustomTests') as Map;
    if (customTests.containsKey(idCardTitleTextController.text)) {
      print('already have!');
      return false;
    }
    Map map = {
      'type': 'ID/Credit Card',
      'title': idCardTitleTextController.text,
      'startDatetime': DateTime.now().toIso8601String(),
      'spacedRep': 0,
      'number': idCardNumberTextController.text,
      'expiration': idCardExpirationTextController.text,
      'other': idCardOtherTextController.text,
      'spacedRepetition': spacedRepetitionChoice,
    };
    customTests[map['title']] = map;
    await prefs.writeSharedPrefs('CustomTests', customTests);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('ID title:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: idCardTitleTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('ID number:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: idCardNumberTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('ID expiration:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: idCardExpirationTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Other:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: idCardOtherTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        SizedBox(height: 10,),
        Text('Spaced Repetition:'),
        DropdownButton<String>(
          value: spacedRepetitionChoice,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              spacedRepetitionChoice = newValue;
            });
          },
          items: <String>[beginner, intermediate, expert]
            .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: 16, fontFamily: 'Rajdhani'),),
            );
          }).toList(),
        ),
        FlatButton(
          onPressed: () => addMemory(),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(
              'Start',
              style: TextStyle(fontSize: 18.0),
            ),
          )),
      ],
    );
  }
}
