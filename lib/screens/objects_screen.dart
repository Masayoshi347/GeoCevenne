import 'dart:ui';

import 'package:ctr2013app/screens/glossary_screen.dart';
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/screens/objects_slide_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class ObjectsScreen extends StatelessWidget {
  const ObjectsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButtonManager().handleBackButton(
      Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/objects_screen.jpg"),
                  fit: BoxFit.cover
              )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
              child: Column(
                children: [
                  Text('Les objets du patrimoine', style: TextStyle(fontSize: 30, color: Colors.white),),
                  Divider(color: Colors.black,),
                  SizedBox(height: 10,),
                  Text("Aujourd'hui délaissés, les ouvrages de la société paysannne sont vidés de leur contenu mémoriel.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                  SizedBox(height: 10,),
                  Text("L'application vous propose une exploration participative du territoire rural pour identifier des objets symboliques du pays (petits ouvrages de l'irrigation, de la voirie, de l’exploitation agricole, de l'élevage, du culte, etc).", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                  SizedBox(height: 10,),
                  Text("Ces bâtis et vestiges revisités pourront faire surgir des souvenirs, la parole d'un ancien, des échanges avec les jeunes générations.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                  SizedBox(height: 25,),
                  Buttons().changeScreenButton(context, "Glossaire des objets", GlossaryScreen()),
                  Buttons().changeScreenButton(context, "Diaporama des objets", ObjectsSlideScreen()),
                  Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
