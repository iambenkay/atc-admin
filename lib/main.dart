import 'package:flutter/material.dart';
import 'Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      theme: ThemeData(
        primaryColor: Color(0xffe29464),
        accentColor: Color(0xffe29464),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
