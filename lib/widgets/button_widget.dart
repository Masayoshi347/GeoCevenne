import 'package:ctr2013app/utils/navigation_manager.dart';
import 'package:flutter/material.dart';

class Buttons {

  Color colorOfButtons = Colors.amber[900];

  // Elevated buttons

  Widget popButton(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: () {Navigator.of(context).pop();},
          child: Text('Annuler'),
          style: ElevatedButton.styleFrom(
            primary: colorOfButtons,
          ),
      ),
    );
  }

  Widget simpleActionButton(String label, Function action) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: () => action(),
          child: Text(label),
          style: ElevatedButton.styleFrom(
            primary: colorOfButtons,
          ),
      ),
    );
  }

  Widget changeScreenButton(BuildContext context, String label, Widget screenToLoad) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: () => NavigationManager().changeScreen(context, screenToLoad),
          child: Text(label),
          style: ElevatedButton.styleFrom(
            primary: colorOfButtons,
          ),
      ),
    );
  }

  // Floating action buttons

  Widget simpleActionFloatingButton(IconData icon, String heroTag, Function action) {
    return FloatingActionButton(
        heroTag: heroTag,
        onPressed: () => action(),
        child: Icon(icon),
        backgroundColor: Colors.amber[600],
    );
  }

  Widget changeScreenFloatingButton(BuildContext context, String heroTag, IconData icon, Widget screenToLoad) {
    return FloatingActionButton(
        heroTag: heroTag,
        onPressed: () => NavigationManager().changeScreen(context, screenToLoad),
        child: Icon(icon),
        backgroundColor: Colors.amber[600],
    );
  }

}