import 'package:flutter/material.dart';

class NavigationManager {

  void changeScreen(BuildContext context, Widget screenName) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (BuildContext context) => screenName)
    );
  }

}