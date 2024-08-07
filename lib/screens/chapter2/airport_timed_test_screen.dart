import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard/basic_flat_button.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'package:mem_plus_plus/screens/templates/help_dialog.dart';

import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';

class AirportTimedTestScreen extends StatefulWidget {
  final Function() callback;
  final GlobalKey<ScaffoldState> globalKey;

  AirportTimedTestScreen({required this.callback, required this.globalKey});

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

  getSharedPrefs() {
    prefs.checkFirstTime(context, airportTimedTestFirstHelpKey,
        AirportTimedTestScreenHelp(callback: widget.callback));
    // grab the digits
    departingTerminal = (prefs.getString('airportDepartingTerminal'));
    flightCode = (prefs.getString('airportFlightCode'));
    departureTime = (prefs.getString('airportFlightTime'));
    confirmationCode = (prefs.getString('airportConfirmationCode'));
    seatNumber = (prefs.getString('airportSeatNumber'));
    gateNumber = (prefs.getString('airportGateNumber'));
    arrivingTerminal = (prefs.getString('airportArrivingTerminal'));
    print(
        'real answer: $departingTerminal $confirmationCode $departureTime $gateNumber  $flightCode $seatNumber $arrivingTerminal');
    isLoaded = true;
    setState(() {});
  }

  checkAnswer() {
    setState(() {
      showError = false;
    });
    HapticFeedback.lightImpact();
    if (confirmationCodeController.text == '' ||
            flightCodeController.text == '' ||
            // seatNumberController.text == '' ||
            // gateNumberController.text == '' ||
            departureTimeController.text == '' ||
            departingTerminalController.text == ''
        // arrivingTerminalController.text == '') {
        ) {
      setState(() {
        showError = true;
      });
      return;
    }
    bool confirmationCodeCorrect = confirmationCodeController.text
            .trim()
            .toLowerCase()
            .replaceAll(' ', '') ==
        confirmationCode.toLowerCase();
    bool flightCodeCorrect = flightCodeController.text
            .trim()
            .toLowerCase()
            .replaceAll('-', '')
            .replaceAll(' ', '') ==
        flightCode.toLowerCase().replaceAll('-', '');
    bool departureTimeCorrect =
        int.parse(departureTimeController.text.replaceAll(RegExp(r'\D'), '')) ==
            int.parse(departureTime.replaceAll(RegExp(r'\D'), ''));
    bool departingTerminalCorrect = departingTerminalController.text
            .trim()
            .toLowerCase()
            .replaceAll(' ', '') ==
        departingTerminal.toLowerCase();
    // bool seatNumberCorrect = seatNumberController.text.trim().toLowerCase().replaceAll(' ', '') == seatNumber.toLowerCase();
    // bool gateNumberCorrect = gateNumberController.text.trim().toLowerCase().replaceAll(' ', '') == gateNumber.toLowerCase();
    // bool arrivingTerminalCorrect = arrivingTerminalController.text
    //         .trim()
    //         .toLowerCase()
    //         .replaceAll(' ', '') ==
    //     arrivingTerminal.toLowerCase();
    if (confirmationCodeCorrect &&
        flightCodeCorrect &&
        //  seatNumberCorrect &&
        // gateNumberCorrect &&
        // arrivingTerminalCorrect &&
        departureTimeCorrect &&
        departingTerminalCorrect) {
      prefs.updateActivityVisible(airportTimedTestKey, false);
      prefs.updateActivityVisible(airportTimedTestPrepKey, true);
      if (!prefs.getBool(airportTimedTestCompleteKey)) {
        prefs.setBool(airportTimedTestCompleteKey, true);
        prefs.updateActivityState(airportTimedTestKey, 'review');
        if (!prefs.getBool(phoneticAlphabetTimedTestCompleteKey)) {
          showSnackBar(
            context: context,
            snackBarText:
                'Awesome job! Complete the Phonetic Alphabet & Morse test to unlock the next system!',
            textColor: Colors.black,
            backgroundColor: colorChapter2Darker,
            durationSeconds: 3,
          );
        } else {
          prefs.updateActivityVisible(paoEditKey, true);
          showSnackBar(
            context: context,
            snackBarText: 'Congratulations! You\'ve unlocked the PAO system!',
            textColor: Colors.white,
            backgroundColor: colorPAODarker,
            durationSeconds: 3,
            isSuper: true,
          );
        }
      } else {
        showSnackBar(
          context: context,
          snackBarText: 'Congratulations! You aced it!',
          textColor: Colors.black,
          backgroundColor: colorChapter2Standard,
          durationSeconds: 2,
        );
      }
    } else {
      showSnackBar(
        context: context,
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

  giveUp() {
    HapticFeedback.lightImpact();
    prefs.updateActivityState(airportTimedTestKey, 'review');
    prefs.updateActivityVisible(airportTimedTestKey, false);
    prefs.updateActivityVisible(airportTimedTestPrepKey, true);
    if (!prefs.getBool(airportTimedTestCompleteKey)) {
      prefs.updateActivityState(airportTimedTestPrepKey, 'todo');
    }
    showSnackBar(
        context: context,
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
          title: Text('Airport: timed test', style: TextStyle(fontSize: 18)),
          backgroundColor: colorChapter2Standard,
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      return AirportTimedTestScreenHelp(
                          callback: widget.callback);
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
                          // 'Leaving at / from gate number:',
                          'Leaving at:',
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
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Container(
                            //   width: 70,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(
                            //       Radius.circular(5),
                            //     ),
                            //   ),
                            //   child: TextFormField(
                            //     controller: gateNumberController,
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontFamily: airportFont,
                            //       color: backgroundHighlightColor,
                            //     ),
                            //     decoration: InputDecoration(
                            //         enabledBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(
                            //           color: Colors.grey,
                            //         )),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //               color: backgroundHighlightColor),
                            //         ),
                            //         contentPadding: EdgeInsets.all(5),
                            //         border: OutlineInputBorder(),
                            //         hintText: 'XX',
                            //         hintStyle: TextStyle(
                            //           fontSize: 20,
                            //           color: Colors.grey,
                            //           fontFamily: airportFont,
                            //         )),
                            //   ),
                            // ),
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
                          // 'Flight code & seat number:',
                          'Flight code:',
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
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // Container(
                            //   width: 70,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(
                            //       Radius.circular(5),
                            //     ),
                            //   ),
                            //   child: TextFormField(
                            //     controller: seatNumberController,
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontFamily: airportFont,
                            //       color: backgroundHighlightColor,
                            //     ),
                            //     decoration: InputDecoration(
                            //         enabledBorder: OutlineInputBorder(
                            //             borderSide: BorderSide(
                            //           color: Colors.grey,
                            //         )),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //               color: backgroundHighlightColor),
                            //         ),
                            //         contentPadding: EdgeInsets.all(5),
                            //         border: OutlineInputBorder(),
                            //         hintText: 'XXX',
                            //         hintStyle: TextStyle(
                            //           fontSize: 20,
                            //           color: Colors.grey,
                            //           fontFamily: airportFont,
                            //         )),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    //     child: Text(
                    //       'Arriving at terminal:',
                    //       style: TextStyle(
                    //         fontSize: 18,
                    //         color: backgroundHighlightColor,
                    //         fontFamily: airportFont,
                    //       ),
                    //       textAlign: TextAlign.left,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    //     child: Container(
                    //       width: 70,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.all(
                    //           Radius.circular(5),
                    //         ),
                    //       ),
                    //       child: TextFormField(
                    //         controller: arrivingTerminalController,
                    //         textAlign: TextAlign.center,
                    //         style: TextStyle(
                    //           fontSize: 20,
                    //           fontFamily: airportFont,
                    //           color: backgroundHighlightColor,
                    //         ),
                    //         decoration: InputDecoration(
                    //             enabledBorder: OutlineInputBorder(
                    //                 borderSide: BorderSide(
                    //               color: Colors.grey,
                    //             )),
                    //             focusedBorder: OutlineInputBorder(
                    //               borderSide: BorderSide(
                    //                   color: backgroundHighlightColor),
                    //             ),
                    //             contentPadding: EdgeInsets.all(5),
                    //             border: OutlineInputBorder(),
                    //             hintText: 'X',
                    //             hintStyle: TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.grey,
                    //               fontFamily: airportFont,
                    //             )),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        BasicFlatButton(
                          text: 'Give up',
                          fontSize: 24,
                          color: Colors.grey[200]!,
                          onPressed: () => giveUp(),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        BasicFlatButton(
                          text: 'Submit',
                          fontSize: 24,
                          color: colorChapter2Standard,
                          onPressed: () => checkAnswer(),
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
  final Function callback;
  AirportTimedTestScreenHelp({Key? key, required this.callback})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HelpDialog(
      title: 'Airport Timed Test',
      information: [
        '    Time to recall your scenes! Remember how you anchored and/or linked your scenes first! Good luck!'
            '\n\n    By the way, when inputting the departure time you can just enter it with numbers, or include the colon if you like. '
      ],
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: airportTimedTestFirstHelpKey,
      callback: callback,
    );
  }
}
