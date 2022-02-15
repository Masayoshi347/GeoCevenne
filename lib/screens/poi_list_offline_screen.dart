import 'dart:async';

import 'package:ctr2013app/constants/strings.dart';
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/database_helper.dart';
import 'package:ctr2013app/utils/loading_screen.dart';
import 'package:ctr2013app/utils/navigation_manager.dart';
import 'package:ctr2013app/utils/phpmyadmin_helper.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:ctr2013app/widgets/field_widget.dart';
import 'package:ctr2013app/widgets/popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path/path.dart' as pathPackage;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class POIListOffline extends StatefulWidget {
  @override
  _POIListOfflineState createState() => _POIListOfflineState();
}

class _POIListOfflineState extends State<POIListOffline> {

  bool loading = false;

  String currentEmail;

  Directory directory;
  String path;

  List<Map<String, dynamic>> allRows = [];
  List<Map<String, dynamic>> listOfPoi = [];
  int listLength;

  final formKey = GlobalKey<FormState>();

  String email;
  String password;

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubscription;

  void initState() {
    setCurrentEmail();
    getImageDirectory();
    initConnectivity();
    connectivitySubscription = connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    if(!mounted) {
      return Future.value(null);
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
  }

  void setCurrentEmail() async {
    String storedEmail = await SharedPreferencesManager().getStringFromKeyInCurrentSession('email');
    setState(() {
      currentEmail = storedEmail;
    });
  }

  // -- Retrieve rows and image directory

  Future<List<Map<String, dynamic>>> getRows() async {
    allRows = await DatabaseHelper.instance.queryAll();
    return allRows;
  }

  Future<Directory> getImageDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  // -- POI List Skeleton

  Widget poiListOffline() {
    return Column(
      children: [
        Expanded(child: poiListLocalFutureHandler()),
      ],
    );
  }

  // -- Build POI list

  Widget poiListLocalFutureHandler() {
    return FutureBuilder(
      future: getRows(),
      builder: (context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return Loading();
        }
        else {
          return poiListWrapperOffline(snapshot.data.length, snapshot.data);
        }
      },
    );
  }

  Widget poiListWrapperOffline(int receivedListLength, receivedListOfPoi) {
    listOfPoi = receivedListOfPoi;
    listLength = receivedListLength;
    return Column(
      children: [
        SizedBox(height: 10,),
        syncButton(),
        Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
        Expanded(child: ActualPoiList()),
      ],
    );
  }

  Widget ActualPoiList() {
    return ListView.builder(
      itemCount: listLength,
      itemBuilder: (context, index) {
        path = pathPackage.join(directory.path, listOfPoi[index]['image_url']);
        if(listOfPoi[0].isEmpty) {
          return noPoiFoundWidget();
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: poiCard(index),
          );
        }
      },
    );
  }

  Widget noPoiFoundWidget() {
    return Center(
      child: Text('Aucun POI renseigné'),
    );
  }

  // -- Build POI card --

  Widget poiCard(int index) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 2,
                child: poiInfo(index)
            ),
            Expanded(
                flex: 2,
                child: Column(
                  children: [poiImage()],
                )
            )
          ],
        ),
      ),
    );
  }

  Widget poiInfo(int index) {
    return Column(
      children: [
        Row(
          children: [
            uploadStatus(index, listOfPoi[index]['status']),
            SizedBox(width: 10),
            Text('POI n°${listOfPoi[index]['id'].toString()}', textAlign: TextAlign.start,)
          ],
        ),
        Divider(height: 20, color: Colors.black, thickness: .5,),
        Text(listOfPoi[index]['village']),
        Text(listOfPoi[index]['lieu']),
        Text(listOfPoi[index]['type']),
        Text(listOfPoi[index]['etat']),
        Text(listOfPoi[index]['notes']),
        Text(listOfPoi[index]['latitude']),
        Text(listOfPoi[index]['longitude']),
        deleteButton(listOfPoi[index]['id']),
      ],
    );
  }

  Widget uploadStatus(int index, int status) {
    if(status == 0) {
      return Icon(Icons.access_time_rounded);
    } else {
      return Icon(Icons.check);
    }
  }

  Widget poiImage() {
    return Image.file(
      File(path),
      width: 125,
      height: 125,
    );
  }

  Widget deleteButton(int id) {
    return ElevatedButton(
        onPressed: () => Popups().showMultipleActionPopup(context, "Suppresion du POI $id", "Etes-vous sûr de vouloir supprimer le POI $id?", [validatePoiDeletion(id), Buttons().popButton(context)]),
        child: Text("Supprimer")
    );
  }

  Widget validatePoiDeletion(int id) {
    return ElevatedButton(
        onPressed: () => deleteSelectedPoi(id),
        child: Text("Supprimer")
    );
  }

  void deleteSelectedPoi(int id) async {
    changeLoadingStatus();
    int removePoi = await DatabaseHelper.instance.delete(id);
    Popups().showMultipleActionPopup(context, "POI $id supprimé", "Le POI $id a bien été supprimé.", [Buttons().changeScreenButton(context, "Retour", POIListOffline())]);
  }

  // -- Synchronisation popup

  Widget syncButton() {
    return SizedBox(
      width: 250,
      child: ElevatedButton.icon(
        onPressed: () {showSyncPopup();},
        label: Text("Synchronisation"),
        icon: Icon(Icons.wifi),
        style: ElevatedButton.styleFrom(
          primary: Colors.amber[900],
        ),
      ),
    );
  }

  void showSyncPopup() {
    showDialog(
        context: context,
        builder: (BuildContext context) => syncPopup()
    );
  }

  Widget syncPopup() {
    if(currentEmail == "offline") {
      return checkIfConnectedToWifi();
    }
    else {
      return Popups().basicPopup(context, "Action impossible", "Cette option n'est disponible que dans le mode hors-ligne.");
    }
  }

  Widget checkIfConnectedToWifi() {
    if(connectionStatus == ConnectivityResult.wifi) {
      return syncAlertDialog();
    }
    else {
      return Popups().basicPopup(context, "Action impossible", "Vous devez être connecté en Wi-Fi pour synchroniser vos POIs.");
    }
  }

  Widget syncAlertDialog() {
    return AlertDialog(
      title: Text("Synchronisation"),
      content: syncPopupForm(),
    );
  }

  Widget syncPopupForm() {
    return loading ? Loading() : Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            Text("Ici, vous pouvez synchroniser vos POIs à un compte en ligne. Une connexion Wi-Fi est nécessaire pour effectuer l'opération."),
            Fields().simpleField('E-Mail ', false, setNewEmail),
            Fields().simpleField('Mot de passe', true, setNewPassword),
            SizedBox(height: 25,),
            syncValidationButton('Se connecter et envoyer', 'login'),
            syncValidationButton("S'enregistrer et envoyer", 'register')
          ],
        ),
      ),
    );
  }

  void setNewEmail(String value) {
    setState(() {
      email = value.toString();
    });
  }

  void setNewPassword(String value) {
    setState(() {
      password = value.toString();
    });
  }

  Widget syncValidationButton(String label, String pickedProcess) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
          onPressed: () => validateSyncFormFields(pickedProcess),
          child: Text(label),
          style: ElevatedButton.styleFrom(primary: Colors.amber[900]),
      ),
    );
  }

  void validateSyncFormFields(String pickedProcess) {
    if(formKey.currentState.validate()) {
      if(pickedProcess == 'login') {
        startSyncLoggingProcess();
      }
      else {
        startSyncRegistrationProcess();
      }
    }
  }

  void startSyncLoggingProcess() async {
    changeLoadingStatus();
    int numberOfRowsWithTheseCredentials = await PhpMyAdminHelper().checkLoginInfoExistsInDatabase('http://ctrapp2013.free.fr/appmpr/login.php?email=$email&mdp=$password');
    isLoginCorrect(numberOfRowsWithTheseCredentials);
  }

  void isLoginCorrect(int numberOfRowsWithTheseCredentials) async {
    if(numberOfRowsWithTheseCredentials == 1) {
      endLoggingProcess();
    } else {
      changeLoadingStatus();
      Popups().showBasicPopup(context, Strings.cantConnectMessage, Strings.noAccountForTheseCredentials);
    }
  }

  void endLoggingProcess() {
    sendPOIFromLocalToOnlineDatabase();
    SharedPreferencesManager().addStringToCurrentSession('email', email);
    NavigationManager().changeScreen(context, POIListOffline());
  }

  void sendPOIFromLocalToOnlineDatabase() async {
    for(var poi in listOfPoi) {
      Uri url = Uri.parse('http://ctrapp2013.free.fr/appmpr/insert_poi_data.php');
      File image;
      String path = pathPackage.join(directory.path, poi['image_url']);
      image = File(path);
      String base64image = base64Encode(image.readAsBytesSync());
      String fileName = image.path.split("/").last;
      Response response = await post(url, body: {
        "image": base64image,
        "imageFileName": fileName,
        "email": email,
        "village": poi['village'],
        "lieu": poi['lieu'],
        "type": poi['type'],
        "etat": poi['etat'],
        "notes": poi['notes'],
        "latitude": poi['latitude'],
        "longitude": poi['longitude']
      });
    }
    Popups().showBasicPopup(context, "POIs synchronisés", "Vos POI ont été synchronisés!");
  }

  void startSyncRegistrationProcess() async {
    changeLoadingStatus();
    int numberOfRowsWithTheseCredentials = await PhpMyAdminHelper().checkLoginInfoExistsInDatabase('http://ctrapp2013.free.fr/appmpr/register_check.php?email=$email');
    isUserAlreadyRegistered(numberOfRowsWithTheseCredentials);
  }

  void isUserAlreadyRegistered(int numberOfRowsWithTheseCredentials) {
    if(numberOfRowsWithTheseCredentials == 1) {
      changeLoadingStatus();
      Popups().showBasicPopup(context, Strings.operationUnavailable, Strings.emailAlreadyInUse);
    } else {
      endRegistrationProcess();
    }
  }

  void endRegistrationProcess() {
    PhpMyAdminHelper().addUserToDatabase(email, password);
    endLoggingProcess();
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
        appBar: AppBar(title: Text("Liste des POI locaux"), automaticallyImplyLeading: false, backgroundColor: Colors.amber[900],),
        body: BackButtonManager().handleBackButton(poiListOffline())
    );
  }
}
