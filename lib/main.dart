import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Login.tag: (context) => Login(),
    Home.tag: (context) => Home(username: '', realToken: '')
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sevima Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Login(),
      routes: routes,
    );
  }
}
