import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/custom_memory/custom_memory_template.dart';

class IDCardInput extends StatefulWidget {
  final Function() callback;

  IDCardInput({this.callback});

  @override
  _IDCardInputState createState() => _IDCardInputState();
}

class _IDCardInputState extends State<IDCardInput> {

  final idCardTitleTextController = TextEditingController();
  final idCardNumberTextController = TextEditingController();
  final idCardExpirationTextController = TextEditingController();
  final idCardOtherTextController = TextEditingController();
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
      text: 'ID title *', controller: idCardTitleTextController));
    memoryFields.add(MemoryField(
      text: 'ID number *', controller: idCardNumberTextController));
    memoryFields.add(MemoryField(
      text: 'ID expiration *',
      controller: idCardExpirationTextController));
    memoryFields.add(MemoryField(
      text: 'Other', controller: idCardOtherTextController));
  }

  @override
  void dispose() {
    idCardTitleTextController.dispose();
    idCardNumberTextController.dispose();
    idCardExpirationTextController.dispose();
    idCardOtherTextController.dispose();
    super.dispose();
  }

  addMemory() async {
    var prefs = PrefsUpdater();
    if (idCardTitleTextController.text == '') {
      print('need title');
      return false;
    }
    if (idCardNumberTextController.text == '') {
      print('need number');
      return false;
    }
    if (idCardExpirationTextController.text == '') {
      print('need expiration');
      return false;
    }
    var customTests = await prefs.getSharedPrefs('CustomTests') as Map;
    if (customTests.containsKey(idCardTitleTextController.text)) {
      print('already have!');
      return false;
    }
    Map map = {
      'type': 'ID/Credit Card',
      'title': idCardTitleTextController.text,
      'startDatetime': DateTime.now().toIso8601String(),
      'spacedRep': 0,
      'number': idCardNumberTextController.text,
      'expiration': idCardExpirationTextController.text,
      'other': idCardOtherTextController.text,
      'spacedRepetitionType': spacedRepetitionChoice,
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
