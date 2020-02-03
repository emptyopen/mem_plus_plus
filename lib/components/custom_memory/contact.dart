import 'package:flutter/material.dart';

class ContactInput extends StatefulWidget {
  @override
  _ContactInputState createState() => _ContactInputState();
}

class _ContactInputState extends State<ContactInput> {

  final titleTextController = TextEditingController();
  final contactNameTextController = TextEditingController();
  final contactPhoneNumberTextController = TextEditingController();
  final contactAddressTextController = TextEditingController();
  final contactOtherTextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    contactNameTextController.dispose();
    contactPhoneNumberTextController.dispose();
    contactAddressTextController.dispose();
    contactOtherTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Name:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: contactNameTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Contact phone number:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: contactPhoneNumberTextController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple))
            ),
          ),
        ),
        Text('Contact address:'),
        Container(
          width: 230,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: contactAddressTextController,
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
            controller: contactOtherTextController,
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
