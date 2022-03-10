import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'layout/home.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[850],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.amber[900]),
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.amber[900]),
            backgroundColor: Colors.grey[850],
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.amber[900],
                statusBarIconBrightness: Brightness.dark),
            titleTextStyle: TextStyle(
                color: Colors.amber[900],
                fontSize: 25.0,
                fontWeight: FontWeight.bold)),
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}
