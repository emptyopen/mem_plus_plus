import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/custom_memory/custom_memory_template.dart';

class ContactInput extends StatefulWidget {
  final Function() callback;

  ContactInput({required this.callback});

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
  final contactOtherFieldTextController = TextEditingController();
  final List<MemoryField> memoryFields = [];

  @override
  void initState() {
    super.initState();
    memoryFields.add(MemoryField(
        text: 'Contact name',
        mapKey: 'title',
        controller: contactNameTextController,
        required: true,
        inputType: 'string'));
    memoryFields.add(MemoryField(
        text: 'Birthday',
        mapKey: 'birthday',
        controller: contactBirthdayTextController,
        required: false,
        inputType: 'date'));
    memoryFields.add(MemoryField(
        text: 'Phone number',
        mapKey: 'phoneNumber',
        controller: contactPhoneNumberTextController,
        required: false,
        inputType: 'number'));
    memoryFields.add(MemoryField(
        text: 'Address',
        mapKey: 'address',
        controller: contactAddressTextController,
        required: false,
        inputType: 'string'));
    memoryFields.add(MemoryField(
        text: 'Other',
        mapKey: 'other',
        fieldController: contactOtherFieldTextController,
        controller: contactOtherTextController,
        required: false,
        inputType: 'other'));
  }

  @override
  void dispose() {
    titleTextController.dispose();
    contactNameTextController.dispose();
    contactPhoneNumberTextController.dispose();
    contactAddressTextController.dispose();
    contactOtherTextController.dispose();
    contactOtherFieldTextController.dispose();
    super.dispose();
  }

  callback() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMemoryInput(
      callback: callback,
      memoryFields: memoryFields,
      memoryType: 'Contact',
    );
  }
}
