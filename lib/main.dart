import 'package:ctr2013app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      MaterialApp(
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.amber,
            )
        ),
        routes: {
          '/': (context) => LoginScreen(),
        },
      )
  );
}

