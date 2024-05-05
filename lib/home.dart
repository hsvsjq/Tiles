import 'package:flutter/material.dart';
import 'package:tile/constants.dart';
import 'package:tile/gameplay.dart';
import 'package:tile/menu.dart';
import 'package:tile/result.dart';
import 'package:tile/touch.dart';

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home>{
  Phase currentPhase = Phase.menu;
  MenuSingleton menuSingleton = MenuSingleton();
  MenuPathSplit Function() menuPathSplit = mainMenu;


  @override
  Widget build(BuildContext context) {
    return       
      Scaffold(
        body: Builder(
          builder: (context){
            switch(currentPhase){
              case Phase.menu:
                return MenuList(menuPathSplit());

              case Phase.gameplay:
                return Gameplay(
                  menuSingleton.gameplayPreset,
                  menuSingleton.makePlayerPreset(),
                  gameplayEndedFunction
                );

              case Phase.customButton:
                return TouchPositionSetting(
                  touchPositionSettingCallback, 
                  menuSingleton.getTouchPositions(6) //6 is the highes keycount (up to now)  ////i probably want to un-hardcode this later
                );

              case Phase.result:
                return ResultScreen(
                  () => setState(() {currentPhase = Phase.menu;}), 
                  () => setState(() {currentPhase = Phase.gameplay;}), 
                  lastResult, 
                  oldPb
                );
            }
          }
        )
      );
  }

  void touchPositionSettingCallback(TapDownDetails tapDownDetails){
    menuSingleton.sharedPreferences.setDouble("customButton${menuSingleton.customPositionKeySelection}X", tapDownDetails.globalPosition.dx);
    menuSingleton.sharedPreferences.setDouble("customButton${menuSingleton.customPositionKeySelection}Y", tapDownDetails.globalPosition.dy);
    setState((){currentPhase = Phase.menu;});
  }


  late ResultData lastResult;
  late ResultData oldPb;

  void gameplayEndedFunction(ResultData resultData){
    lastResult = resultData;
    String? pbStr = menuSingleton.sharedPreferences.getString(resultData.gameplayPreset!.getFullId());
    oldPb = ResultData.fromString(pbStr);

    if(!resultData.compare(oldPb)){ //is pb
      menuSingleton.sharedPreferences.setString(resultData.gameplayPreset!.getFullId(), resultData.getResultString());
    }
  
    //cleared clearCondition
    if(resultData.cleared()){
      GameplayPreset g = resultData.gameplayPreset!;
      EndCondition? e = g.endCondition;
      while(e != null){
        g.endCondition = e;
        //played highest level  
        if(g.noteFrequency.level >= menuSingleton.getHighestNoteFrequencyLevel(g)){
          menuSingleton.increaseNoteFrequencyLevel(g);
        }
        e = g.endCondition.previousEndCondition == null ? null : endConditions[g.endCondition.previousEndCondition!];
      }
    }

    setState(() {currentPhase = Phase.result;}); //update widget
  }

  void exitMenuCallback(Phase phase){
    if(phase == Phase.customButton){
      menuPathSplit = buttonPositionKeyMenu;
    }else{
      menuPathSplit = mainMenu;
    }
    setState(() {currentPhase = phase;});
  }

  @override
  void initState() {
    super.initState();
    menuSingleton.init(exitMenuCallback);
  }
}