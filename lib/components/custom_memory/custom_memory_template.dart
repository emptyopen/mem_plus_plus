import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  String spacedRepetitionType = longTerm;
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
                  style: TextStyle(color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                  controller: memoryField.fieldController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: backgroundSemiColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundHighlightColor)),
                    hintText: memoryField.text,
                    hintStyle: TextStyle(color: backgroundSemiColor),
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              memoryField.required
                  ? Text(
                      ' *',
                      style: TextStyle(
                          fontSize: 20, color: backgroundHighlightColor),
                    )
                  : Container()
            ],
          ),
        ));
        fieldsList.add(SizedBox(
          height: 5,
        ));
      } else {
        String title = memoryField.text;
        if (memoryField.required) {
          title += ' *';
        }
        fieldsList.add(Text(title,
            style: TextStyle(fontSize: 20, color: backgroundHighlightColor)));
      }

      // if required, add error box below
      if (memoryField.inputType == 'other') {
        fieldsList.add(
          Container(
            width: 230,
            height: 30,
            child: TextField(
              style: TextStyle(color: backgroundHighlightColor),
              textAlign: TextAlign.center,
              controller: memoryField.controller,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundSemiColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundHighlightColor)),
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        );
      } else if (memoryField.inputType == 'date') {
        fieldsList.add(
          BasicFlatButton(
            color: backgroundSemiColor,
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                
                  showTitleActions: true,
                  onChanged: (date) {}, onConfirm: (date) {
                print('confirm $date');
                memoryField.controller.text = date.toIso8601String();
                setState(() {});
              }, 
              currentTime: DateTime.now()
              );
            },
            text: memoryField.controller.text == ''
                ? 'Pick Date'
                : datetimeToDateString(memoryField.controller.text),
            fontSize: 18,
            padding: 5,
          ),
        );
      } else {
        fieldsList.add(
          Container(
            width: 230,
            height: 30,
            child: TextField(
              style: TextStyle(color: backgroundHighlightColor),
              textAlign: TextAlign.center,
              controller: memoryField.controller,
              keyboardType: memoryField.inputType == 'number' ? TextInputType.number : TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundSemiColor)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: backgroundHighlightColor)),
                contentPadding: EdgeInsets.all(5),
                border: OutlineInputBorder(),
              ),
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
      if (memoryField.inputType == 'other' &&
          memoryField.controller.text == '' &&
          memoryField.fieldController.text != '') {
        errors.add('${memoryField.text} value required.');
      }
      if (memoryField.inputType == 'other' &&
          memoryField.controller.text != '' &&
          memoryField.fieldController.text == '') {
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
    Duration firstSpacedRepetitionDuration =
        termDurationsMap[spacedRepetitionType][0];
    Map map = {
      'type': widget.memoryType,
      'title': primaryKey,
      'nextDatetime':
          DateTime.now().add(firstSpacedRepetitionDuration).toIso8601String(),
      'spacedRepetitionType': spacedRepetitionType,
      'spacedRepetitionLevel': 0,
    };
    widget.memoryFields.sublist(1).forEach((nonPrimaryMemoryField) {
      if (nonPrimaryMemoryField.inputType == 'other') {
        map[nonPrimaryMemoryField.mapKey + 'Field'] =
            nonPrimaryMemoryField.fieldController.text;
        map[nonPrimaryMemoryField.mapKey] =
            nonPrimaryMemoryField.controller.text;
      } else {
        map[nonPrimaryMemoryField.mapKey] =
            nonPrimaryMemoryField.controller.text;
      }
    });
    customMemories[primaryKey] = map;
    await prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    notifyDuration(
        firstSpacedRepetitionDuration,
        'Ready to be tested on your \'$primaryKey\' memory?',
        'Good luck!',
        homepageKey);
    widget.callback();
    Navigator.pop(context);
  }

  getErrors() {
    List<Text> errorList = [];
    errors.forEach((e) {
      errorList.add(Text(
        e,
        style: TextStyle(color: Colors.red),
      ));
    });
    return Column(children: errorList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: getFields(),
        ),
        Text('* = required',
            style: TextStyle(fontSize: 14, color: backgroundHighlightColor)),
        SizedBox(
          height: 10,
        ),
        Text(
          'How long to remember it?',
          style: TextStyle(fontSize: 18, color: backgroundHighlightColor),
        ),
        DropdownButton<String>(
          value: spacedRepetitionType,
          elevation: 16,
          style: TextStyle(fontSize: 22, color: colorCustomMemoryStandard),
          iconEnabledColor: backgroundHighlightColor,
          underline: Container(
            height: 2,
            color: colorCustomMemoryStandard,
          ),
          onChanged: (String newValue) {
            setState(() {
              spacedRepetitionType = newValue;
            });
          },
          items: <String>[shortTerm, mediumTerm, longTerm, extraLongTerm]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 20, fontFamily: 'CabinSketch'),
              ),
            );
          }).toList(),
        ),
        getErrors(),
        BasicFlatButton(
          text: 'Start',
          onPressed: addMemory,
          fontSize: 18,
          color: colorCustomMemoryStandard,
        ),
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

  MemoryField(
      {this.text,
      this.mapKey,
      this.controller,
      this.fieldController,
      this.required,
      this.inputType});
}
