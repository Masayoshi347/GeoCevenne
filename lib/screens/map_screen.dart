import 'dart:io';
import 'package:ctr2013app/utils/loading_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as pathPackage;
import 'package:ctr2013app/constants/strings.dart';
import 'dart:async';
import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/screens/register_poi_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/utils/database_helper.dart';
import 'package:ctr2013app/utils/navigation_manager.dart';
import 'package:ctr2013app/utils/shared_preferences_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:ctr2013app/widgets/popup_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:path_provider/path_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  List<Marker> markers = [];
  List<CircleMarker> circleMarkers = [];
  List<Map<String, dynamic>> markerData = [];
  LatLng userMarkerPosition;

  LatLng center;

  Directory directory;
  List<Map<String, dynamic>> allRows = [];

  String path;
  String currentImage;

  int i = 0;

  MapController mapController = MapController();

  static const String mapUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  static const List<String> subdomains = ['a', 'b', 'c'];

  bool previousMarker = false;

  @override
  void initState() {
    getImageDirectory();
    getPOIInfoFromDatabase();
  }

  Future<List<Map<String, dynamic>>> getRows() async {
    allRows = await DatabaseHelper.instance.queryAll();
    return allRows;
  }

  Future<Directory> getImageDirectory() async {
    directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  void getPOIInfoFromDatabase() async {
    markerData = await getRows();
    placeDatabaseMarkersOnMap(markerData);
  }

  void placeDatabaseMarkersOnMap(receivedMarkerData) {
    for(var currentMarker in receivedMarkerData) {
      currentImage = currentMarker['image_url'];
      LatLng currentMarkerPosition = stringsToLatLng(currentMarker['latitude'], currentMarker['longitude']);
      addSimpleMarker(currentMarkerPosition);
    }
  }

  // -- Layout --

  Widget mapScreenLayout(receivedCurrentLocation) {
    setCurrentLocation();
    return Stack(
      children: [
        mainMap(receivedCurrentLocation),
        infoBarWrapper(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [rowOfButtons()],
          ),
        )
      ],
    );
  }

  List<Widget> listOfContextualButtons() {
    List<Widget> allButtons = [
      backButtonWrapper(),
      SizedBox(width: 40,),
      Buttons().simpleActionFloatingButton(CupertinoIcons.square_split_2x2, "center", recenterOnUserCurrentLocation),
      SizedBox(width: 40,),
      proceedButtonWrapper()
    ];
    return allButtons;
  }

  Widget rowOfButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: listOfContextualButtons(),
    );
  }

  // -- Map --

  Widget mainMap(receivedCurrentLocation) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
          center: receivedCurrentLocation,
          onTap: addSoleMapMarker
      ),
      layers: [
        TileLayerOptions(urlTemplate: mapUrl, subdomains: subdomains),
        MarkerLayerOptions(markers: markers),
        CircleLayerOptions(circles: circleMarkers)
      ],
    );
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Position lastKnowPosition = await Geolocator.getLastKnownPosition();
    return position;
  }

  void setCurrentLocation() async {
    Position currentLocation = await getCurrentLocation();
    if(!mounted) return;
    setState(() {
      center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    if(i < 1) {
      addCircleMarker(center);
      mapController.move(center, 15.0);
      i++;
    }
  }

  // -- Marker management --

  void addSimpleMarker(LatLng latlng) {
    markers.add(
        simpleMarker(latlng)
    );
    setState(() {});
  }

  Marker simpleMarker(LatLng latlng) {
    return Marker(
        width: 50.0, height: 50.0,
        point: latlng,
        builder: (ctx) => createMarkerIcon()
    );
  }

  void addNoInfoMarker(LatLng latlng) {
    markers.add(
        noInfoMarker(latlng)
    );
    setState(() {});
  }

  Marker noInfoMarker(LatLng latlng) {
    return Marker(
        width: 40.0, height: 40.0,
        point: latlng,
        builder: (ctx) => IconButton(icon: Image(image: AssetImage('assets/icons/marker.png')), onPressed: () {},)
    );
  }

  addCircleMarker(LatLng latlng) {
    circleMarkers.add(
      circleMarker(latlng)
    );
    setState(() {});
  }

  circleMarker(LatLng latlng) {
    return CircleMarker(
        point: latlng,
        color: Colors.blue.withOpacity(0.7),
        borderStrokeWidth: 2,
        useRadiusInMeter: true,
        radius: 15
    );
  }

  void addSoleMapMarker(LatLng latlng) {
    if(previousMarker == false) {
      addNoInfoMarker(latlng);
      previousMarker = true;
    } else {
      markers.remove(markers.last);
      addNoInfoMarker(latlng);
    }
    userMarkerPosition = latlng;
  }

  LatLng stringsToLatLng(String latitude, String longitude) {
    double newLatitude = double.parse(latitude);
    double newLongitude = double.parse(longitude);
    LatLng currentMarkerPosition = LatLng(newLatitude, newLongitude);
    return currentMarkerPosition;
  }

  Widget createMarkerIcon() {
    return IconButton(
        onPressed: showMarkerMenu,
        icon: Image(image: AssetImage('assets/icons/marker.png'))
    );
  }

  void showMarkerMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return buildMarkerMenu();
        },
    );
  }

  Widget buildMarkerMenu() {
    path = pathPackage.join(directory.path, currentImage);
    return Container(
      color: Colors.white,
      height: 250,
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Image.file(File(path)),
                  ),
                ],
            )
          ],
        ),
      ),
    );
  }

  // -- Other widgets --

  Widget infoBarWrapper() {
    return Opacity(
      opacity: 0.8,
      child: infoBar(),
    );
  }

  Widget infoBar() {
    return Container(
      color: Colors.amber[900],
      height: 120,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: infoBarText(Strings.mapInfoBar),
    );
  }

  Widget infoBarText(String text) {
    return Text(
      text, style: TextStyle(color: Colors.white), textAlign: TextAlign.justify,
    );
  }

  Widget backButtonWrapper() {
    return Container(
      child: Buttons().changeScreenFloatingButton(context, "back", Icons.keyboard_arrow_left, HomeScreen()),
    );
  }

  Widget proceedButtonWrapper() {
    return Container(
      child: Buttons().simpleActionFloatingButton(Icons.check, "proceed", checkIfMarkerIsPlacedOnMap),
    );
  }
  
  // -- Other functions --
  
  void recenterOnUserCurrentLocation() {
    mapController.move(center, 15.0);
  }

  void checkIfMarkerIsPlacedOnMap() {
    if(userMarkerPosition == null) {
      Popups().showBasicPopup(context, "Pas de marqueur", "Vous devez placer un marqueur avant de pouvoir continuer.");
    }
    else {
      enterPOIRegistration();
    }
  }

  void enterPOIRegistration() {
    SharedPreferencesManager().addStringToCurrentSession('userMarkerPositionLatitude', userMarkerPosition.latitude.toString());
    SharedPreferencesManager().addStringToCurrentSession('userMarkerPositionLongitude', userMarkerPosition.longitude.toString());
    NavigationManager().changeScreen(context, RegisterPOIScreen());
  }

  @override
  Widget build(BuildContext context) {

    LatLng currentLatLng;

    return Scaffold(
      body: BackButtonManager().handleBackButton(mapScreenLayout(center))
    );
  }
}
