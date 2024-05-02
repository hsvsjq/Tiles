import 'package:flutter/material.dart';
import 'package:tile/menu.dart';


//todo
//implement menu options 
//  pattern
//    jump hand alternate
//    random chords
//Gameplay
//  accuracy early late 
//player preferences
//  skin
//    each column has one note color
//  note height
//  no more than x notes jack
//other gameplay rules
//  change scroll speed mid gameplay  ?? maybe scrap this ??
//    probably will have to change hit area according to speed
//allow to set press position anywhere
//  goal: make it easier to use 5 fingers on a small screen




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}



