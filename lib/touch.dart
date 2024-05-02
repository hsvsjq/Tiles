
import 'package:flutter/material.dart';


class TouchPositionSetting extends StatefulWidget{
  const TouchPositionSetting(this.callback, {super.key});

  final Function(TapDownDetails) callback;

  @override
  State<TouchPositionSetting> createState() => _TouchPositionSetting();
}

class _TouchPositionSetting extends State<TouchPositionSetting>{

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTapDown: (TapDownDetails details) => widget.callback(details),
      child: Stack(
        fit: StackFit.expand, 
        children: <Widget>[
          Positioned(
            child: Text(
              "tap in the desired position",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),
            ),
          )
        ]
      ),
    );
  }
}