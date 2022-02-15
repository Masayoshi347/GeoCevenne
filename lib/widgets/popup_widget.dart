import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class Popups {

  Widget basicPopup(BuildContext context, String title, String content) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [Buttons().popButton(context)],
    );
  }

  void showBasicPopup(BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) => basicPopup(context, title, description)
    );
  }

  Widget multipleActionPopup(String title, String content, List<Widget> listOfActions) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: listOfActions,
    );
  }

  void showMultipleActionPopup(BuildContext context, String title, String description, List<Widget> listOfActions) {
    showDialog(
        context: context,
        builder: (BuildContext context) => multipleActionPopup(title, description, listOfActions)
    );
  }

}
