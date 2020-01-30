import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class AlphabetWrittenCard extends StatefulWidget {
  final AlphabetData alphabetData;
  final Function(BuildContext, bool) callback;

  AlphabetWrittenCard({this.alphabetData, this.callback});

  @override
  _AlphabetWrittenCardState createState() => _AlphabetWrittenCardState();
}

class _AlphabetWrittenCardState extends State<AlphabetWrittenCard> {
  bool done = false;
  List<AlphabetData> alphabetDataList;
  String alphabetKey = 'Alphabet';
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alphabetDataList = (json.decode(prefs.getString(alphabetKey)) as List)
          .map((i) => AlphabetData.fromJson(i))
          .toList();
      alphabetDataList = shuffle(alphabetDataList);
    });
  }

  List shuffle(List items) {
    var random = new Random();
    for (var i = items.length - 1; i > 0; i--) {
      var n = random.nextInt(i + 1);
      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }
    return items;
  }

  void checkResult(int index) {
    if (widget.alphabetData.object == textController.text) {
      final snackBar = SnackBar(
        content: Text(
          'Correct!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        widget.callback(context, true);
        done = true;
      });
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect! ${widget.alphabetData.letter}: ${widget.alphabetData.object}',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[200],
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        widget.callback(context, false);
        done = true;
      });
    }
    textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return done
        ? Container()
        : Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                      child: Text(
                    widget.alphabetData.letter,
                    style: TextStyle(fontSize: 30),
                  )),
                ),
                Container(
                  width: 250,
                  child: TextField(
                    style: TextStyle(fontSize: 22),
                      controller: textController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(5),
                        border: OutlineInputBorder(),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: FlatButton(
                    onPressed: () => checkResult(0),
                    child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Text('Submit')),
                  ),
                ),
              ],
            ));
  }
}
