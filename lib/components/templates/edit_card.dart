import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';

import 'package:mem_plus_plus/constants/keys.dart';
import 'package:mem_plus_plus/components/data/deck_data.dart';

class EditCard extends StatefulWidget {
  final dynamic entry;
  final String activityKey;
  final Function callback;

  EditCard(
      {required this.entry, required this.activityKey, required this.callback});

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  final personTextController = TextEditingController();
  final actionTextController = TextEditingController();
  final objectTextController = TextEditingController();
  PrefsUpdater prefs = PrefsUpdater();
  bool isThreeItems = false;
  Widget leading = Container();
  late List<dynamic> data;

  @override
  void initState() {
    super.initState();

    switch (widget.activityKey) {
      case singleDigitKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        objectTextController.text = widget.entry.object;
        break;
      case alphabetKey:
        leading = Text(
          '${widget.entry.letter}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        objectTextController.text = widget.entry.object;
        break;
      case paoKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        personTextController.text = widget.entry.person;
        actionTextController.text = widget.entry.action;
        objectTextController.text = widget.entry.object;
        isThreeItems = true;
        break;
      case deckKey:
        leading = getDeckCard(widget.entry.digitSuit, 'small');
        personTextController.text = widget.entry.person;
        actionTextController.text = widget.entry.action;
        objectTextController.text = widget.entry.object;
        isThreeItems = true;
        break;
      case tripleDigitKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        personTextController.text = widget.entry.person;
        actionTextController.text = widget.entry.action;
        objectTextController.text = widget.entry.object;
        isThreeItems = true;
        break;
    }
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
  void dispose() {
    personTextController.dispose();
    actionTextController.dispose();
    objectTextController.dispose();
    super.dispose();
  }

  getListTile() {
    return ListTile(
      leading: leading,
      title: isThreeItems
          ? Text('${widget.entry.person}',
              style: TextStyle(fontSize: 20, color: backgroundHighlightColor))
          : Text('${widget.entry.object}',
              style: TextStyle(fontSize: 20, color: backgroundHighlightColor)),
      subtitle: isThreeItems
          ? Text(
              '${widget.entry.action} • ${widget.entry.object}',
              style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
            )
          : Container(),
      trailing: Container(
          width: 100,
          child: BasicFlatButton(
            text: 'Edit',
            color: Colors.grey[300]!,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border: Border.all(color: backgroundHighlightColor),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        // height: isThreeItems ? 320.0 : 240,
                        width: 300.0,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 20),
                              getTitle(),
                              SizedBox(height: 10),
                              isThreeItems
                                  ? Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Person',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    backgroundHighlightColor),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: backgroundColor),
                                          height: 40,
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: TextField(
                                            style: TextStyle(
                                                color:
                                                    backgroundHighlightColor),
                                            textAlign: TextAlign.center,
                                            controller: personTextController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          backgroundSemiHighlightColor)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          backgroundHighlightColor)),
                                              contentPadding: EdgeInsets.all(5),
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  '${widget.entry.person}',
                                              hintStyle: TextStyle(
                                                color:
                                                    backgroundSemiHighlightColor
                                                        .withAlpha(100),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            'Action',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color:
                                                    backgroundHighlightColor),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: backgroundColor),
                                          height: 40,
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 20, 0),
                                          child: TextField(
                                            style: TextStyle(
                                                color:
                                                    backgroundHighlightColor),
                                            textAlign: TextAlign.center,
                                            controller: actionTextController,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          backgroundSemiHighlightColor)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          backgroundHighlightColor)),
                                              contentPadding: EdgeInsets.all(5),
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  '${widget.entry.action}',
                                              hintStyle: TextStyle(
                                                color:
                                                    backgroundSemiHighlightColor
                                                        .withAlpha(100),
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
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: backgroundHighlightColor),
                                ),
                              ),
                              Container(
                                height: 40,
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: TextField(
                                  style: TextStyle(
                                      color: backgroundHighlightColor),
                                  textAlign: TextAlign.center,
                                  controller: objectTextController,
                                  onSubmitted: (s) {
                                    saveItem();
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                backgroundSemiHighlightColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: backgroundHighlightColor)),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(),
                                    hintText: '${widget.entry.object}',
                                    hintStyle: TextStyle(
                                      color: backgroundSemiHighlightColor
                                          .withAlpha(100),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              widget.activityKey == singleDigitKey
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          MdiIcons.lightbulbOnOutline,
                                          size: 18,
                                          color: Colors.amber.withAlpha(150),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          singleDigitSuggestions[
                                              widget.entry.index],
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
                                onPressed: () => saveItem(),
                                color: Colors.grey[200]!,
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            fontSize: 18,
          )),
    );
  }

  void saveItem() async {
    data = prefs.getSharedPrefs(widget.activityKey) as List;
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];

    if (widget.activityKey == paoKey) {
      bool resetFamiliarity = false;
      if (personTextController.text != '' &&
          updatedEntry.person != personTextController.text.trim()) {
        updatedEntry.person = personTextController.text.trim();
        resetFamiliarity = true;
      }
      if (actionTextController.text != '' &&
          updatedEntry.action != actionTextController.text.trim()) {
        updatedEntry.action = actionTextController.text.trim();
        resetFamiliarity = true;
      }
      if (objectTextController.text != '' &&
          updatedEntry.object != objectTextController.text.trim()) {
        updatedEntry.object = objectTextController.text.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else if (widget.activityKey == deckKey) {
      bool resetFamiliarity = false;
      if (personTextController.text != '' &&
          updatedEntry.person != personTextController.text.trim()) {
        updatedEntry.person = personTextController.text.trim();
        resetFamiliarity = true;
      }
      if (actionTextController.text != '' &&
          updatedEntry.action != actionTextController.text.trim()) {
        updatedEntry.action = actionTextController.text.trim();
        resetFamiliarity = true;
      }
      if (objectTextController.text != '' &&
          updatedEntry.object != objectTextController.text.trim()) {
        updatedEntry.object = objectTextController.text.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else if (widget.activityKey == tripleDigitKey) {
      bool resetFamiliarity = false;
      if (personTextController.text != '' &&
          updatedEntry.person != personTextController.text.trim()) {
        updatedEntry.person = personTextController.text.trim();
        resetFamiliarity = true;
      }
      if (actionTextController.text != '' &&
          updatedEntry.action != actionTextController.text.trim()) {
        updatedEntry.action = actionTextController.text.trim();
        resetFamiliarity = true;
      }
      if (objectTextController.text != '' &&
          updatedEntry.object != objectTextController.text.trim()) {
        updatedEntry.object = objectTextController.text.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else {
      if (objectTextController.text != '' &&
          updatedEntry.object != objectTextController.text.trim()) {
        updatedEntry.object = objectTextController.text.trim();
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    }
    widget.callback(data);
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    Color getColorFromFamiliarity(int familiarity) {
      if (familiarity < 25) {
        return Colors.red;
      } else if (familiarity < 50) {
        return Colors.orange;
      } else if (familiarity < 75) {
        return Colors.blue;
      } else if (familiarity < 100) {
        return Colors.green;
      }
      return Colors.black;
    }

    return Center(
      child: Card(
          color: backgroundSemiColor,
          child: Stack(
            children: <Widget>[
              getListTile(),
              Positioned(
                child: Container(
                  child: Center(
                    child: Text(
                      '${widget.entry.familiarity}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                          color:
                              getColorFromFamiliarity(widget.entry.familiarity),
                          width: 2)),
                  height: 25,
                  width: 40,
                ),
                right: 2,
                top: 5,
              )
            ],
          )),
    );
  }
}
