import 'dart:ui';

import 'package:ctr2013app/screens/country_slide_screen.dart';
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CountryScreen extends StatelessWidget {
  const CountryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButtonManager().handleBackButton(Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover
          )
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
            child: Column(
              children: [
                Text('Une ballade en Cévennes ?', style: TextStyle(fontSize: 30),),
                Divider(color: Colors.black,),
                SizedBox(height: 10,),
                Text("Un paysage magnifique se découvre devant vous, avec ses moutonnements de serres et de valats (crêtes et vallons) et son horizon gris-bleuté de pics à l'infini.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 10,),
                Text("Dès le Moyen-Âge, les hommes ont apprivoisé la nature, exigeante et rude, mais favorable aux activités paysannes, la chasse, l'agriculture et l'élevage.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 10,),
                Text("Les espaces forestiers sont devenus pastoraux, les côteaux ont été façonnés en terrasses pour protéger le sol et contraindre l'eau, parfois dévastatrice.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 10,),
                Text("Des générations de paysans ont élevé les brebis et les chèvres, cultivé le seigle, l'orge, la pomme de terre, le châtaignier, la vigne, et plus récemment le murier, les vergers, l'oignon doux.", style: TextStyle(fontSize: 20, color: Colors.white), textAlign: TextAlign.justify,),
                SizedBox(height: 25,),
                Buttons().changeScreenButton(context, "Diaporama du pays", CountrySlideScreen()),
                Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
