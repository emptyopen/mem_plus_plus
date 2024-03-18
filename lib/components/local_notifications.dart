import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:mem_plus_plus/screens/homepage.dart';

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
  final notifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
      InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
      onSelectNotification: onSelectNotification,
    );

    // --------
//    scheduledNotifications();
  }

  scheduledNotifications() async {
    // Show a notification every minute with the first appearance happening a minute after invoking the method
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeating channel id',
        'repeating channel name',
        'repeating description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await notifications.periodicallyShow(
      0,
      'repeating title',
      'repeating body',
      RepeatInterval.everyMinute,
      platformChannelSpecifics,
    );
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    autoCancel: false,
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(
    android: androidChannelSpecifics,
    iOS: iOSChannelSpecifics,
  );
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
