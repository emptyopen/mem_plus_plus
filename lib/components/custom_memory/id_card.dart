import 'package:flutter/material.dart';

class IDCardInput extends StatefulWidget {
  final Function(Map) callback;

  IDCardInput({this.callback});

  @override
  _IDCardInputState createState() => _IDCardInputState();
}

class _IDCardInputState extends State<IDCardInput> {

  final idCardTitleTextController = TextEditingController();
  final idCardNumberTextController = TextEditingController();
  final idCardExpirationTextController = TextEditingController();
  final idCardOtherTextController = TextEditingController();

  @override
  void dispose() {
    idCardTitleTextController.dispose();
    idCardNumberTextController.dispose();
    idCardExpirationTextController.dispose();
    idCardOtherTextController.dispose();
    super.dispose();
  }

  sendMemoryBack() {
    Map map = {
      'type': 'ID/Credit Card',
      'title': idCardTitleTextController,
      'number': idCardNumberTextController.text,
      'expiration': idCardExpirationTextController.text,
      'other': idCardOtherTextController,
    };
    widget.callback(map);
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
        FlatButton(
          onPressed: () {
            if (idCardNumberTextController.text == '') {
              print('need number');
            } else if (idCardExpirationTextController.text == '') {
              print('need expiration');
            }
            else {
              sendMemoryBack();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18.0),
            ),
          ))
      ],
    );
  }
}
