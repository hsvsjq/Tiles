import 'package:flutter/material.dart';
import 'package:tile/home.dart';


//todo
//player preferences
//  skin
//    each column has one note color
//    circles
//    random images
//  no more than x notes jack
//other gameplay rules
//  change note frequency mid gameplay  
//    change note frequency AND scroll speed
//make it easier to visualize what the numbers of the player presets represent


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



