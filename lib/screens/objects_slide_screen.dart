import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ObjectsSlideScreen extends StatefulWidget {
  const ObjectsSlideScreen({Key key}) : super(key: key);

  @override
  _ObjectsSlideScreenState createState() => _ObjectsSlideScreenState();
}

class _ObjectsSlideScreenState extends State<ObjectsSlideScreen> {
  @override
  Widget build(BuildContext context) {
    return BackButtonManager().handleBackButton(Scaffold(
      backgroundColor: Colors.amber[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Les objets du patrimoine', style: TextStyle(fontSize: 30.0),),
          SizedBox(height: 10,),
          Divider(color: Colors.black,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageSlideshow(
                indicatorColor: Colors.amber,
                children: [
                  Image.asset(
                      'assets/objects_slide/01.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/02.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/03.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/04.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/05.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/06.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/07.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/08.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/09.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/010.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/011.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/012.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/013.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/014.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/015.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/016.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/017.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/objects_slide/018.jpg',
                      fit: BoxFit.cover
                  ),
                ]
            ),
          ),
          Divider(color: Colors.black,),
          Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
        ],
      ),
    ));
  }
}
