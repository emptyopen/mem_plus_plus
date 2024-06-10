import 'package:flutter/material.dart';
import 'package:mem_plus_plus/services/prefs_updater.dart';
import 'screens/homepage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

import 'services/services.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

// next up:
// new tags need clean up - reappearing
// morse reset should kill timer (new line shouldn't appear)
// change shopping list to be something in order
// games unlock all at once?
// "new" for games not showing up
// custom memory if has error, gets stuck on "encrypting..."

// horizon:
// figure out local notifications once and for all
// show irrational test animation for completion
// custom memory can't always submit answer? check if wrong
// when adding alphabet and PAO, check for overlap with existing objects (single digit, alphabet, etc)
// add trivia games (order of US presidents, British monarchies?) - unlock first set after planet test
// add FIND THE CARD game, memory show all cards for some amount of time, then flip over
// BIG: add date & recipe system
// welcome animation, second page still visible until swipe? (and other swiping pages only first page)
// handle bad CSV input
// figure out how to handle CSV on iphone (doesn't launch google sheets well?) button in CSV to copy text?
// check callback for adding custom ID vs others?
// investigate potential slow encrypting
// add recipe as custom test
// for small phones, add bottom opacity for scrolling screens (dots overlay), indicator to scroll!!
// BIG: badge / quest system
// BIG: once you beat something (like a timed test, it gets harder, up to three levels???) / or choose amount of time for timed tests
// describe amount of pi correct
// chapter animation
// add scroll notification when scrollable: https://medium.com/@diegoveloper/flutter-lets-know-the-scrollcontroller-and-scrollnotification-652b2685a4ac
// match ages for face (hard)
// divide photos (file names?) into ethnicities / age / gender buckets? choose characteristics first, then pick photo
// implement length limits for inputs (like action/object) - maybe 30 characters
// add conversion rates
// add doomsday memory rule
// add first aid system
// add more faces, make all of them closer to the face
// alphabet PAO (person action, same object)
// add symbols
// add password test
// add safe viewing area (for toolbar)
// add global celebration animation whenever there is a level up (or more animation in general, FLARE?)
// crashlytics for IOS
// look into possible battery drainage from refreshing screen? emulator seems to run hot
// add name (first time, and preferences) - use in local notifications
// add ability for alphabet to contain up to 3 objects (level up system?)
// make PAO multiple choice tougher with similar digits
// make vibrations cooler, and more consistent across app?
// make account, backend, retrieve portfolios
// delete old memory dict keys for custom memories when you delete the memory
// BIG: add backend, account recovery (store everything?)

// TODO:  Brain by Arjun Adamson from the Noun Project
// https://medium.com/@psyanite/how-to-add-app-launcher-icons-in-flutter-bd92b0e0873a
// Icons made by <a href="https://www.flaticon.com/authors/dimitry-miroliubov" title="Dimitry Miroliubov">Dimitry Miroliubov</a> from <a href="https://www.flaticon.com/" title="Flaticon"> www.flaticon.com</a>

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: if you want to find out if the app was launched via notification then you could use the following call and then do something like
  // change the default route of the app
  // var notificationAppLaunchDetails =
  //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  await PrefsUpdater.init();

  var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
    didReceiveLocalNotificationSubject.add(ReceivedNotification(
        id: id, title: title, body: body, payload: payload));
  });
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    debugPrint('notification payload: ' + payload!);
    selectNotificationSubject.add(payload);
  });
  initializeNotificationsScheduler();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEM++',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.grey[300],
          fontFamily: 'Viga',
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.amber[200])),
      home: MyHomePage(),
    );
  }
}
