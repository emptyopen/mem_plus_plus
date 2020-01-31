import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/pao/pao_data.dart';
import 'package:mem_plus_plus/components/pao/pao_edit_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:csv/csv.dart';
import 'package:mem_plus_plus/services/services.dart';

class PAOEditScreen extends StatefulWidget {
  PAOEditScreen({Key key}) : super(key: key);

  @override
  _PAOEditScreenState createState() => _PAOEditScreenState();
}

class _PAOEditScreenState extends State<PAOEditScreen> {
  SharedPreferences sharedPreferences;
  List<PAOData> paoData;
  String paoKey = 'PAO';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  callback(newPaoData) {
    setState(() {
      paoData = newPaoData;
    });
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    if (await prefs.getString(paoKey) == null) {
      paoData = defaultPAOData;
      await prefs.setString(paoKey, json.encode(paoData));
    } else {
      paoData = await prefs.getSharedPrefs(paoKey);
    }
    setState(() {});
  }

  List<PAOEditCard> getPAOEditCards() {
    List<PAOEditCard> paoEditCards = [];
    if (paoData != null) {
      for (int i = 0; i < paoData.length; i++) {
        PAOEditCard paoEditCard = PAOEditCard(
          paoData: PAOData(paoData[i].index, paoData[i].digits, paoData[i].person,
              paoData[i].action, paoData[i].object, paoData[i].familiarity),
          callback: callback,
        );
        paoEditCards.add(paoEditCard);
      }
    }
    return paoEditCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PAO: view/edit'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_downward),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return CSVImporter(
                    callback: callback
                  );
                }));
          },
        ),
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return ScreenHelp();
                }));
          },
        ),
      ]),
      body: Center(
          child: ListView(
        children: getPAOEditCards(),
      )),
    );
  }
}

class CSVImporter extends StatefulWidget {
  final Function callback;

  CSVImporter({this.callback});

  @override
  _CSVImporterState createState() => _CSVImporterState();
}

class _CSVImporterState extends State<CSVImporter> {
  final textController = TextEditingController();

  updatePAOData(List<PAOData> paoDataList) async {
    var prefs = PrefsUpdater();
    prefs.writeSharedPrefs('PAO', paoDataList);
    widget.callback(paoDataList);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Column(
                        children: <Widget>[
                          Text(
                            '    Here you can upload CSV text to quickly update your PAO values!\n'
                            '    You can do this in Google Sheets very easily. You just need '
                            'a column for Person, Action, and Object (no need for headers). Then in a '
                            'new column, add to the top cell: ',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            '=concat(concat(concat(concat(XX,","),YY),","),ZZ)',
                            style: TextStyle(
                                fontSize: 10, fontFamily: 'SpaceMono'),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'where XX is the cell represting the person (in the same row), '
                              'YY=action cell, ZZ=object cell. Then just drag the formula down to the bottom, '
                              'copy that last column, and paste it here! ',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 350,
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Column(
                      children: <Widget>[
                        Text('Input below: ', style: TextStyle(fontSize: 20),),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                              hintText:
                                  'Ozzy Osbourne,rocking out a concert,rock guitar\n'
                                  'Orlando Bloom,walking the plank,eyepatch\n'
                                  '...',
                              hintStyle: TextStyle(fontSize: 15)),
                          controller: textController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 25,
                      ),
                      FlatButton(
                        color: Colors.amber[200],
                        shape: RoundedRectangleBorder(
                          side: BorderSide(),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {
                          var csvConverter = CsvToListConverter();
                          var l = csvConverter.convert(textController.text,
                              eol: '\n');
                          if (l.length == 100) {
                            List<PAOData> paoDataList = [];
                            l.asMap().forEach((k, v) {
                              paoDataList.add(
                                  PAOData(k, k.toString(), v[0], v[1], v[2], 0));
                            });
                            updatePAOData(paoDataList);
                            Navigator.pop(context);
                          }
                          //Navigator.pop(context);
                        },
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class ScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Color.fromRGBO(0, 0, 0, 0.7),
        child: Stack(
          children: <Widget>[
            Container(
              color: Colors.transparent,
              constraints: BoxConstraints.expand(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Text(
                        '    Welcome to the 3rd system here at Takao Studios :) \n\n'
                        '    PAO stands for Person Action Object. What this means is that for every digit '
                        '00, 01, 02, ..., 98, 99 we are going to assign a person, action, and object. Again, '
                        'you can assign any person, action, and object to any digit, but it\'s a good idea at first '
                        'to follow some kind of pattern. The person should be associated to its corresponding action and object, '
                        'and no two persons, actions, or objects should be too similar. As a starter pattern, we recommend '
                        'using an initials (OB = Orlando Bloom) pattern. \n    The initials pattern proposed in "Remember It!" by Nelsos Dellis has '
                        '0=O, 1=A, 2=B, 3=C, 4=D, 5=E, 6=S, 7=G, 8=H, and 9=N. Zeros are an exception because zeros look '
                        'like Os, and Fs and Is are pretty rare in names, so we use (S)ix and (N)ine instead. Using this pattern it becomes  '
                        'much easier to find famous people/fictional characters with initials like 12=AB=Antonio Banderas. \n'
                        '    This system allows us to memorize sequences of numbers very efficiently. Passport/license IDs, '
                        'phone numbers, order numbers, almost anything. The way it works is we break long sequences of numbers '
                        'into groups of 6, or three pairs of two digits, each pair corresponding to a person, action, and object. '
                        'For example, for the number 958417 we\'d break it down into 95-84-17, '
                        'which (under my personal system) corresponds to 95 (person) = Tom Brady, 84 (action) = riding a motorcycle, '
                        '17 (object) = giant boulder. So my visualized scene would be Tom Brady riding a motorcycle over '
                        'a bunch of giant boulders. \n'
                        '    This system should take a good amount of time setting up before you start trying to master it. Update '
                        'the PAO values for your digits until you\'re really happy with the list. Use people you know in real life, '
                        'famous celebrities, fictional characters... anyone! Just make sure everything is as unique as possible, '
                        'because overlap will make decoding more difficult. ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  PopButton(
                    widget: Text('OK'),
                    color: Colors.amber[300],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
