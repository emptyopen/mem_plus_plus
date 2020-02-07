import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/custom_memory/custom_memory_template.dart';

class OtherInput extends StatefulWidget {
  final Function() callback;

  OtherInput({this.callback});

  @override
  _OtherInputState createState() => _OtherInputState();
}

// todo: use template

class _OtherInputState extends State<OtherInput> {

  final otherTitleTextController = TextEditingController();
  final other1FieldTextController = TextEditingController();
  final other1TextController = TextEditingController();
  final other2FieldTextController = TextEditingController();
  final other2TextController = TextEditingController();
  final other3FieldTextController = TextEditingController();
  final other3TextController = TextEditingController();
  final List<MemoryField> memoryFields = [];

  @override
  void dispose() {
    otherTitleTextController.dispose();
    other1TextController.dispose();
    other2TextController.dispose();
    other3TextController.dispose();
    other1FieldTextController.dispose();
    other2FieldTextController.dispose();
    other3FieldTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    memoryFields.add(MemoryField(
      text: 'Title',
      mapKey: 'title',
      controller: otherTitleTextController,
      required: true,
      inputType: 'string'));
    memoryFields.add(MemoryField(
      text: 'Custom field 1',
      mapKey: 'other1',
      fieldController: other1FieldTextController,
      controller: other1TextController,
      required: true,
      inputType: 'other'));
    memoryFields.add(MemoryField(
      text: 'Custom field 2',
      mapKey: 'other2',
      fieldController: other2FieldTextController,
      controller: other2TextController,
      required: false,
      inputType: 'other'));
    memoryFields.add(MemoryField(
      text: 'Custom field 3',
      mapKey: 'other3',
      fieldController: other3FieldTextController,
      controller: other3TextController,
      required: false,
      inputType: 'other'));
  }

  callback() {
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMemoryInput(
      callback: callback,
      memoryFields: memoryFields,
      memoryType: 'ID/Credit Card',
    );
  }
}
