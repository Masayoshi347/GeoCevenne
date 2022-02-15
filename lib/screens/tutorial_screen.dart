import 'package:ctr2013app/constants/strings.dart';
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/screens/map_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {

  Widget tutorialScreenLayout(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text("Faire le relevé d'un point", style: TextStyle(fontSize: 30),),
                SizedBox(height: 50,),
                Text("Un seuil, un bâti isolé, une ruine, une calade.? Examinez tranquillement les lieux (vallon, coteau, ubac/adret, cours d'eau), la végétation (forêt, pré, friche, champ...), la trace d'aménagements (lieu habité, terrasse, canal...). 5 minutes suffisent pour faire des photos et un relevé patrimonial géolocalisé !", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                SizedBox(height: 20,),
                Text("Vous devez être inscrit pour saisir des points", style: TextStyle(fontSize: 20, color: Colors.red), textAlign: TextAlign.justify,),
                SizedBox(height: 20,),
                Text("• Approchez de l'objet, centrez et zoomez la carte, cliquez sur l'épingle • Remplissez les rubriques, choisissez une photo dans votre galerie et un clic sur OK. C'est fait ! • Le POI est en mémoire, prêt à l’envoi sur le serveur (à la prochaine connexion l’indicateur passera du vert au rouge)", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                SizedBox(height: 10,),
              ],
            ),
          ),
          Buttons().changeScreenButton(context, Strings.continueMessage, MapScreen()),
          Buttons().changeScreenButton(context, Strings.cancel, HomeScreen())
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[200],
      body: BackButtonManager().handleBackButton(tutorialScreenLayout(context))
    );
  }
}
