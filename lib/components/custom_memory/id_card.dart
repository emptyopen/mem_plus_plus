import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/custom_memory/custom_memory_template.dart';

class IDCardInput extends StatefulWidget {
  final Function() callback;

  IDCardInput({required this.callback});

  @override
  _IDCardInputState createState() => _IDCardInputState();
}

class _IDCardInputState extends State<IDCardInput> {
  // TODO move these to template
  final idCardTitleTextController = TextEditingController();
  final idCardNumberTextController = TextEditingController();
  final idCardExpirationTextController = TextEditingController();
  final idCardOtherTextController = TextEditingController();
  final idCardOtherFieldTextController = TextEditingController();
  final List<MemoryField> memoryFields = [];

  @override
  void initState() {
    super.initState();
    memoryFields.add(MemoryField(
        text: 'ID title',
        mapKey: 'title',
        controller: idCardTitleTextController,
        required: true,
        inputType: 'string'));
    memoryFields.add(MemoryField(
        text: 'ID number',
        mapKey: 'number',
        controller: idCardNumberTextController,
        required: true,
        inputType: 'string'));
    memoryFields.add(MemoryField(
        text: 'ID expiration',
        mapKey: 'expiration',
        controller: idCardExpirationTextController,
        required: false,
        inputType: 'date'));
    memoryFields.add(MemoryField(
        text: 'Custom field',
        mapKey: 'other',
        fieldController: idCardOtherFieldTextController,
        controller: idCardOtherTextController,
        required: false,
        inputType: 'other'));
  }

  @override
  void dispose() {
    idCardTitleTextController.dispose();
    idCardNumberTextController.dispose();
    idCardExpirationTextController.dispose();
    idCardOtherTextController.dispose();
    idCardOtherFieldTextController.dispose();
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
      memoryType: 'ID/Credit Card',
    );
  }
}
