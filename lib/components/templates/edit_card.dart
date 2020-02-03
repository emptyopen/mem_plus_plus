import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mem_plus_plus/services/services.dart';

class EditCard extends StatefulWidget {
  final dynamic entry;
  final String activityKey;
  final Function(List<dynamic>) callback;

  EditCard({this.entry, this.activityKey, this.callback});

  @override
  _EditCardState createState() => _EditCardState();
}

class _EditCardState extends State<EditCard> {
  final objectTextController = TextEditingController();
  final prefs = PrefsUpdater();

  @override
  void dispose() {
    objectTextController.dispose();
    super.dispose();
  }

  void saveItem() async {
    List<dynamic> data = await prefs.getSharedPrefs(widget.activityKey);
    int currIndex = int.parse(widget.entry.digits);
    dynamic updatedEntry = data[currIndex];
    if (objectTextController.text != '') {
      updatedEntry.object = objectTextController.text;
      updatedEntry.familiarity = 0;
      objectTextController.text = '';
      print('will update $currIndex to: ${updatedEntry.object}');
    }
    data[currIndex] = updatedEntry;
    await prefs.setString(widget.activityKey, json.encode(data));
    widget.callback(data);
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    Dialog dialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
            ListTile(
              leading: Text(
                '${widget.entry.digits}',
                style: TextStyle(fontSize: 26),
              ),
              title: Text('${widget.entry.object}',
                style: TextStyle(fontSize: 20)),
              trailing: Container(
                width: 70,
                child: FlatButton(
                  child: Text('Edit', style: TextStyle(color: Colors.grey)),
                  color: Colors.grey[100],
                  shape: RoundedRectangleBorder(side: BorderSide(), borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    showDialog(context: context, child: dialog);
                  }),
              ),
            ),
            Positioned(
              child: Container(
                child: Center(
                  child: Text(
                    '${widget.entry.familiarity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: getColorFromFamiliarity(widget.entry.familiarity), width: 2)),
                height: 25,
                width: 25,
              ),
              right: 2,
              top: 5  ,
            )
          ],
        )),
    );
  }
}
