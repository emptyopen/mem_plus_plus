import 'package:flutter/material.dart';
import 'package:mem_plus_plus/components/standard.dart';
import 'package:mem_plus_plus/services/services.dart';
import 'dart:async';
import 'package:mem_plus_plus/screens/templates/help_screen.dart';
import 'package:mem_plus_plus/components/animations.dart';
import 'package:mem_plus_plus/constants/colors.dart';
import 'package:mem_plus_plus/constants/keys.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class AirportTimedTestPrepScreen extends StatefulWidget {
  final Function() callback;

  AirportTimedTestPrepScreen({this.callback});

  @override
  _AirportTimedTestPrepScreenState createState() =>
      _AirportTimedTestPrepScreenState();
}

class _AirportTimedTestPrepScreenState extends State<AirportTimedTestPrepScreen>
    with SingleTickerProviderStateMixin {
  String confirmationCode = '';
  String airline = '';
  String flightCode = '';
  String seatNumber = '';
  String gateNumber = '';
  String departureTime = '';
  String departingTerminal = '';
  String arrivingTerminal = '';
  String chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  String seatingLetters = 'ABCDEFGH';
  String terminalLetters = 'ABCD';
  Map airlines = {
    'UA': 'United Airlines',
    'AC': 'Air Canada',
    'NZ': 'Air New Zealand',
    'NH': 'ANA',
    'OZ': 'Asiana Airlines',
    'CA': 'Air China',
    'BA': 'British Airways',
    'MU': 'China Eastern',
    'CX': 'Cathay Pacific',
    'DL': 'Delta',
    'BR': 'EVA Airways',
    'JL': 'Japan Airlines',
    'SQ': 'Singapore Airlines',
  };
  String airportFont = 'Quicksand';
  PrefsUpdater prefs = PrefsUpdater();
  bool isLoaded = false;
  AnimationController animationController;
  Duration testDuration =
      debugModeEnabled ? Duration(seconds: 5) : Duration(hours: 6);

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    animationController = AnimationController(
      duration: const Duration(
        seconds: 5,
      ),
      vsync: this,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  callback() {
    animationController.reset();
    animationController.forward();
  }

  getSharedPrefs() async {
    prefs.checkFirstTime(context, airportTimedTestPrepFirstHelpKey,
        AirportTimedTestPrepScreenHelp(callback: callback));

    bool airportTestIsActive = await prefs.getBool(airportTestActiveKey);
    if (airportTestIsActive == null || !airportTestIsActive) {
      print('no active test, setting new values');
      var random = Random();
      confirmationCode = '';
      for (var i = 0; i < 6; i++) {
        confirmationCode += chars[random.nextInt(chars.length)];
      }
      airline = airlines.keys.elementAt(random.nextInt(airlines.length));
      flightCode = airline + '-' + (random.nextInt(9399) + 600).toString();

      departureTime =
          '${(random.nextInt(18) + 6).toString().padLeft(2, '0')}:${(random.nextInt(4) * 15).toString().padLeft(2, '0')}';

      seatNumber = random.nextInt(65).toString() +
          seatingLetters[random.nextInt(seatingLetters.length)];

      gateNumber = random.nextInt(20).toString();
      if (random.nextInt(5) == 0) {
        gateNumber = random.nextInt(60).toString();
      }

      departingTerminal = (random.nextInt(5) + 1).toString();
      if (random.nextInt(5) == 0) {
        departingTerminal +=
            terminalLetters[random.nextInt(terminalLetters.length)];
      }

      arrivingTerminal = (random.nextInt(5) + 1).toString();
      if (random.nextInt(5) == 0) {
        arrivingTerminal +=
            terminalLetters[random.nextInt(terminalLetters.length)];
      }
      await prefs.setString('airportAirline', airline);
      await prefs.setString('airportDepartingTerminal', departingTerminal);
      await prefs.setString('airportFlightCode', flightCode);
      await prefs.setString('airportFlightTime', departureTime);
      await prefs.setString('airportConfirmationCode', confirmationCode);
      await prefs.setString('airportSeatNumber', seatNumber);
      await prefs.setString('airportGateNumber', gateNumber);
      await prefs.setString('airportArrivingTerminal', arrivingTerminal);
      await prefs.setBool(airportTestActiveKey, true);
    } else {
      airline = await prefs.getString('airportAirline');
      departingTerminal = await prefs.getString('airportDepartingTerminal');
      flightCode = await prefs.getString('airportFlightCode');
      departureTime = await prefs.getString('airportFlightTime');
      confirmationCode = await prefs.getString('airportConfirmationCode');
      seatNumber = await prefs.getString('airportSeatNumber');
      gateNumber = await prefs.getString('airportGateNumber');
      arrivingTerminal = await prefs.getString('airportArrivingTerminal');
    }
    isLoaded = true;
    setState(() {});
  }

  void updateStatus() async {
    await prefs.setBool(airportTestActiveKey, false);
    await prefs.updateActivityState(airportTimedTestPrepKey, 'review');
    await prefs.updateActivityVisible(airportTimedTestPrepKey, false);
    await prefs.updateActivityState(airportTimedTestKey, 'todo');
    await prefs.updateActivityVisible(airportTimedTestKey, true);
    await prefs.updateActivityFirstView(airportTimedTestKey, true);
    await prefs.updateActivityVisibleAfter(
        airportTimedTestKey, DateTime.now().add(testDuration));
    Timer(testDuration, widget.callback);
    notifyDuration(testDuration, 'Timed test (airport) is ready!', 'Good luck!',
        airportTimedTestKey);
    widget.callback();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          title: Text('Airport: timed test prep'),
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
                      return AirportTimedTestPrepScreenHelp(
                        callback: callback,
                      );
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
                          'Thank you for choosing',
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
                      height: 10,
                    ),
                    Text(
                      '-   ${airlines[airline]}   -',
                      style: TextStyle(
                        fontSize: 28,
                        color: backgroundHighlightColor,
                        fontFamily: airportFont,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                        child: Text(
                          'for your flight tomorrow!',
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
                      height: 20,
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
                    StaggerAnimationSideways(
                      widget: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            departingTerminal,
                            style: TextStyle(
                              fontSize: 26,
                              color: backgroundHighlightColor,
                              fontFamily: airportFont,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      controller: animationController,
                      begin: 0,
                      end: 0.5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          'Check in with confirmation code:',
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
                    StaggerAnimationSideways(
                      widget: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            confirmationCode,
                            style: TextStyle(
                              fontSize: 26,
                              color: backgroundHighlightColor,
                              fontFamily: airportFont,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      controller: animationController,
                      begin: 0.1,
                      end: 0.6,
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
                    StaggerAnimationSideways(
                      widget: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            // '$departureTime / $gateNumber',
                            '$departureTime',
                            style: TextStyle(
                              fontSize: 26,
                              color: backgroundHighlightColor,
                              fontFamily: airportFont,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      controller: animationController,
                      begin: 0.2,
                      end: 0.7,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: Text(
                          // 'Flight code / seat number:',
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
                    StaggerAnimationSideways(
                      widget: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Text(
                            // '$flightCode / $seatNumber',
                            '$flightCode',
                            style: TextStyle(
                              fontSize: 26,
                              color: backgroundHighlightColor,
                              fontFamily: airportFont,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      controller: animationController,
                      begin: 0.3,
                      end: 0.8,
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
                    // StaggerAnimationSideways(
                    //   widget: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                    //       child: Text(
                    //         arrivingTerminal,
                    //         style: TextStyle(
                    //           fontSize: 26,
                    //           color: backgroundHighlightColor,
                    //           fontFamily: airportFont,
                    //         ),
                    //         textAlign: TextAlign.left,
                    //       ),
                    //     ),
                    //   ),
                    //   controller: animationController,
                    //   begin: 0.4,
                    //   end: 0.9,
                    // ),
                    SizedBox(
                      height: 40,
                    ),
                    BasicFlatButton(
                      text: 'I\'m ready!',
                      color: colorChapter2Darker,
                      splashColor: colorChapter2Standard,
                      onPressed: () => showConfirmDialog(
                          context: context,
                          function: updateStatus,
                          confirmText:
                              'Are you sure you\'d like to start this test? The information will no longer be available to view!',
                          confirmColor: colorChapter2Standard),
                      fontSize: 30,
                      padding: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Text(
                        '(You\'ll be quizzed on this in six hours!)',
                        style: TextStyle(
                            fontSize: 18, color: backgroundHighlightColor),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

class AirportTimedTestPrepScreenHelp extends StatelessWidget {
  final Function callback;

  AirportTimedTestPrepScreenHelp({this.callback});

  helpCallback() {
    callback();
  }

  final List<String> information = [
    '    You are a rock star! Let\'s get you some more practical experience you can use in '
        'day to day life - travel plans! The next time you go to the airport, don\'t bother with the hassle of '
        'searching through your email to find the confirmation code. Walk up confidently to the check-in '
        'kiosk and pull the code straight from your brain!',
    '    Remember to attach your scenes to something that will help you remember what it represents. '
        'If my seat is 54E, my one-digit system would translate that into snake (5), sailboat (4) and elephant (E). I might imagine '
        'me settling down in my seat for the flight, turn on the infotainment system and... "SNAKES on a SAILBOAT 3"! '
        'My favorite trilogy is finally complete! And who is the new protagonist? An enormous African elephant, that makes perfect sense! '
        'I see the elephant clumsily navigating the fragile but beautiful sailboat through the whole movie.',
    'You can similarly attach scenes in different parts of the airport. A scene at the check-in counter, a scene at the gate, followed '
        'by a crazy event marking the time of departure. ',
    '    If you can handle this, you\'re ready for anything :) It might take a while your first time to get '
        'everything memorized. Trust me, it gets easier and easier to build these scenes and make them wacky. '
        '\n    Currently, you\'re only equipped with '
        'a single digit system. But once you master the next system '
        'and keep practicing, you\'ll eventually be able to fully memorize all of this in just a couple '
        'minutes or less! Definitely come back and revisit this test in the future!',
  ];

  @override
  Widget build(BuildContext context) {
    return HelpScreen(
      title: 'Airport Timed Test Preparation',
      information: information,
      buttonColor: colorChapter2Standard,
      buttonSplashColor: colorChapter2Darker,
      firstHelpKey: airportTimedTestPrepFirstHelpKey,
      callback: helpCallback,
    );
  }
}
