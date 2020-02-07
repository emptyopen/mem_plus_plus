import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';

class AlphabetEditCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function(List<AlphabetData>) callback;

  AlphabetEditCard({this.alphabetData, this.callback});

  @override
  _AlphabetEditCardState createState() => _AlphabetEditCardState();
}

class _AlphabetEditCardState extends State<AlphabetEditCard> {
  final objectTextController = TextEditingController();
  final String alphabetKey = 'Alphabet';
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
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
                    hintText: '${widget.alphabetData.object}'),
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
                  var alphabetData =
                      (json.decode(prefs.getString(alphabetKey)) as List)
                          .map((i) => AlphabetData.fromJson(i))
                          .toList();
                  int currIndex = widget.alphabetData.index;
                  AlphabetData updatedAlphabetEntry =
                      alphabetData[currIndex];
                  if (objectTextController.text != '') {
                    updatedAlphabetEntry.object = objectTextController.text;
                    updatedAlphabetEntry.familiarity = 0;
                    objectTextController.text = '';
                  }
                  alphabetData[currIndex] = updatedAlphabetEntry;
                  prefs.setString(alphabetKey, json.encode(alphabetData));
                  widget.callback(alphabetData);
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
          ListTile(
            leading: Text(
              '${widget.alphabetData.letter}',
              style: TextStyle(fontSize: 26),
            ),
            title: Text('${widget.alphabetData.object}',
                style: TextStyle(fontSize: 20)),
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
                  '${widget.alphabetData.familiarity}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: getColorFromFamiliarity(
                          widget.alphabetData.familiarity)),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: Colors.grey, width: 0.5)),
              height: 25,
              width: 25,
            ),
            right: 8,
            bottom: 15,
          )
        ],
      )),
    );
  }
}
