import 'package:flutter/material.dart';

class MemoryField {
  String text;
  String mapKey;
  TextEditingController controller;
  TextEditingController? fieldController;
  bool required;
  String inputType;

  MemoryField(
      {required this.text,
      required this.mapKey,
      required this.controller,
      this.fieldController,
      required this.required,
      required this.inputType});
}
