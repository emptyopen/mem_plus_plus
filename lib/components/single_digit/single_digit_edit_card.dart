import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/single_digit/single_digit_data.dart';
import 'package:mem_plus_plus/services/services.dart';

class SingleDigitEditCard extends StatefulWidget {
  final SingleDigitData singleDigitData;
  final Function(List<SingleDigitData>) callback;

  SingleDigitEditCard({this.singleDigitData, this.callback});

  @override
  _SingleDigitEditCardState createState() => _SingleDigitEditCardState();
}

class _SingleDigitEditCardState extends State<SingleDigitEditCard> {
  final objectTextController = TextEditingController();
  final String singleDigitKey = 'SingleDigit';
  final prefs = PrefsUpdater();

  @override
  void dispose() {
    objectTextController.dispose();
    super.dispose();
  }

  void saveItem() async {
    List<SingleDigitData> singleDigitData = await prefs.getSharedPrefs(singleDigitKey);
    int currIndex = int.parse(widget.singleDigitData.digits);
    SingleDigitData updatedSingleDigitEntry =
    singleDigitData[currIndex];
    if (objectTextController.text != '') {
      updatedSingleDigitEntry.object = objectTextController.text;
      updatedSingleDigitEntry.familiarity = 0;
      objectTextController.text = '';
      print('will update $currIndex to: ${updatedSingleDigitEntry.object}');
    }
    singleDigitData[currIndex] = updatedSingleDigitEntry;
    await prefs.setString(singleDigitKey, json.encode(singleDigitData));
    widget.callback(singleDigitData);
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
              child: Text('Object for digit: ${widget.singleDigitData.digits}',
              style: TextStyle(fontSize: 24),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                textAlign: TextAlign.center,
                controller: objectTextController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    hintText: '${widget.singleDigitData.object}'),
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
              '${widget.singleDigitData.digits}',
              style: TextStyle(fontSize: 26),
            ),
            title: Text('${widget.singleDigitData.object}',
                style: TextStyle(fontSize: 20)),
            trailing: Container(
              width: 70,
              child: FlatButton(
                  child: Text('Edit', style: TextStyle(color: Colors.black)),
                  color: Colors.grey[200],
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
                  '${widget.singleDigitData.familiarity}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                      fontSize: 11),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: getColorFromFamiliarity(widget.singleDigitData.familiarity), width: 2)),
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
