import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/custom_memory/custom_memory_template.dart';
import 'package:mem_plus_plus/services/services.dart';

class ContactInput extends StatefulWidget {
  final Function() callback;

  ContactInput({this.callback});

  @override
  _ContactInputState createState() => _ContactInputState();
}

class _ContactInputState extends State<ContactInput> {
  final titleTextController = TextEditingController();
  final contactNameTextController = TextEditingController();
  final contactBirthdayTextController = TextEditingController();
  final contactPhoneNumberTextController = TextEditingController();
  final contactAddressTextController = TextEditingController();
  final contactOtherTextController = TextEditingController();
  String spacedRepetitionChoice = 'short term (1d ~ 1w)';
  String shortTerm = 'short term (1d ~ 1w)';
  String mediumTerm = 'medium term (1w ~ 3m)';
  String longTerm = 'long term (3m ~ 1y)';
  String extraLongTerm = 'extra long term (1y ~ life)';
  final List<MemoryField> memoryFields = [];

  @override
  void initState() {
    super.initState();
    memoryFields.add(MemoryField(
        text: 'Contact name *', controller: contactNameTextController));
    memoryFields.add(MemoryField(
        text: 'Contact birthday *', controller: contactBirthdayTextController));
    memoryFields.add(MemoryField(
        text: 'Contact phone number',
        controller: contactPhoneNumberTextController));
    memoryFields.add(MemoryField(
        text: 'Contact address', controller: contactAddressTextController));
    memoryFields.add(MemoryField(text: 'Other', controller: contactOtherTextController));
  }

  @override
  void dispose() {
    titleTextController.dispose();
    contactNameTextController.dispose();
    contactPhoneNumberTextController.dispose();
    contactAddressTextController.dispose();
    contactOtherTextController.dispose();
    super.dispose();
  }

  addMemory() async {
    var prefs = PrefsUpdater();
    if (contactNameTextController.text == '') {
      print('need name');
      return false;
    }
    if (contactBirthdayTextController.text == '') {
      print('need birthday');
      return false;
    }
    var customTests = await prefs.getSharedPrefs('CustomTests') as Map;
    if (customTests.containsKey(contactNameTextController.text)) {
      print('already have!');
      return false;
    }
    Map map = {
      'type': 'Contact',
      'title': contactNameTextController.text,
      'startDatetime': DateTime.now().toIso8601String(),
      'spacedRep': 0,
      'birthday': contactBirthdayTextController.text,
      'phoneNumber': contactPhoneNumberTextController.text,
      'phoneNumber': contactPhoneNumberTextController.text,
      'phoneNumber': contactPhoneNumberTextController.text,
      'spacedRepetition': spacedRepetitionChoice,
    };
    customTests[map['title']] = map;
    await prefs.writeSharedPrefs('CustomTests', customTests);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CustomerMemoryInput(
      addMemory: addMemory,
      memoryFields: memoryFields,
    );
  }
}
