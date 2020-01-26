import 'package:flutter/material.dart';
import 'pao_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PAOEditCard extends StatefulWidget {
  final PAOData paoData;
  final Function(List<PAOData>) callback;

  PAOEditCard({this.paoData, this.callback});

  @override
  _PAOEditCardState createState() => _PAOEditCardState();
}

class _PAOEditCardState extends State<PAOEditCard> {
  final personTextController = TextEditingController();
  final actionTextController = TextEditingController();
  final objectTextController = TextEditingController();
  final String paoKey = 'pao';
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
    personTextController.dispose();
    actionTextController.dispose();
    objectTextController.dispose();
    super.dispose();
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
                  hintText: '${widget.paoData.person}',
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
                  hintText: '${widget.paoData.action}'),
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
                  hintText: '${widget.paoData.object}'),
              ),
            ),
            Container(
              width: 5,
              height: 10,
            ),
            FlatButton(
              onPressed: () async {
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                var paoData = (json.decode(prefs.getString(paoKey)) as List)
                  .map((i) => PAOData.fromJson(i))
                  .toList();
                int currIndex = int.parse(widget.paoData.digits);
                PAOData updatedPAOEntry = paoData[currIndex];
                bool resetFamiliarity = false;
                if (personTextController.text != '') {
                  updatedPAOEntry.person = personTextController.text;
                  resetFamiliarity = true;
                  personTextController.text = '';
                }
                if (actionTextController.text != '') {
                  updatedPAOEntry.action = actionTextController.text;
                  resetFamiliarity = true;
                  actionTextController.text = '';
                }
                if (objectTextController.text != '') {
                  updatedPAOEntry.object = objectTextController.text;
                  resetFamiliarity = true;
                  objectTextController.text = '';
                }
                print(
                  'will update $currIndex to: ${updatedPAOEntry.person} | ${updatedPAOEntry.action} | ${updatedPAOEntry.object}');
                if (resetFamiliarity) {
                  print('will reset fam');
                  //updatedPAOEntry.familiarity = 0;
                }
                paoData[currIndex] = updatedPAOEntry;
                prefs.setString(paoKey, json.encode(paoData));
                widget.callback(paoData);
                Navigator.of(context).pop();
              },
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
      return Colors.grey;
    }

    return Center(
      child: Card(
        child: Stack(
          children: <Widget>[
            // TODO add overlay of familiarity somewhere
            ListTile(
              leading: Text(
                '${widget.paoData.digits}',
                style: TextStyle(fontSize: 26),
              ),
              title: Text('${widget.paoData.person}',
                style: TextStyle(fontSize: 20)),
              subtitle: Text(
                '${widget.paoData.action} • ${widget.paoData.object}',
                style: TextStyle(fontSize: 16),
              ),
              trailing: FlatButton(
                child: Text('Edit', style: TextStyle(color: Colors.cyan)),
                onPressed: () {
                  showDialog(context: context, child: dialog);
                }),
            ),
            Positioned(
              child: Container(
                child: Center(
                  child: Text(
                    '${widget.paoData.familiarity}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                      getColorFromFamiliarity(widget.paoData.familiarity)),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey, width: 0.5)),
                height: 25,
                width: 25,
              ),
              right: 8,
              bottom: 22,
            )
          ],
        )),
    );
  }
}