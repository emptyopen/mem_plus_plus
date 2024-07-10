import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/components/templates/edit_card_dialog.dart';
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
  PrefsUpdater prefs = PrefsUpdater();
  bool isThreeItems = false;
  Widget leading = Container();
  late List<dynamic> data;
  String objectText = '';
  String personText = '';
  String actionText = '';

  @override
  void dispose() {
    // TODO: this is disposing on hit of the text box
    print('disposing...');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    switch (widget.activityKey) {
      case singleDigitKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        objectText = widget.entry.object;
        break;
      case alphabetKey:
        leading = Text(
          '${widget.entry.letter}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        objectText = widget.entry.object;
        break;
      case paoKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        personText = widget.entry.person;
        actionText = widget.entry.action;
        objectText = widget.entry.object;
        isThreeItems = true;
        break;
      case deckKey:
        leading = getDeckCard(widget.entry.digitSuit, 'small');
        personText = widget.entry.person;
        actionText = widget.entry.action;
        objectText = widget.entry.object;
        isThreeItems = true;
        break;
      case tripleDigitKey:
        leading = Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
        );
        personText = widget.entry.person;
        actionText = widget.entry.action;
        objectText = widget.entry.object;
        isThreeItems = true;
        break;
    }
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
                    return EditCardDialog(
                      entry: widget.entry,
                      activityKey: widget.activityKey,
                      isThreeItems: isThreeItems,
                      saveItem: saveItem,
                      initialObjectText: objectText,
                      initialPersonText: personText,
                      initialActionText: actionText,
                    );
                  });
            },
            fontSize: 18,
          )),
    );
  }

  void saveItem({personText = '', actionText = '', objectText = ''}) {
    data = prefs.getSharedPrefs(widget.activityKey) as List;
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];

    if (widget.activityKey == paoKey) {
      bool resetFamiliarity = false;
      if (personText != '' && updatedEntry.person != personText.trim()) {
        updatedEntry.person = personText.trim();
        resetFamiliarity = true;
      }
      if (actionText != '' && updatedEntry.action != actionText.trim()) {
        updatedEntry.action = actionText.trim();
        resetFamiliarity = true;
      }
      if (objectText != '' && updatedEntry.object != objectText.trim()) {
        updatedEntry.object = objectText.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else if (widget.activityKey == deckKey) {
      bool resetFamiliarity = false;
      if (personText != '' && updatedEntry.person != personText.trim()) {
        updatedEntry.person = personText.trim();
        resetFamiliarity = true;
      }
      if (actionText != '' && updatedEntry.action != actionText.trim()) {
        updatedEntry.action = actionText.trim();
        resetFamiliarity = true;
      }
      if (objectText != '' && updatedEntry.object != objectText.trim()) {
        updatedEntry.object = objectText.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else if (widget.activityKey == tripleDigitKey) {
      bool resetFamiliarity = false;
      if (personText != '' && updatedEntry.person != personText.trim()) {
        updatedEntry.person = personText.trim();
        resetFamiliarity = true;
      }
      if (actionText != '' && updatedEntry.action != actionText.trim()) {
        updatedEntry.action = actionText.trim();
        resetFamiliarity = true;
      }
      if (objectText != '' && updatedEntry.object != objectText.trim()) {
        updatedEntry.object = objectText.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      prefs.writeSharedPrefs(widget.activityKey, data);
    } else {
      if (objectText != '' && updatedEntry.object != objectText.trim()) {
        updatedEntry.object = objectText.trim();
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
                    color: getColorFromFamiliarity(widget.entry.familiarity),
                    width: 2,
                  ),
                ),
                height: 25,
                width: 40,
              ),
              right: 2,
              top: 5,
            )
          ],
        ),
      ),
    );
  }
}
