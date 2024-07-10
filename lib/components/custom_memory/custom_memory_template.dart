import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/data/memory_field.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/services/password/password.dart';
import 'package:mem_plus_plus/services/password/pbkdf2.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomMemoryInput extends StatefulWidget {
  final Function() callback;
  final List<MemoryField> memoryFields;
  final String memoryType;

  CustomMemoryInput(
      {required this.callback,
      required this.memoryFields,
      required this.memoryType});

  @override
  _CustomMemoryInputState createState() => _CustomMemoryInputState();
}

class _CustomMemoryInputState extends State<CustomMemoryInput> {
  // todo: generalize these
  String spacedRepetitionType = longTerm;
  Set errors = Set();
  late List<bool> encryptStates;
  bool encrypting = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void initState() {
    super.initState();
    encryptStates = List.filled(widget.memoryFields.length, false);
  }

  toggleMode(int i) {
    HapticFeedback.lightImpact();
    encryptStates[i] = !encryptStates[i];
    setState(() {});
  }

  getFields() {
    List<Widget> fieldsList = [];
    widget.memoryFields.asMap().forEach((i, memoryField) {
      // if other, have field be textfield
      if (memoryField.inputType == 'other') {
        fieldsList.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              encryptStates[i]
                  ? GestureDetector(
                      onTap: () => toggleMode(i),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.blue[400],
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Icon(
                                Icons.lock,
                                color: backgroundColor,
                              ),
                            ),
                          ),
                          Positioned(
                            child: Text(
                              'SAFE',
                              style: TextStyle(
                                fontFamily: 'Viga',
                                fontSize: 11,
                                color: backgroundHighlightColor,
                              ),
                            ),
                            left: 2,
                            bottom: 6,
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () => toggleMode(i),
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: Icon(
                            Icons.lock_open,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                width: 10,
              ),
              Container(
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
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: backgroundHighlightColor)),
                          hintText: memoryField.text,
                          hintStyle: TextStyle(color: Colors.grey),
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
              ),
            ],
          ),
        );
        fieldsList.add(
          SizedBox(
            height: 5,
          ),
        );
      } else {
        String title = memoryField.text;
        if (memoryField.required) {
          title += ' *';
        }
        fieldsList.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              i != 0
                  ? encryptStates[i]
                      ? GestureDetector(
                          onTap: () => toggleMode(i),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: backgroundColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                child: Text(
                                  'SAFE',
                                  style: TextStyle(
                                    fontFamily: 'Viga',
                                    fontSize: 11,
                                    color: backgroundHighlightColor,
                                  ),
                                ),
                                left: 2,
                                bottom: 6,
                              )
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => toggleMode(i),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                              child: Icon(
                                Icons.lock_open,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        )
                  : Container(),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
              ),
            ],
          ),
        );
        fieldsList.add(
          SizedBox(
            height: 5,
          ),
        );
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
                    borderSide: BorderSide(color: Colors.grey)),
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
            color: Colors.purple[50]!,
            onPressed: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                onChanged: (date) {},
                onConfirm: (date) {
                  memoryField.controller.text = date.toIso8601String();
                  setState(() {});
                },
                currentTime: memoryField.mapKey == 'birthday'
                    ? DateTime.parse('1990-01-01')
                    : DateTime.now(),
              );
            },
            text: memoryField.controller.text == ''
                ? 'Pick Date'
                : datetimeToDateString(memoryField.controller.text),
            fontSize: 18,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              keyboardType: memoryField.inputType == 'number'
                  ? TextInputType.number
                  : TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
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

  addMemory() {
    errors = Set();
    String primaryKey = widget.memoryFields[0].controller.text;
    widget.memoryFields.forEach((memoryField) {
      if (memoryField.controller.text == '' && memoryField.required) {
        errors.add('${memoryField.text} required.');
      }
      if (memoryField.inputType == 'other' &&
          memoryField.controller.text == '' &&
          memoryField.fieldController!.text != '') {
        errors.add('${memoryField.text} value required.');
      }
      if (memoryField.inputType == 'other' &&
          memoryField.controller.text != '' &&
          memoryField.fieldController!.text == '') {
        errors.add('${memoryField.text} title required.');
      }
    });
    encrypting = true;
    setState(() {});
    // check if we already have the memory
    var customMemories = prefs.getSharedPrefs(customMemoriesKey) as Map;
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
    widget.memoryFields.asMap().forEach((i, nonPrimaryMemoryField) {
      if (nonPrimaryMemoryField.inputType == 'other') {
        map[nonPrimaryMemoryField.mapKey + 'Field'] =
            nonPrimaryMemoryField.fieldController!.text;
        if (encryptStates[i]) {
          map[nonPrimaryMemoryField.mapKey + 'Encrypt'] = true;
          map[nonPrimaryMemoryField.mapKey] =
              Password.hash(nonPrimaryMemoryField.controller.text, PBKDF2());
        } else {
          map[nonPrimaryMemoryField.mapKey + 'Encrypt'] = false;
          map[nonPrimaryMemoryField.mapKey] =
              nonPrimaryMemoryField.controller.text;
        }
      } else {
        if (encryptStates[i]) {
          map[nonPrimaryMemoryField.mapKey + 'Encrypt'] = true;
          map[nonPrimaryMemoryField.mapKey] =
              Password.hash(nonPrimaryMemoryField.controller.text, PBKDF2());
        } else {
          map[nonPrimaryMemoryField.mapKey + 'Encrypt'] = false;
          map[nonPrimaryMemoryField.mapKey] =
              nonPrimaryMemoryField.controller.text;
        }
      }
    });
    customMemories[primaryKey] = map;
    prefs.writeSharedPrefs(customMemoriesKey, customMemories);
    notifyDuration(
        firstSpacedRepetitionDuration,
        'Ready to be tested on your \'$primaryKey\' memory?',
        'Good luck!',
        homepageKey);
    encrypting = false;
    setState(() {});
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
        Theme(
          data: Theme.of(context).copyWith(
            canvasColor: backgroundColor,
          ),
          child: DropdownButton<String>(
            value: spacedRepetitionType,
            elevation: 16,
            style: TextStyle(fontSize: 22, color: colorCustomMemoryStandard),
            iconEnabledColor: backgroundHighlightColor,
            underline: Container(
              height: 2,
              color: colorCustomMemoryStandard,
            ),
            onChanged: (String? newValue) {
              setState(() {
                spacedRepetitionType = newValue!;
              });
            },
            items: <String>[shortTerm, mediumTerm, longTerm, extraLongTerm]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'Viga', color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
        getErrors(),
        encrypting
            ? BasicFlatButton(
                text: 'Encrypting',
                onPressed: () {},
                fontSize: 18,
                color: Colors.yellow,
              )
            : BasicFlatButton(
                text: 'Start',
                onPressed: addMemory,
                fontSize: 18,
                color: colorCustomMemoryStandard,
              ),
      ],
    );
  }
}
