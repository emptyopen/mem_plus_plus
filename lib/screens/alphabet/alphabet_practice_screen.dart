import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_data.dart';
import 'package:mem_plus_plus/components/alphabet/alphabet_flash_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';

class AlphabetPracticeScreen extends StatefulWidget {
  final Function() callback;

  AlphabetPracticeScreen({this.callback});

  @override
  _AlphabetPracticeScreenState createState() => _AlphabetPracticeScreenState();
}

class _AlphabetPracticeScreenState extends State<AlphabetPracticeScreen> {
  SharedPreferences sharedPreferences;
  List<AlphabetData> alphabetData;
  String alphabetKey = 'Alphabet';

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();
    prefs.checkFirstTime(context, 'AlphabetPracticeFirstHelp', AlphabetPracticeScreenHelp());
    alphabetData = await prefs.getSharedPrefs(alphabetKey);
    alphabetData = shuffle(alphabetData);
    setState(() {});
  }

  callback() {
    widget.callback();
  }

  List<AlphabetFlashCard> getAlphabetFlashCards() {
    List<AlphabetFlashCard> alphabetFlashCards = [];
    if (alphabetData != null) {
      for (int i = 0; i < alphabetData.length; i++) {
        AlphabetFlashCard alphabetFlashCard = AlphabetFlashCard(
          alphabetEntry: alphabetData[i],
          callback: callback,
        );
        alphabetFlashCards.add(alphabetFlashCard);
      }
    }
    return alphabetFlashCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alphabet: practice'),
        backgroundColor: Colors.blue[200],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) {
                    return AlphabetPracticeScreenHelp();
                  }));
            },
          ),
        ],
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop('test'),
        ),
      ),
      body: Center(
          child: ListView(
        children: getAlphabetFlashCards(),
      )),
    );
  }
}

class AlphabetPracticeScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Alphabet Practice',
      information: [
        '    You know the drill, get cracking :) ',
      ],
    );
  }
}
