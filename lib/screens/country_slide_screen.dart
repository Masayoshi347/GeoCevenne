import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class CountrySlideScreen extends StatefulWidget {
  const CountrySlideScreen({Key key}) : super(key: key);

  @override
  _CountrySlideScreenState createState() => _CountrySlideScreenState();
}

class _CountrySlideScreenState extends State<CountrySlideScreen> {
  @override
  Widget build(BuildContext context) {
    return BackButtonManager().handleBackButton(Scaffold(
      backgroundColor: Colors.amber[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pays et territoire cévennol', style: TextStyle(fontSize: 30.0),),
          SizedBox(height: 10,),
          Divider(color: Colors.black,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ImageSlideshow(
                indicatorColor: Colors.amber,
                children: [
                  Image.asset(
                    'assets/country_slide/01.jpg',
                    fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/02.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/03.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/04.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/05.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/06.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/07.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/08.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/09.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/10.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/11.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/12.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/13.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/14.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/15.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/16.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/17.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/18.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/19.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/20.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/21.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/22.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/23.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/24.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/25.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/26.jpg',
                      fit: BoxFit.cover
                  ),
                  Image.asset(
                      'assets/country_slide/27.jpg',
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
