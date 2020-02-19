import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/keys.dart';

class EditCard extends StatefulWidget {
  final dynamic entry;
  final String activityKey;
  final Function callback;

  EditCard({this.entry, this.activityKey, this.callback});

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  final personTextController = TextEditingController();
  final actionTextController = TextEditingController();
  final objectTextController = TextEditingController();
  final prefs = PrefsUpdater();
  bool isPAO = false;
  String leading = '';
  Dialog dialog;

  @override
  void initState() {
    super.initState();

    switch (widget.activityKey) {
      case singleDigitKey:
        leading = '${widget.entry.digits}';
        objectTextController.text = widget.entry.object;
        break;
      case alphabetKey:
        leading = '${widget.entry.letter}';
        objectTextController.text = widget.entry.object;
        break;
      case paoKey:
        leading = '${widget.entry.digits}';
        personTextController.text = widget.entry.person;
        actionTextController.text = widget.entry.action;
        objectTextController.text = widget.entry.object;
        isPAO = true;
        break;
    }

    dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        decoration: BoxDecoration(color: backgroundColor),
        height: widget.activityKey == paoKey ? 350.0 : 200,
        width: 300.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              isPAO
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Person',
                            style: TextStyle(fontSize: 20, color: backgroundHighlightColor),
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
                                  borderSide:
                                      BorderSide(color: backgroundSemiColor)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor)),
                              contentPadding: EdgeInsets.all(5),
                              border: OutlineInputBorder(),
                              hintText: '${widget.entry.person}',
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
                                    borderSide:
                                        BorderSide(color: backgroundSemiColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: backgroundHighlightColor)),
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                hintText: '${widget.entry.action}'),
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
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: backgroundSemiColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: backgroundHighlightColor)),
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: '${widget.entry.object}'),
                ),
              ),
              SizedBox(height: 10),
              BasicFlatButton(
                text: 'Save',
                fontSize: 18,
                onPressed: () => saveItem(),
                color: Colors.grey[200],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
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
      leading: Text(
        leading,
        style: TextStyle(fontSize: 26, color: backgroundHighlightColor),
      ),
      title: isPAO
          ? Text('${widget.entry.person}',
              style: TextStyle(fontSize: 20, color: backgroundHighlightColor))
          : Text('${widget.entry.object}',
              style: TextStyle(fontSize: 20, color: backgroundHighlightColor)),
      subtitle: isPAO
          ? Text(
              '${widget.entry.action} • ${widget.entry.object}',
              style: TextStyle(fontSize: 16, color: backgroundHighlightColor),
            )
          : Container(),
      trailing: Container(
          width: 100,
          child: BasicFlatButton(
            text: 'Edit',
            color: Colors.grey[300],
            onPressed: () {
              showDialog(context: context, child: dialog);
            },
            fontSize: 18,
          )),
    );
  }

  void saveItem() async {
    List<dynamic> data = await prefs.getSharedPrefs(widget.activityKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];

    if (widget.activityKey == paoKey) {
      bool resetFamiliarity = false;
      if (personTextController.text != '') {
        updatedEntry.person = personTextController.text.trim();
        resetFamiliarity = true;
      }
      if (actionTextController.text != '') {
        updatedEntry.action = actionTextController.text.trim();
        resetFamiliarity = true;
      }
      if (objectTextController.text != '') {
        updatedEntry.object = objectTextController.text.trim();
        resetFamiliarity = true;
      }
      if (resetFamiliarity) {
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      await prefs.writeSharedPrefs(widget.activityKey, data);
    } else {
      if (objectTextController.text != '') {
        updatedEntry.object = objectTextController.text.trim();
        updatedEntry.familiarity = 0;
      }
      data[currIndex] = updatedEntry;
      await prefs.writeSharedPrefs(widget.activityKey, data);
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
