import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tile/constants.dart' as constants;
import 'package:tile/menu.dart';
import 'package:tile/result.dart';

class Gameplay extends StatefulWidget{
  const Gameplay(this.gameplayPreset, this.playerPreset, this.gameplayEndedCallback, {super.key});

  final GameplayPreset gameplayPreset;
  final PlayerPreset playerPreset;
  final Function gameplayEndedCallback;

  @override
  State<Gameplay> createState() => _Gameplay();
}

class _Gameplay extends State<Gameplay> with SingleTickerProviderStateMixin{
  
  bool gameplayEnded = false;
  bool? lastNoteEarly; 
  ResultData resultData = ResultData();

  late final globalKeys = List.generate(widget.gameplayPreset.keyCount.value, (i) => ListQueue<GlobalKey<_Note>>());
  late final notes = List.generate(widget.gameplayPreset.keyCount.value, (i) => ListQueue<Note>());
  
  var count = 1;
  late final Size screenSize = MediaQuery.of(context).size;
  late final double columnWidth = screenSize.width / widget.gameplayPreset.keyCount.value;

  late final EndMode endMode = widget.gameplayPreset.endCondition.endMode;
  late final int quota = widget.gameplayPreset.endCondition.quota;

  late final ticker = createTicker((elapsed) { 
    if((elapsed.inMilliseconds - widget.playerPreset.startDelay) ~/ widget.gameplayPreset.noteFrequency.value == count){
      if(endMode == EndMode.noteCount && !gameplayEnded && count >= quota){
        count = -1; //setting this to -1 in order to not enter this section again
        gameplayEnded = true;
        sendNote(true);
        return;
      }
      count += 1;
      sendNote(false);
    }
  });

  void sendNote(bool lastNote){
    Set<int> cols = widget.gameplayPreset.notePositioningAlgorithm.function(count, widget.gameplayPreset.keyCount.value);
    setState(() {
      for (var col in cols) { 
        var gk = GlobalKey<_Note>();
        globalKeys[col].addFirst(gk);
        notes[col].addFirst(Note(widget.playerPreset.noteDuration, columnWidth, widget.playerPreset.noteHeight, col.toDouble(), missCallback, lastNote, key: gk));
      }
    });
  }

  void missCallback(double xpos){
    resultData.missCount++;
    if(endMode == EndMode.missCount && resultData.missCount >= quota){
      endGameplay();
    }else if (endMode == EndMode.spamMissCount && resultData.spamCount + resultData.missCount >= quota){
      endGameplay();
    }
    removeNote(xpos.toInt(), constants.Judgement("miss", 666, 0));
  }

  void hitSpam(){
    resultData.spamCount++;
    if (endMode == EndMode.spamMissCount && resultData.spamCount + resultData.missCount >= quota){
      endGameplay();
    }
  }

  String lastJudgementName = "";

  void removeNote(col, constants.Judgement judgement){
    var last = notes[col].last.lastNote;
    try{
      globalKeys[col].removeLast();
      notes[col].removeLast();
    }catch(e){
      print("");
    }
    setState(() {lastJudgementName = judgement.name;});
    
    if(last){
      endGameplay();
    } 
  }

  void endGameplay(){
    resultData.gameplayPreset = widget.gameplayPreset;
    widget.gameplayEndedCallback(resultData);
  }

  tapDownCallBack(TapDownDetails details){
    double xpos = details.globalPosition.dx;
    int i = 0; 
    for(; i < widget.gameplayPreset.keyCount.value; i++){
      if(xpos < columnWidth * (i + 1)){ 
        break;
      }
    }
    hitColumn(i);
  }

  void hitColumn(int column){
    if(!notes[column].isEmpty){
      double ypos = globalKeys[column].last.currentState!.ypos;
      double distance = ypos  - (widget.playerPreset.hitPosition / screenSize.height);

      double ms = (distance * widget.playerPreset.noteDuration);
      for (int i = 0; i < constants.judgements.length; i++){
        if(ms.abs() <= constants.judgements[i].ms){
          if(i != 0){
            lastNoteEarly = ms < 0;
          }else{
            lastNoteEarly = null;
          }
          resultData.hitCount[i]++;
          removeNote(column, constants.judgements[i]);
          return;
        }
      }  
    }
    hitSpam();
  }

  @override
  void initState() {
    super.initState();
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        MultiTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<MultiTapGestureRecognizer>(
          () => MultiTapGestureRecognizer(),
          (MultiTapGestureRecognizer instance) {
            instance.onTapDown =(pointer, details) {
              tapDownCallBack(details);
            };
          },  
        ),
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: widget.playerPreset.hitPosition,
              child: SizedBox(
                width: screenSize.width, 
                height: 5, 
                child: Image.asset(
                  'assets/p.png',
                  fit: BoxFit.fill,
                ),
              )
            ),
            Positioned(
              top: 300,
              left: screenSize.width / 2 - 45,
                child: Text(
                  lastJudgementName,
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2)
                ),
            ),
            Positioned(
              top: 300,
              left: screenSize.width / 2 + 45,
                child: Text(
                  (lastNoteEarly == null ? "" : (lastNoteEarly! ? "early" : "late")),
                  style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5)
                ),
            ),
            Positioned(
              child: SizedBox(
                width: screenSize.width, 
                height: screenSize.height, 
                child: Stack(
                  children: notes.expand((pair) => pair).toList()
                ),
              )
            ), 
          ]
        )
      )   
    );
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }
}


class Note extends StatefulWidget{
  const Note(this.duration, this.width, this.height, this.xpos, this.missCallback, this.lastNote, {super.key});

  final int duration;
  final double width;
  final double height;
  final double xpos;
  final Function missCallback;
  final bool lastNote;
  
  @override
  State<Note> createState() => _Note();
}

class _Note extends State<Note> with SingleTickerProviderStateMixin {
  bool hit = false;
  double ypos = 0;

  late final AnimationController _controller = AnimationController(
    duration: Duration(milliseconds: widget.duration),
    vsync: this,
  )..addListener(() {
    ypos = _controller.value;
  })
  ..forward()
  .whenComplete(() {
    if(!hit) {widget.missCallback(widget.xpos);}
  });

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset(widget.xpos, -1.0),
    end: Offset(widget.xpos, ((MediaQuery.of(context).size.height) / widget.height)),
  ).animate(_controller);


  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: SizedBox(
        width: widget.width, 
        height: widget.height, 
        child: Image.asset(
          'assets/p.png',
          fit: BoxFit.fill,
        ),
      )
    );
  }

  @override 
  void dispose() { 
    _controller.dispose(); 
    super.dispose(); 
  } 
} 


class GameplayPreset{
  GameplayPreset(this.keyCount, this.endCondition, this.notePositioningAlgorithm, this.noteFrequency);

  final constants.KeyCount keyCount;
  final EndCondition endCondition;
  final NotePositioningAlgorithm notePositioningAlgorithm;
  final constants.NoteFrequency noteFrequency;

  String getName(){
    return "${keyCount.name} | ${endCondition.name} | ${notePositioningAlgorithm.name} | ${noteFrequency.name}";
  }

  String getId(){
    return "${keyCount.id}${endCondition.id}${notePositioningAlgorithm.id}${noteFrequency.id}";
  }
}

class PlayerPreset{
  PlayerPreset(this.startDelay, this.hitPosition, this.noteDuration, this.noteHeight);
  final int noteDuration;
  final double hitPosition;
  final double noteHeight;
  final int startDelay;
}

class NotePositioningAlgorithm{
  NotePositioningAlgorithm(this.id, this.name, this.function);

  final String id;
  final String name;
  final Function(int, int) function;
}

class EndCondition{
  EndCondition(this.id, this.name, this.endMode, this.quota);

  final String id;
  final String name;
  final EndMode endMode;
  final int quota;
}
