import 'package:flutter/material.dart';

class BackButtonManager {

  Widget handleBackButton(Widget screenWidget) {
    return WillPopScope(
        child: screenWidget,
        onWillPop: () async => false
    );
  }

}