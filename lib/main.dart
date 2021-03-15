import 'package:flutter/material.dart';
import 'package:flutter_weather/components/homePage.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather",
      home: HomePage(),
    );
  }
}
