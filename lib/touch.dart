
import 'package:flutter/material.dart';

class TouchPositionSetting extends StatelessWidget{
  const TouchPositionSetting(this.callback, {super.key});

  final Function(TapDownDetails) callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTapDown: (TapDownDetails details) => callback(details),
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Container(color: Colors.white),
        Positioned(
          child: Text("Txt"), 
          left: 0,
          top: 0,
        )
      ]),
    );
  }
}