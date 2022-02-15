import 'package:ctr2013app/constants/strings.dart';
import 'package:ctr2013app/screens/country_screen.dart';
import 'package:ctr2013app/screens/login_screen.dart';
import 'package:ctr2013app/screens/objects_screen.dart';
import 'package:ctr2013app/screens/poi_list_offline_screen.dart';
import 'package:ctr2013app/screens/poi_list_online_screen.dart';
import 'package:ctr2013app/screens/tutorial_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/navigation_manager.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String currentEmail = "";

  Widget mainWidget() {
    return Column(
      children: [
        SizedBox(height: 40,),
        Text("Les rubriques", style: TextStyle(fontSize: 30),),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.amber[600],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
              children: [
                Buttons().changeScreenButton(context, "Pays et territoire cévennol", CountryScreen()),
                Buttons().changeScreenButton(context, "Objets du patrimoine", ObjectsScreen()),
                Buttons().changeScreenButton(context, Strings.poiList, POIListOffline()),
                checkIfUserIsConnected(),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
          child: Column(
            children: [
              Text("Feuilletez nos illustrations sur le pays cévenol et le patrimoine matériel et culturel.", style: TextStyle(fontSize: 22), textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
              Text("Transmettre la mémoire vous interpelle ? Pendant votre ballade, explorez le territoire ! Vous participerez au relevé des curiosités et des bâtis visibles dans la région.", style: TextStyle(fontSize: 22), textAlign: TextAlign.justify,),
              SizedBox(height: 10,),
              Text("La carte vous localise près de “l'objet” à décrire et que vous pourrez photographier. Pour commencer, appuyez sur le bouton ci-dessous.", style: TextStyle(fontSize: 22), textAlign: TextAlign.justify,),
              SizedBox(height: 15,),
              Buttons().changeScreenButton(context, Strings.addPOI, TutorialScreen()),
              SizedBox(height: 15,),
            ],
          ),
        )
      ],
    );
  }

  Widget checkIfUserIsConnected() {
    switch(currentEmail) {
      case "offline" : { return offlineActionMenu(); } break;
      case "null" : { return errorWidget(); } break;
      default : { return onlineActionMenu(); } break;
    }
  }
  
  Widget errorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Erreur : veuillez vous reconnecter.'),
        Buttons().changeScreenButton(context, "Retour", LoginScreen())
      ],
    );
  }

  Widget onlineActionMenu() {
    return Column(
      children: [
        Buttons().changeScreenButton(context, "Liste des POIs mis en ligne", POIListOnline()),
        Buttons().simpleActionButton(Strings.logoutButton, disconnectUser),
      ],
    );
  }

  Widget offlineActionMenu() {
    return Column(
      children: [
        Buttons().simpleActionButton(Strings.loginButton, disconnectUser),
      ],
    );
  }

  void setCurrentEmail() async {
    String storedEmail = await SharedPreferencesManager().getStringFromKeyInCurrentSession('email');
    setState(() {
      currentEmail = storedEmail;
    });
  }

  void disconnectUser() {
    removeEmailFromSession();
    NavigationManager().changeScreen(context, LoginScreen());
  }

  void removeEmailFromSession() async {
    SharedPreferencesManager().emptyStringFromCurrentSession('email');
    setCurrentEmail();
  }

  @override
  void initState() {
    setCurrentEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber[200],
        body: SingleChildScrollView(
            child: BackButtonManager().handleBackButton(mainWidget())
        )
    );
  }
}
