import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardListener extends StatefulWidget {
  KeyboardListener();

  @override
  _RawKeyboardListenerState createState() => new _RawKeyboardListenerState();
}

class _RawKeyboardListenerState extends State<KeyboardListener> {
  TextEditingController _controller = new TextEditingController();
  FocusNode _textNode = new FocusNode();

  @override
  initState() {
    super.initState();
  }

  handleKey(RawKeyEventData key) {
    print('handling key ${key.keyLabel}');
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _textNode,
      onKey: (key) => handleKey(key.data),
      child: TextField(
        controller: _controller,
        focusNode: _textNode,
      ),
    );
  }
}
