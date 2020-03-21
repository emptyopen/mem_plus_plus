import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AirportTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AirportTimedTestScreen({this.callback, this.globalKey});

  @override
  _AirportTimedTestScreenState createState() => _AirportTimedTestScreenState();
}

class _AirportTimedTestScreenState extends State<AirportTimedTestScreen> {
  final confirmationCodeController = TextEditingController();
  final flightCodeController = TextEditingController();
  final seatNumberController = TextEditingController();
  final gateNumberController = TextEditingController();
  final departureTimeController = TextEditingController();
  final departingTerminalController = TextEditingController();
  final arrivingTerminalController = TextEditingController();
  String confirmationCode = '';
  String flightCode = '';
  String seatNumber = '';
  String gateNumber = '';
  String departureTime = '';
  String departingTerminal = '';
  String arrivingTerminal = '';
  String airportFont = 'Quicksand';
  bool showError = false;
  bool isLoaded = false;
  PrefsUpdater prefs = PrefsUpdater();

  @override
  void dispose() {
    confirmationCodeController.dispose();
    flightCodeController.dispose();
    seatNumberController.dispose();
    gateNumberController.dispose();
    departureTimeController.dispose();
    departingTerminalController.dispose();
    arrivingTerminalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    prefs.checkFirstTime(
        context, airportTimedTestFirstHelpKey, AirportTimedTestScreenHelp());
    // grab the digits
    departingTerminal = await prefs.getString('airportDepartingTerminal');
    flightCode = await prefs.getString('airportFlightCode');
    departureTime = await prefs.getString('airportFlightTime');
    confirmationCode = await prefs.getString('airportConfirmationCode');
    seatNumber = await prefs.getString('airportSeatNumber');
    gateNumber = await prefs.getString('airportGateNumber');
    arrivingTerminal = await prefs.getString('airportArrivingTerminal');
    print(
        'real answer: $departingTerminal $confirmationCode $departureTime $gateNumber  $flightCode $seatNumber $arrivingTerminal');
    isLoaded = true;
    setState(() {});
  }

  void checkAnswer() async {
    setState(() {
      showError = false;
    });
    HapticFeedback.heavyImpact();
    if (confirmationCodeController.text == '' ||
        flightCodeController.text == '' ||
        seatNumberController.text == '' ||
        gateNumberController.text == '' ||
        departureTimeController.text == '' ||
        departingTerminalController.text == '' ||
        arrivingTerminalController.text == '') {
      setState(() {
        showError = true;
      });
      return;
    }
    if (confirmationCodeController.text.trim().toLowerCase().replaceAll(' ', '') == confirmationCode.toLowerCase() &&
        flightCodeController.text.trim().toLowerCase().replaceAll('-', '').replaceAll(' ', '') == flightCode.toLowerCase().replaceAll('-', '') &&
        seatNumberController.text.trim().toLowerCase().replaceAll(' ', '') == seatNumber.toLowerCase() &&
        gateNumberController.text.trim().toLowerCase().replaceAll(' ', '') == gateNumber.toLowerCase() &&
        departureTimeController.text.trim().toLowerCase().replaceAll(':', '').replaceAll(' ', '') == departureTime.toLowerCase().replaceAll(':', '') &&
        departingTerminalController.text.trim().toLowerCase().replaceAll(' ', '') == departingTerminal.toLowerCase() &&
        arrivingTerminalController.text.trim().toLowerCase().replaceAll(' ', '') == arrivingTerminal.toLowerCase()) {
      await prefs.updateActivityVisible(airportTimedTestKey, false);
      await prefs.updateActivityVisible(airportTimedTestPrepKey, true);
      if (await prefs.getBool(airportTimedTestCompleteKey) == null) {
        await prefs.setBool(airportTimedTestCompleteKey, true);
        await prefs.updateActivityState(airportTimedTestKey, 'review');
        if (await prefs.getBool(phoneticAlphabetTimedTestCompleteKey) == null) {
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Awesome job! Complete the Phonetic Alphabet & Morse test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter2Darker,
            durationSeconds: 3,
          );
        } else {
          await prefs.updateActivityVisible(paoEditKey, true);
          showSnackBar(
            scaffoldState: widget.globalKey.currentState,
            snackBarText:
                'Congratulations! You\'ve unlocked the PAO system!',
            textColor: Colors.white,
            backgroundColor: colorPAODarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          scaffoldState: widget.globalKey.currentState,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter2Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText:
            'Incorrect. Keep trying to remember, or give up and try again!',
        textColor: Colors.black,
        backgroundColor: colorIncorrect,
        durationSeconds: 3,
      );
    }
    confirmationCodeController.text = '';
    flightCodeController.text = '';
    seatNumberController.text = '';
    departureTimeController.text = '';
    departingTerminalController.text = '';
    arrivingTerminalController.text = '';
    widget.callback();
    Navigator.pop(context);
  }

  void giveUp() async {
    HapticFeedback.heavyImpact();
    await prefs.updateActivityState(airportTimedTestKey, 'review');
    await prefs.updateActivityVisible(airportTimedTestKey, false);
    await prefs.updateActivityVisible(airportTimedTestPrepKey, true);
    if (await prefs.getBool(airportTimedTestCompleteKey) == null) {
      await prefs.updateActivityState(airportTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        scaffoldState: widget.globalKey.currentState,
        snackBarText: 'Head back to test prep to try again!',
        textColor: Colors.white,
        backgroundColor: colorIncorrect,
        durationSeconds: 3);
    Navigator.pop(context);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Airport: timed test'),
          backgroundColor: colorChapter2Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.heavyImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AirportTimedTestScreenHelp();
                    }));
              },
            ),
          ]),
      body: isLoaded
          ? Container(
              width: screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Go to departing terminal:',
                          style: TextStyle(
                            fontSize: 18,
                            color: backgroundHighlightColor,
                            fontFamily: airportFont,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: departingTerminalController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: airportFont,
                              color: backgroundHighlightColor,
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                hintText: 'X',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontFamily: airportFont,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Check-in confirmation code:',
                          style: TextStyle(
                            fontSize: 18,
                            color: backgroundHighlightColor,
                            fontFamily: airportFont,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: confirmationCodeController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: airportFont,
                              color: backgroundHighlightColor,
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                hintText: 'XXXXXX',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontFamily: airportFont,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Leaving at / from gate number:',
                          style: TextStyle(
                            fontSize: 18,
                            color: backgroundHighlightColor,
                            fontFamily: airportFont,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                controller: departureTimeController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: airportFont,
                                  color: backgroundHighlightColor,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: backgroundHighlightColor),
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(),
                                    hintText: 'XX : XX',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontFamily: airportFont,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                controller: gateNumberController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: airportFont,
                                  color: backgroundHighlightColor,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: backgroundHighlightColor),
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(),
                                    hintText: 'XX',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontFamily: airportFont,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Flight code & seat number:',
                          style: TextStyle(
                            fontSize: 18,
                            color: backgroundHighlightColor,
                            fontFamily: airportFont,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                controller: flightCodeController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: airportFont,
                                  color: backgroundHighlightColor,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: backgroundHighlightColor),
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(),
                                    hintText: 'XXXXXX',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontFamily: airportFont,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: TextFormField(
                                controller: seatNumberController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: airportFont,
                                  color: backgroundHighlightColor,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.grey,
                                    )),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: backgroundHighlightColor),
                                    ),
                                    contentPadding: EdgeInsets.all(5),
                                    border: OutlineInputBorder(),
                                    hintText: 'XXX',
                                    hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                      fontFamily: airportFont,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Arriving at terminal:',
                          style: TextStyle(
                            fontSize: 18,
                            color: backgroundHighlightColor,
                            fontFamily: airportFont,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Container(
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: TextFormField(
                            controller: arrivingTerminalController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: airportFont,
                              color: backgroundHighlightColor,
                            ),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: backgroundHighlightColor),
                                ),
                                contentPadding: EdgeInsets.all(5),
                                border: OutlineInputBorder(),
                                hintText: 'X',
                                hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey,
                                  fontFamily: airportFont,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BasicFlatButton(
                          text: 'Give up',
                          fontSize: 24,
                          color: Colors.grey[200],
                          splashColor: Colors.blue,
                          onPressed: () => giveUp(),
                          padding: 10,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        BasicFlatButton(
                          text: 'Submit',
                          fontSize: 24,
                          color: colorChapter2Standard,
                          splashColor: colorChapter2Darker,
                          onPressed: () => checkAnswer(),
                          padding: 10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

class AirportTimedTestScreenHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Airport Timed Test',
      information: [
        '    Time to recall your scenes! Remember how you anchored and/or linked your scenes first! Good luck!'
            '\n\n    By the way, when inputting the departure time you can just enter it with numbers, or include the colon if you like. '
      ],
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: airportTimedTestFirstHelpKey,
    );
  }
}
