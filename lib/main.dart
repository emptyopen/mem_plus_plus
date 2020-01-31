import 'package:flutter/material.dart';
import 'screens/homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEM++',
      theme: ThemeData(
          primaryColor: Colors.grey[300],
          accentColor: Colors.amber[200],
          fontFamily: 'Rajdhani'),
      home: MyHomePage(),
    );
  }
}
