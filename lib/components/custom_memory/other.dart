import 'package:flutter/material.dart';

class OtherInput extends StatefulWidget {
  @override
  _OtherInputState createState() => _OtherInputState();
}

class _OtherInputState extends State<OtherInput> {

  final titleTextController = TextEditingController();
  final other1TextController = TextEditingController();
  final other2TextController = TextEditingController();
  final other3TextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    other1TextController.dispose();
    other2TextController.dispose();
    other3TextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Title:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: titleTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Field 1:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: other1TextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Field 2:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: other2TextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Field 3:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: other3TextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            print('hey');
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
