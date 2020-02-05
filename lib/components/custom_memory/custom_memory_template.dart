import 'package:flutter/material.dart';

class CustomerMemoryInput extends StatefulWidget {
  final Function() addMemory;
  final List<MemoryField> memoryFields;

  CustomerMemoryInput({this.addMemory, this.memoryFields});

  @override
  _CustomerMemoryInputState createState() => _CustomerMemoryInputState();
}

class _CustomerMemoryInputState extends State<CustomerMemoryInput> {
  // todo: generalize these
  String spacedRepetitionChoice = 'short term (1d ~ 1w)';
  String shortTerm = 'short term (1d ~ 1w)';
  String mediumTerm = 'medium term (1w ~ 3m)';
  String longTerm = 'long term (3m ~ 1y)';
  String extraLongTerm = 'extra long term (1y ~ life)';

  getFields() {
    List<Widget> fieldsList = [];
    widget.memoryFields.forEach((memoryField) {
      fieldsList.add(Text(
        '${memoryField.text}',
        style: TextStyle(fontSize: 20),
      ));
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
      fieldsList.add(
        SizedBox(
          height: 10,
        ),
      );
    });
    return fieldsList;
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
        FlatButton(
            onPressed: () => widget.addMemory(),
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
  TextEditingController controller;

  MemoryField({this.text, this.controller});
}
