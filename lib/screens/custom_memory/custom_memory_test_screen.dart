import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/components/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';

String customMemoriesKey = 'CustomMemories';

class CustomMemoryTestScreen extends StatefulWidget {
  final Function callback;
  final Map customMemory;
  final Function callbackSnackbar;
  final GlobalKey<ScaffoldState> globalKey;

  CustomMemoryTestScreen({Key key, this.callback, this.customMemory, this.callbackSnackbar, this.globalKey})
      : super(key: key);

  @override
  _CustomMemoryTestScreenState createState() => _CustomMemoryTestScreenState();
}

class _CustomMemoryTestScreenState extends State<CustomMemoryTestScreen> {
  Map customMemories = {};
  var field1TextController = TextEditingController();
  var field2TextController = TextEditingController();
  var field3TextController = TextEditingController();
  var field4TextController = TextEditingController();
  var field5TextController = TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    print('real answer: ${widget.customMemory}');
  }

  @override
  void dispose() {
    field1TextController.dispose();
    field2TextController.dispose();
    field3TextController.dispose();
    field4TextController.dispose();
    field5TextController.dispose();
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    var prefs = PrefsUpdater();

    customMemories = await prefs.getSharedPrefs(customMemoriesKey);

    setState(() {});
  }

  checkResult(memory, success) async {
    var prefs = PrefsUpdater();
    if (success) {
      // check if beat the last level
      if (memory['spacedRepetitionLevel'] + 1 == termDurationsMap[memory['spacedRepetitionType']].length) {
        customMemories.remove(memory['title']);
        widget.callbackSnackbar('You\'ve completed this memory! Congratulations, you\'ve burned ${memory['title']} into your memory!', Colors.black, Colors.white, 10);
        Navigator.pop(context);
      } else {
        memory['spacedRepetitionLevel'] += 1;
        customMemories[memory['title']] = memory;
        widget.callbackSnackbar('Correct! Another test is coming... eventually!', Colors.black, Colors.greenAccent, 5);
        Navigator.pop(context);
      }
      await prefs.writeSharedPrefs(customMemoriesKey, customMemories);
      widget.callback();
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Incorrect!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.white,
      );
      globalKey.currentState.showSnackBar(snackBar);
    }
  }

  checkAnswer() async {
    var memory = widget.customMemory;
    switch (memory['type']) {
      case 'Contact':
        bool success = true;
        if (memory['birthday'] != '' && field1TextController.text != memory['birthday']) {
          success = false;
        }
        if (memory['phoneNumber'] != '' && field2TextController.text != memory['phoneNumber']) {
          success = false;
        }
        if (memory['address'] != '' && field3TextController.text != memory['address']) {
          success = false;
        }
        if (memory['other'] != '' && field4TextController.text != memory['other']) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'ID/Credit Card':
        bool success = true;
        if (memory['number'] != '' && field1TextController.text != memory['number']) {
          success = false;
        }
        if (memory['expiration'] != '' && field2TextController.text != memory['expiration']) {
          success = false;
        }
        if (memory['other'] != '' && field3TextController.text != memory['other']) {
          success = false;
        }
        checkResult(memory, success);
        break;
      case 'Other':
        bool success = true;
        if (memory['other1'] != '' && field1TextController.text != memory['other1']) {
          success = false;
        }
        if (memory['other2'] != '' && field2TextController.text != memory['other2']) {
          success = false;
        }
        if (memory['other3'] != '' && field3TextController.text != memory['other3']) {
          success = false;
        }
        checkResult(memory, success);
        break;
    }
  }

  Widget getTest() {
    var memory = widget.customMemory;
    switch (memory['type']) {
      case 'Contact':
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(memory['title'], style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              memory['birthday'] == '' ? Container() : PromptPair(
                title: 'Birthday:',
                textController: field1TextController,
              ),
              memory['phoneNumber'] == '' ? Container() : PromptPair(
                title: 'Phone number:',
                textController: field2TextController,
              ),
              memory['address'] == '' ? Container() : PromptPair(
                title: 'Address:',
                textController: field3TextController,
              ),
              memory['other'] == '' ? Container() : PromptPair(
                title: memory['otherField'] + ':',
                textController: field4TextController,
              ),
              BasicFlatButton(
                text: 'Submit',
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(height: 50,),
            ],
          ),
        );
      case 'ID/Credit Card':
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(memory['title'], style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              memory['number'] == '' ? Container() : PromptPair(
                title: 'Number:',
                textController: field1TextController,
              ),
              memory['expiration'] == '' ? Container() : PromptPair(
                title: 'Expiration:',
                textController: field2TextController,
              ),
              memory['other'] == '' ? Container() : PromptPair(
                title: memory['otherField'] + ':',
                textController: field3TextController,
              ),
              BasicFlatButton(
                text: 'Submit',
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(height: 50,),
            ],
          ),
        );
      default:
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(memory['title'], style: TextStyle(fontSize: 30),),
              SizedBox(height: 20,),
              memory['other1'] == '' ? Container() : PromptPair(
                title: memory['other1Field'] + ':',
                textController: field1TextController,
              ),
              memory['other2'] == '' ? Container() : PromptPair(
                title: memory['other2Field'] + ':',
                textController: field2TextController,
              ),
              memory['other3'] == '' ? Container() : PromptPair(
                title: memory['other3Field'] + ':',
                textController: field3TextController,
              ),
              BasicFlatButton(
                text: 'Submit',
                onPressed: () => checkAnswer(),
                color: Colors.purple[100],
                splashColor: Colors.purple[300],
                padding: 10,
              ),
              SizedBox(height: 50,),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: globalKey,
        appBar: AppBar(
            title: Text('Custom ${widget.customMemory['type']}: ${widget.customMemory['title']}'),
            backgroundColor: Colors.purple[200],
            actions: <Widget>[
              // action button
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) {
                        return CustomMemoryTestScreenHelp();
                      }));
                },
              ),
            ]),
        body: Center(
          child: getTest(),
        )
    );
  }
}

class PromptPair extends StatelessWidget {
  final String title;
  final TextEditingController textController;
  final double containerWidth;

  PromptPair({this.title, this.textController, this.containerWidth = 250});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(title, style: TextStyle(fontSize: 24)),
        Container(
          width: containerWidth,
          height: 30,
          child: TextField(
            textAlign: TextAlign.center,
            controller: textController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple))),
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}


class CustomMemoryTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Custom Memory Manager',
      information: [
        '    This is a custom memory test! Hope you put those scenes somewhere accessible!'
      ],
    );
  }
}

