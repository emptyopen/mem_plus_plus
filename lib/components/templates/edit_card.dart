import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';

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
  String leading = '';
  Dialog dialog;

  @override
  void initState() {
    super.initState();

    switch (widget.activityKey) {
      case 'SingleDigit':
        leading = '${widget.entry.digits}';
        objectTextController.text = widget.entry.object;
        break;
      case 'Alphabet':
        leading = '${widget.entry.letter}';
        objectTextController.text = widget.entry.object;
        break;
      case 'PAO':
        leading = '${widget.entry.digits}';
        personTextController.text = widget.entry.person;
        actionTextController.text = widget.entry.action;
        objectTextController.text = widget.entry.object;
        break;
    }

    if (widget.activityKey == 'PAO') {
      dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: Container(
          height: 350.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Person'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: personTextController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: '${widget.entry.person}',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Action'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: actionTextController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: '${widget.entry.action}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Object'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: objectTextController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: '${widget.entry.object}'),
                ),
              ),
              Container(
                width: 5,
                height: 10,
              ),
              FlatButton(
                  onPressed: () => saveItem(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ))
            ],
          ),
        ),
      );
    } else {
      dialog = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: Container(
          height: 350.0,
          width: 300.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Object'),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: objectTextController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(),
                      hintText: '${widget.entry.object}'),
                ),
              ),
              Container(
                width: 5,
                height: 10,
              ),
              FlatButton(
                  onPressed: () => saveItem(),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ))
            ],
          ),
        ),
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
    if (widget.activityKey == 'PAO') {
      return ListTile(
        leading: Text(
          '${widget.entry.digits}',
          style: TextStyle(fontSize: 26),
        ),
        title: Text('${widget.entry.person}', style: TextStyle(fontSize: 20)),
        subtitle: Text(
          '${widget.entry.action} • ${widget.entry.object}',
          style: TextStyle(fontSize: 16),
        ),
        trailing: Container(
          width: 100,
          child: FlatButton(
              child: Text('Edit',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  side: BorderSide(), borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                showDialog(context: context, child: dialog);
              }),
        ),
      );
    } else {
      return ListTile(
        leading: Text(
          leading,
          style: TextStyle(fontSize: 26),
        ),
        title: Text('${widget.entry.object}', style: TextStyle(fontSize: 20)),
        trailing: Container(
          width: 100,
          child: FlatButton(
              child: Text('Edit',
                  style: TextStyle(fontSize: 18, color: Colors.black)),
              color: Colors.grey[100],
              shape: RoundedRectangleBorder(
                  side: BorderSide(), borderRadius: BorderRadius.circular(5)),
              onPressed: () {
                showDialog(context: context, child: dialog);
              }),
        ),
      );
    }
  }

  void saveItem() async {
    List<dynamic> data = await prefs.getSharedPrefs(widget.activityKey);
    int currIndex = widget.entry.index;
    dynamic updatedEntry = data[currIndex];

    if (widget.activityKey == 'PAO') {
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
                      width: 2)),
              height: 25,
              width: 35,
            ),
            right: 2,
            top: 5,
          )
        ],
      )),
    );
  }
}
