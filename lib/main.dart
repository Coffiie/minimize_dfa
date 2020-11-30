import 'package:flutter/material.dart';
import 'package:minimize_dfa/views/home/HomeView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.light,
        primaryColor: Colors.red,
        fontFamily: 'Montserrat',
        buttonTheme: ButtonThemeData(
          height: 45,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
            headline5:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            caption: TextStyle(
              fontSize: 16,
            )),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}
