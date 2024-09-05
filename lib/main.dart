import 'package:flutter/material.dart';
import 'package:test_app/home_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Task',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}








