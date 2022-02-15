import 'dart:ui';

import 'package:ctr2013app/screens/home_screen.dart';
import 'package:ctr2013app/screens/objects_slide_screen.dart';
import 'package:ctr2013app/utils/back_button_manager.dart';
import 'package:ctr2013app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class GlossaryScreen extends StatelessWidget {
  const GlossaryScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButtonManager().handleBackButton(
      Scaffold(
        backgroundColor: Colors.amber[200],
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 64, 16, 0),
                child: Column(
                  children: [
                    Buttons().changeScreenButton(context, "Diaporama des objets", ObjectsSlideScreen()),
                    Buttons().changeScreenButton(context, "Retour au menu principal", HomeScreen()),
                    SizedBox(height: 20,),
                    Text('Glossaire des objets', style: TextStyle(fontSize: 30),),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le tancat : ouvrage défensif en pierres, petit muret, disposé à flanc de colline, en travers de la pente, là où le risque est important d’affouillement et d’endommagement par l'eau des terrains cultivés (plantations de mûriers et châtaigneraies). Pour écrêter les torrents qui peuvent se former en cas de forte pluie, ce sont de véritables murailles en pierre sèche qui ont été érigées dans leur lit, à la seule force de bras et de leviers.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La digue : ouvrage massif en pierre, construit latéralement sur la berge d'une rivière pour dévier et freiner le flux torrentiel d'une crue. Il permet de limiter l'inondation et surtout d'empêcher l'érosion, parfois brutale, des terres de culture ou de pâture situées en aval.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La chaussée : seuil, barrage bâti en pierre haut de plusieurs mètres dans le lit d'une rivière; remontant le niveau d'eau et incurvé à l'une ou l'autre des extrémités, il permet la prise d'eau d'un canal pour remplir le réservoir d'un moulin, et assurer l'irrigation des prés et des cultures.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le béal : canal alimenté par une chaussée, aménagé sur des centaines de mètres de rive d'un cours d'eau; il débouche en aval sur un réseau de distribution gravitaire muni de vannes. Chaussée et beals étaient utilisés et entretenus, parfois collectivement au sein d'un syndicat, par des propriétaires ayant-droits.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    L'aqueduc : ouvrage hydraulique assurant la continuïté d'un béal au dessus d'un cours d'eau, d'un chemin ou d'une route. Il permet parfois aussi le passage piétonner sur ses côtés ou au dessus lorsqu'il est couvert.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le moulin (à eau) : moulin à grain et/ou à huile, à châtaigne omniprésent en Cévennes, utilisant une roue à pales, horizontale, alimentée par l'eau d'un réservoir (gourgue).", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La mine d'eau : une excavation dans le rocher, à la recherche des suintements et écoulements naturels de l'eau; une galerie étroite creusée à l'horizontale dans une colline qui permet d'alimenter un réservoir pour l'irrigation et l'adduction des habitations en eau potable", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La gourgue : une retenue d'eau construite (bassin, réservoir). Alimentée par une source pour l'adduction de l'eau domestique, il sera protégé, couvert d'une voûte en pierre; alimenté par une prise et un béal pour l'arrosage des cultures et/ou l'alimentation d'un moulin, il restera à l'air libre.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La clède : bâti agricole caractéristique de la production de châtaignes en Cévennes; souvent à l'écart des habitations, il comprend à l'étage une pièce pour le séchage des fruits à la chaleur d'un feu de bois qui couve avant le décorticage (manuel, ou mécanique par le pissaïre, moulin à décortiquer).", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le mazet : petite construction sur une parcelle de culture servant de remise et d'atelier; et aussi petit bâti dans les vignes (Brunet)", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    L'aire (à battre) : emplacement réservé près des habitations (plus rarement près des champs) pour battre les épis de céréales (seigle, orge), soit avec des fléaux, soit en faisant piétiner une mûle, ou encore en écrasant les gerbes avec un rouleau. L'espace plat est dallé en lauzes jointives pour faciliter le ramassage des grains sans être souillés par la terre.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le bancel : terrasse, parcelle de terre cultivable horizontale, aménagée dans la pente d'un coteau; elle s'accompagne toujours en bordure aval d'un mur de soutènement en pierre sèche, et d'un système d'écoulement latéral des eauxlimitant l'érosion", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Les escaliers : ils sont bâtis dans les parcelles cultivées pour rendre plus court et plus facile l'accès aux bancels sans devoir les contourner. Le plus courant est l'escalier intégré, construit dans le mur, pris dans son épaisseur ; moins fréquent, l'escalier dit “volant”, déporté du mur, avec de grandes pierres plates en saillie ; plus rare encore, l'escalier traversant, face à la pente", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La calade : chemin piétonnier ou muletier, éventuellement carrossable, conduisant d'un hameau à l'autre, empierré 'en délit' (sur champ) pour être stabilisé et protégé du ravinement.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le ponceau : petit pont voûté en pierre à une seule arche (de type romain), permettant de passer au dessus d'un obstacle (fossé, ruisseau, chemin, route). Il supporte parfois une canalisation d'eau (aqueduc).", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    Le pont moutonnier : pont bâti en pierre suffisamment large pour sécuriser le passage de grands troupeaux transhumants (plusieurs centaines de bêtes) allant à l'estive en été; plus généralement un pont régulièrement fréquenté par les animaux d'élevage.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 10,),
                    Divider(color: Colors.black,),
                    SizedBox(height: 10,),
                    Text("    La jasse : bergerie isolée située sur les versants ou les crêtes, utilisée quelques semaines à l'automne et au printemps, lorsque le troupeau de chèvres ou de moutons doit pâturer loin des cultures et des zones habitées.", style: TextStyle(fontSize: 20), textAlign: TextAlign.justify,),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
