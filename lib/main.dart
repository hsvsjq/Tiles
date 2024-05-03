import 'package:flutter/material.dart';
import 'package:tile/home.dart';


//todo
//implement menu options 
//  pattern
//    jump hand alternating
//    random chords
//player preferences
//  skin
//    each column has one note color
//    circles
//    random images
//  note height
//  no more than x notes jack
//other gameplay rules
//  change note frequency mid gameplay  
//    change note frequency AND scroll speed
//    change note frequency but NOT scroll speed 
//allow to set press position anywhere
//  make the size of the buttons adjustable
//  make a preview of what is the current position of the buttons
//    make it easier to visualizer what the numbers of the others player presets represent aswell
//menu
//  refactor menus !!! 
//  make the speeds = "levels" and make them continue indefinitely
//    make the unlock system of the "levels"
//gameplay
//  find a way to split the changing (notes and jugdements) parts and nonchanging (hit position hint and buttons) parts of the gameplay widget improve the performance



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



