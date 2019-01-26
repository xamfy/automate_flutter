import 'package:flutter/material.dart';
import 'package:home_automation/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automate',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.indigo,
      // ),
      theme: new ThemeData(
          primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
          primarySwatch: Colors.grey),
      home: MyHomePage(title: 'Automate'),
    );
  }
}
