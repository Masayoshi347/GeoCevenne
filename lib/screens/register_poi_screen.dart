import 'dart:convert';
import 'package:ctr2013app/utils/database_helper.dart';
import 'package:path/path.dart' as pathPackage;
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:http/http.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/loading_screen.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:ctr2013app/widgets/field_widget.dart';
import 'package:ctr2013app/widgets/popup_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RegisterPOIScreen extends StatefulWidget {
  @override
  _RegisterPOIScreenState createState() => _RegisterPOIScreenState();
}

class _RegisterPOIScreenState extends State<RegisterPOIScreen> {

  bool loading = false;

  String currentEmail;
  String userMarkerPositionLatitude;
  String userMarkerPositionLongitude;

  String village;
  String lieu;
  String type;
  String etatSelect;
  String notes;

  List<String> listeEtats = ['Ruine', 'Entier', 'Utilisé'];

  File image;
  final picker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initializeVariablesFromCurrentSession();
  }

  // -- Layout --

  Widget registerPOIScreenLayout() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            registerForm(),
          ],
        ),
      ),
    );
  }

  Widget registerForm() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: formKey,
        child: registerFields(),
      ),
    );
  }

  Widget registerFields() {
    return Column(
      children: [
        image == null ? Text('Aucune image sélectionnée.') : Image.file(image),
        SizedBox(height: 25,),
        Buttons().simpleActionFloatingButton(Icons.camera_alt_outlined, "image", getImage),
        Fields().simpleField('Village', false, setNewVillage),
        Fields().simpleField('Lieu', false, setNewLieu),
        Fields().simpleField('Type', false, setNewType),
        SizedBox(height: 6,),
        etatSelectList(),
        Fields().simpleField('Notes', false, setNewNotes),
        SizedBox(height: 25,),
        Text('Latitude : $userMarkerPositionLatitude'),
        Text('Longitude : $userMarkerPositionLongitude'),
        SizedBox(height: 25,),
        Buttons().simpleActionButton('Envoyer', validateFormFields),
        Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen())
      ],
    );
  }

  // -- Buttons --

  void validateFormFields() {
    if(formKey.currentState.validate()) {
      changeLoadingStatus();
      checkIfImageIsEmpty();
    }
  }

  // -- Fields --

  Widget etatSelectList() {
    return DropdownButtonFormField(
      isExpanded: true,
      hint: Text('Dans quel état le POI?'),
      value: etatSelect,
      validator: Fields().checkFieldEmpty,
      onChanged: setNewEtat,
      items: listeEtats.map((item) {
        return DropdownMenuItem(child: new Text(item), value: item);
      }).toList(),
    );
  }

  // -- Image picker functions --

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  void checkIfImageIsEmpty() {
    if(image == null) {
      changeLoadingStatus();
      Popups().showBasicPopup(context, "Image manquante", "Veuillez renseigner une image.");
    } else {
      checkIfUserIsOffline();
    }
  }

  // -- Database functions --

  void checkIfUserIsOffline() {
    if(currentEmail == "offline") {
      sendPOIDataToLocalDatabase();
    } else {
      sendPOIDataToDatabase();
    }
    Popups().showMultipleActionPopup(context, "POI ajouté", "Votre POI a bien été ajouté!", [Buttons().changeScreenButton(context, "Retour", HomeScreen())]);
  }

  void sendPOIDataToLocalDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String fileName = image.path.split("/").last;
    String path = pathPackage.join(directory.path, fileName);
    File copiedImage = await image.copy('$path');
    int insertedPOI = await DatabaseHelper.instance.insert({
      DatabaseHelper.cnameVillage : village,
      DatabaseHelper.cnameLieu : lieu,
      DatabaseHelper.cnameType : type,
      DatabaseHelper.cnameEtat : etatSelect,
      DatabaseHelper.cnameNotes : notes,
      DatabaseHelper.cnameLatitude : userMarkerPositionLatitude,
      DatabaseHelper.cnameLongitude : userMarkerPositionLongitude,
      DatabaseHelper.cnameImageUrl : fileName,
    });
  }

  void sendPOIDataToDatabase() async {
    Uri url = Uri.parse('http://ctrapp2013.free.fr/appmpr/insert_poi_data.php');
    String base64Image = base64Encode(image.readAsBytesSync());
    String fileName = image.path.split("/").last;
    final Response response = await post(url, body: {
      "image": base64Image,
      "imageFileName": fileName,
      "email": currentEmail,
      "village": village,
      "lieu": lieu,
      "type": type,
      "etat": etatSelect,
      "notes": notes,
      "latitude": userMarkerPositionLatitude,
      "longitude": userMarkerPositionLongitude,
      "status": 1.toString()
    });
  }

  // -- Attributing form results to variables --

  void setNewVillage(String value) {
    setState(() {
      village = value.toString();
    });
  }

  void setNewLieu(String value) {
    setState(() {
      lieu = value.toString();
    });
  }

  void setNewType(String value) {
    setState(() {
      type = value.toString();
    });
  }

  void setNewEtat(String value) {
    setState(() {
      etatSelect = value.toString();
    });
  }

  void setNewNotes(String value) {
    setState(() {
      notes = value.toString();
    });
  }

  // -- Setup variables --

  void setCurrentEmail() async {
    String storedEmail = await SharedPreferencesManager().getStringFromKeyInCurrentSession('email');
    setState(() {
      currentEmail = storedEmail;
    });
  }

  void setMarkerPosition() async {
    String retrievedUserMarkerPositionLatitude = await SharedPreferencesManager().getStringFromKeyInCurrentSession('userMarkerPositionLatitude');
    String retrievedUserMarkerPositionLongitude = await SharedPreferencesManager().getStringFromKeyInCurrentSession('userMarkerPositionLongitude');
    setState(() {
      assignLatAndLongFromCurrentSession(retrievedUserMarkerPositionLatitude, retrievedUserMarkerPositionLongitude);
    });
  }
  
  void assignLatAndLongFromCurrentSession(String latitude, String longitude) {
    userMarkerPositionLatitude = latitude;
    userMarkerPositionLongitude = longitude;
  }

  void initializeVariablesFromCurrentSession() async {
    setCurrentEmail();
    setMarkerPosition();
  }

  // -- Other --

  changeLoadingStatus() {
    setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.amber[200],
      appBar: AppBar(title: Text("Renseigner un POI"), automaticallyImplyLeading: false, backgroundColor: Colors.amber[900],),
      body: BackButtonManager().handleBackButton(registerPOIScreenLayout()),
    );
  }
}
