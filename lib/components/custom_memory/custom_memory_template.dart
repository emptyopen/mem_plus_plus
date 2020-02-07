import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';

String customMemoriesKey = 'CustomMemories';

class CustomMemoryInput extends StatefulWidget {
  final Function() callback;
  final List<MemoryField> memoryFields;
  final String memoryType;

  CustomMemoryInput({this.callback, this.memoryFields, this.memoryType});

  @override
  _CustomMemoryInputState createState() => _CustomMemoryInputState();
}

class _CustomMemoryInputState extends State<CustomMemoryInput> {
  // todo: generalize these
  String spacedRepetitionChoice = 'long term (3m ~ 1y)';
  String shortTerm = 'short term (1d ~ 1w)';
  String mediumTerm = 'medium term (1w ~ 3m)';
  String longTerm = 'long term (3m ~ 1y)';
  String extraLongTerm = 'extra long term (1y ~ life)';
  Set errors = Set();

  getFields() {
    List<Widget> fieldsList = [];
    widget.memoryFields.forEach((memoryField) {

      // if other, have field be textfield
      if (memoryField.inputType == 'other') {
        fieldsList.add(Container(
          width: 160,
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: memoryField.fieldController,
                  decoration: InputDecoration(
                    hintText: memoryField.text,
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple))),
                ),
              ),
              memoryField.required ? Text(' *', style: TextStyle(fontSize: 20),) : Container()
            ],
          ),
        ));
        fieldsList.add(SizedBox(height: 5,));
      } else {
        String title = memoryField.text;
        if (memoryField.required) {
          title += ' *';
        }
        fieldsList.add(Text(title, style: TextStyle(fontSize: 20)));
      }


      // if required, add error box below
      if (memoryField.inputType == 'other') {
        fieldsList.add(
          Container(
            width: 230,
            height: 30,
            child: TextField(
              textAlign: TextAlign.center,
              controller: memoryField.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple))),
            ),
          ),
        );
      } else {
        fieldsList.add(
          Container(
            width: 230,
            height: 30,
            child: TextField(
              textAlign: TextAlign.center,
              controller: memoryField.controller,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple))),
            ),
          ),
        );
      }
      fieldsList.add(
        SizedBox(
          height: 10,
        ),
      );
    });
    return fieldsList;
  }

  addMemory() async {
    var prefs = PrefsUpdater();
    errors = Set();
    String primaryKey = widget.memoryFields[0].controller.text;
    widget.memoryFields.forEach((memoryField) {
      if (memoryField.controller.text == '' && memoryField.required) {
        errors.add('${memoryField.text} required.');
      }
      if (memoryField.inputType == 'other' && memoryField.controller.text == '' && memoryField.fieldController.text != '') {
        errors.add('${memoryField.text} value required.');
      }
      if (memoryField.inputType == 'other' && memoryField.controller.text != '' && memoryField.fieldController.text == '') {
        errors.add('${memoryField.text} title required.');
      }
    });
    setState(() {});
    // check if we already have the memory
    var customMemories = await prefs.getSharedPrefs(customMemoriesKey) as Map;
    if (customMemories.containsKey(primaryKey)) {
      errors.add('Already have a memory with that name.');
    }
    if (errors.length > 0) {
      return;
    }
    Map map = {
      'type': widget.memoryType,
      'title': primaryKey,
      'startDatetime': DateTime.now().toIso8601String(),
      'latestDatetime': DateTime.now().toIso8601String(),
      'spacedRepetitionType': spacedRepetitionChoice,
      'spacedRepetitionLevel': 0,
    };
    widget.memoryFields.sublist(1).forEach((nonPrimaryMemoryField) {
      if (widget.memoryType == 'other') {
        map[nonPrimaryMemoryField.mapKey + 'Field'] = nonPrimaryMemoryField.fieldController.text;
        map[nonPrimaryMemoryField.mapKey] = nonPrimaryMemoryField.controller.text;
      } else {
        map[nonPrimaryMemoryField.mapKey] = nonPrimaryMemoryField.controller.text;
      }
    });
    customMemories[primaryKey] = map;
    print(customMemories);
    await prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    widget.callback();
    Navigator.pop(context);
  }

  getErrors() {
    List<Text> errorList = [];
    errors.forEach((e) {
      errorList.add(Text(e, style: TextStyle(color: Colors.red),));
    });
    return Column(
      children: errorList
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: getFields(),
        ),
        Text('* = required', style: TextStyle(fontSize: 14)),
        SizedBox(
          height: 10,
        ),
        Text(
          'How long to remember it?',
          style: TextStyle(fontSize: 18),
        ),
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
          items: <String>[shortTerm, mediumTerm, longTerm, extraLongTerm]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 16, fontFamily: 'Rajdhani'),
              ),
            );
          }).toList(),
        ),
        getErrors(),
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

class MemoryField {
  String text;
  String mapKey;
  TextEditingController controller;
  TextEditingController fieldController;
  bool required;
  String inputType;

  MemoryField({this.text, this.mapKey, this.controller, this.fieldController, this.required, this.inputType});
}
