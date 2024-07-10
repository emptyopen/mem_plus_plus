import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class EditCardDialog extends StatefulWidget {
  final dynamic entry;
  final String activityKey;
  final bool isThreeItems;
  final Function saveItem;
  final String initialObjectText;
  final String initialPersonText;
  final String initialActionText;

  const EditCardDialog({
    required this.entry,
    required this.activityKey,
    required this.isThreeItems,
    required this.saveItem,
    required this.initialObjectText,
    required this.initialPersonText,
    required this.initialActionText,
    Key? key,
  }) : super(key: key);

  @override
  State<EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<EditCardDialog> {
  final personTextController = TextEditingController();
  final actionTextController = TextEditingController();
  final objectTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    personTextController.text = widget.initialPersonText;
    actionTextController.text = widget.initialActionText;
    objectTextController.text = widget.initialObjectText;
  }

  @override
  void dispose() {
    personTextController.dispose();
    actionTextController.dispose();
    objectTextController.dispose();
    super.dispose();
  }

  getTitle() {
    if (widget.activityKey == singleDigitKey) {
      return Text(
        'Digit: ${widget.entry.digits}',
        style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
      );
    } else if (widget.activityKey == alphabetKey) {
      return Text(
        'Letter: ${widget.entry.letter}',
        style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
      );
    } else if (widget.activityKey == paoKey) {
      return Text(
        'Digits: ${widget.entry.digits}',
        style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
      );
    } else if (widget.activityKey == deckKey) {
      return Text(
        'Card: ${widget.entry.digitSuit}',
        style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
      );
    } else if (widget.activityKey == tripleDigitKey) {
      return Text(
        'Card: ${widget.entry.digits}',
        style: TextStyle(fontSize: 24, color: backgroundHighlightColor),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: backgroundHighlightColor),
          borderRadius: BorderRadius.circular(5),
        ),
        width: 300.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              getTitle(),
              SizedBox(height: 10),
              widget.isThreeItems
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Person',
                            style: TextStyle(
                                fontSize: 20, color: backgroundHighlightColor),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: backgroundColor),
                          height: 40,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            style: TextStyle(color: backgroundHighlightColor),
                            textAlign: TextAlign.center,
                            controller: personTextController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundSemiHighlightColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor)),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                              hintText: '${widget.entry.person}',
                              hintStyle: TextStyle(
                                color:
                                    backgroundSemiHighlightColor.withAlpha(100),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Action',
                            style: TextStyle(
                                fontSize: 20, color: backgroundHighlightColor),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: backgroundColor),
                          height: 40,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            style: TextStyle(color: backgroundHighlightColor),
                            textAlign: TextAlign.center,
                            controller: actionTextController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundSemiHighlightColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor)),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                              hintText: '${widget.entry.action}',
                              hintStyle: TextStyle(
                                color:
                                    backgroundSemiHighlightColor.withAlpha(100),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'Object',
                  style:
                      TextStyle(fontSize: 20, color: backgroundHighlightColor),
                ),
              ),
              Container(
                height: 40,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  style: TextStyle(color: backgroundHighlightColor),
                  textAlign: TextAlign.center,
                  controller: objectTextController,
                  onSubmitted: (s) {
                    widget.saveItem();
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundSemiHighlightColor)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: backgroundHighlightColor)),
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: '${widget.entry.object}',
                    hintStyle: TextStyle(
                      color: backgroundSemiHighlightColor.withAlpha(100),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              widget.activityKey == singleDigitKey
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.lightbulbOnOutline,
                          size: 18,
                          color: Colors.amber.withAlpha(150),
                        ),
                        SizedBox(width: 10),
                        Text(
                          singleDigitSuggestions[widget.entry.index],
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              widget.activityKey == alphabetKey
                  ? Text(
                      alphabetSuggestions[widget.entry.index],
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  : Container(),
              SizedBox(height: 10),
              BasicFlatButton(
                text: 'Save',
                fontSize: 18,
                onPressed: () => widget.saveItem(
                  personText: personTextController.text,
                  actionText: actionTextController.text,
                  objectText: objectTextController.text,
                ),
                color: Colors.grey[200]!,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
