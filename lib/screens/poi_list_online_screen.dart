import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/database_helper.dart';
import 'package:ctr2013app/utils/loading_screen.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:ctr2013app/widgets/popup_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as pathPackage;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';

class POIListOnline extends StatefulWidget {
  @override
  _POIListOnlineState createState() => _POIListOnlineState();
}

class _POIListOnlineState extends State<POIListOnline> {

  bool loading = false;

  String currentEmail;

  Directory directory;
  String path;

  List onlineListOfPoi;
  int listLength;

  String currentImage;

  void initState() {
    setCurrentEmail();
    getOnlinePoiData();
  }

  void setCurrentEmail() async {
    String storedEmail = await SharedPreferencesManager().getStringFromKeyInCurrentSession('email');
    setState(() {
      currentEmail = storedEmail;
    });
  }

  // -- Retrieve phpMyAdmin POIs

  Future<List> getOnlinePoiData() async {
    Uri url = Uri.parse('http://ctrapp2013.free.fr/appmpr/retrieve_all_poi_data.php?email=$currentEmail');
    Response response = await get(url);
    onlineListOfPoi = jsonDecode(response.body);
    return onlineListOfPoi;
  }

  // -- POI List Skeleton

  Widget poiListOnline() {
    return Column(
      children: [
        Expanded(child: poiListOnlineFutureHandler()),
      ],
    );
  }

  // -- Build POI list

  Widget poiListOnlineFutureHandler() {
    return FutureBuilder(
      future: getOnlinePoiData(),
      builder: (context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) { return Loading(); }
        else { return poiListWrapperOnline(snapshot.data.length, snapshot.data); }
      },
    );
  }

  Widget poiListWrapperOnline(int receivedListLength, receivedListOfPoi) {
    onlineListOfPoi = receivedListOfPoi;
    listLength = receivedListLength;
    return Column(
      children: [
        SizedBox(height: 10,),
        Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
        Expanded(child: ActualPoiList()),
      ],
    );
  }

  Widget ActualPoiList() {
    return ListView.builder(
      itemCount: listLength,
      itemBuilder: (context, index) {
        currentImage = onlineListOfPoi[index]['image_url'];
        if(currentEmail == onlineListOfPoi[index]['email']) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: poiCard(index),
          );
        }
        else {
          return Container();
        }
      }
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
          children: [Text('POI n°${onlineListOfPoi[index]['id'].toString()}', textAlign: TextAlign.start,)],
        ),
        Divider(height: 20, color: Colors.black, thickness: .5,),
        Text(onlineListOfPoi[index]['village']),
        Text(onlineListOfPoi[index]['lieu']),
        Text(onlineListOfPoi[index]['type']),
        Text(onlineListOfPoi[index]['etat']),
        Text(onlineListOfPoi[index]['notes']),
        Text(onlineListOfPoi[index]['latitude']),
        Text(onlineListOfPoi[index]['longitude']),
      ],
    );
  }

  Widget poiImage() {
    return Image(
      image: NetworkImage('http://ctrapp2013.free.fr/appmpr/poi_images/$currentImage'),
      width: 150,
      height: 150,
    );
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
        appBar: AppBar(title: Text("Liste des POI mis en ligne"), automaticallyImplyLeading: false, backgroundColor: Colors.amber[900],),
        body: BackButtonManager().handleBackButton(poiListOnline())
    );
  }
}
