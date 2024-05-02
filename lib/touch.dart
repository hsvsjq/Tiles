
import 'package:flutter/material.dart';
import 'package:tile/gameplay.dart';


class TouchPositionSetting extends StatefulWidget{
  const TouchPositionSetting(this.callback, this.touchPositions, {super.key});

  final Function(TapDownDetails) callback;
  final List<TouchPosition> touchPositions;

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
          ),
          Stack(
            children: widget.touchPositions.map((pair) => pair.getButton((int s) => {})).toList()
          )
        ]
      ),
    );
  }
}