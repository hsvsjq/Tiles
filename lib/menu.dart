
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tile/constants.dart' as constants;
import 'package:tile/gameplay.dart';
import 'package:tile/result.dart';
import 'package:tile/touch.dart';

enum Phase{
  mainMenu,
  touchSettingsMenu,
  touchSettingsMenu2,
  touchSettingsPosition,
  settingsMenu,
  scrollSpeedMenu,
  hitPosition,
  noteHeight,
  gameplaySettings,
  gameplay,
  result,
  personalBest,
  personalBestResult
}

enum EndMode{
  missCount,
  noteCount,
  spamMissCount
}

class Home extends StatefulWidget{
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  SharedPreferences? sharedPreferences;
  Phase phase = Phase.mainMenu;

  int gameplaySettingsIndex = 0;
  List<int> currentGameplaySettings = List.generate(constants.gameplaySettings.length, (index) => 0);

  GameplayPreset makeGameplayPreset(){
  
    var keyCount = constants.keyCounts[currentGameplaySettings[0]];
    var endCondition = constants.endConditions[currentGameplaySettings[1]];
    var notePositioningAlgorithm = constants.notePositioningAlgorithms[currentGameplaySettings[2]];
    var noteFrequency = constants.noteFrequencies[currentGameplaySettings[3]];
  
    return GameplayPreset(keyCount, endCondition, notePositioningAlgorithm, noteFrequency);
  }

  PlayerPreset makePlayerPreset(){
    var hpos = sharedPreferences!.getInt("hitPosition");
    var sspeed =  sharedPreferences!.getInt("scrollSpeed");
    var nheight =  sharedPreferences!.getDouble("noteHeight");
    var ctouch =  sharedPreferences!.getBool("customTouch");
    
    ctouch = ctouch ?? false;

    List<TouchPosition>? touchPositions;
    if(ctouch){
       touchPositions = [];

      for(int i = 0; i < constants.keyCounts[currentGameplaySettings[0]].value; i++){
        var x = sharedPreferences!.getDouble("customTouch${i}X");
        var y = sharedPreferences!.getDouble("customTouch${i}Y");
        if(x != null && y != null){
          touchPositions.add(TouchPosition(i, x, y));
        }else {
          touchPositions.add(TouchPosition(i, 0, 0));
        }
      }
    }
    sharedPreferences!.getBool("customTouch");

    return PlayerPreset(2000, hpos == null ? 600 : hpos.toDouble(), sspeed ?? 1500, nheight ?? 60.0, ctouch!, touchPositions);
  }

  void mainMenuFunction(int index){
    switch (index){
      case 0: 
        setState((){phase = Phase.gameplaySettings;});
      case 1:
        setState((){phase = Phase.settingsMenu;});
      case 2:
        setState((){phase = Phase.personalBest;});      
    }
  }

  int touchSettingsMenu2Index = 0;
  int touchSettingsPosition = 0;

  void touchSettingsMenuFunction(int index){
    switch(index){
      case 0: 
        setState((){phase = Phase.mainMenu;});
      case 1: 
        touchSettingsMenu2Index = 1;
        setState((){phase = Phase.touchSettingsMenu2;});
      case 2: 
        touchSettingsMenu2Index = 2;
        setState((){phase = Phase.touchSettingsMenu2;});
    }
  }

  void touchSettingsMenuFunction2(int index){
    if(touchSettingsMenu2Index == 1){
      sharedPreferences!.setBool("customTouch", index == 0);
      setState((){phase = Phase.touchSettingsMenu;});
    }else{
      if(index == 0){
        setState((){phase = Phase.touchSettingsMenu;});
      }else{
        touchSettingsPosition = index - 1;
        setState((){phase = Phase.touchSettingsPosition;});
      }
    }
  }

  void touchPositionSettingCallback(TapDownDetails tapDownDetails){
    sharedPreferences!.setDouble("customTouch${touchSettingsPosition}X", tapDownDetails.globalPosition.dx);
    sharedPreferences!.setDouble("customTouch${touchSettingsPosition}Y", tapDownDetails.globalPosition.dy);
    setState((){phase = Phase.touchSettingsMenu2;});
  }

  void settingsMenuFunction(int index){
    switch (index){
      case 0: 
        setState((){phase = Phase.mainMenu;});
      case 1: 
        setState((){phase = Phase.scrollSpeedMenu;});
      case 2: 
        setState((){phase = Phase.hitPosition;});
      case 3: 
        setState((){phase = Phase.noteHeight;});
      case 4:
        setState((){phase = Phase.touchSettingsMenu;});
    }
  }

  void scrollSpeedMenuFunction(int index){
    setState((){
      sharedPreferences!.setInt("scrollSpeed", constants.scrollSpeeds[index]);
      phase = Phase.settingsMenu;
    });
  }

  void hitPositionFunction(int index){
    setState((){
      sharedPreferences!.setInt("hitPosition", constants.hitPositions[index]);
      phase = Phase.settingsMenu;
    });
  }

  void noteHeightFunction(int index){
    setState((){  
      sharedPreferences!.setDouble("noteHeight", constants.noteHeights[index]);
      phase = Phase.settingsMenu;
    });
  }

  void gameplaySettingsFunction(int index){
    switch (index){
      case 0:
        gameplaySettingsIndex--;
        setState((){}); 
      default: 
        currentGameplaySettings[gameplaySettingsIndex] = index;
        gameplaySettingsIndex++;
        setState((){}); 
    }

    if (gameplaySettingsIndex < 0){
      gameplaySettingsIndex = 0;
      setState((){phase = Phase.mainMenu;}); 
    }
    else if (gameplaySettingsIndex >= constants.gameplaySettings.length){
      gameplaySettingsIndex = 0;
      setState((){phase = Phase.gameplay;}); 
    }
  }

  ResultData? lastResult;
  ResultData? oldPb;

  void gameplayEndedFunction(ResultData resultData){
    lastResult = resultData;
    String? pbStr = sharedPreferences!.getString(resultData.gameplayPreset!.getId());
    if(pbStr != null){
      oldPb = ResultData.fromString(pbStr);
    }

    if(oldPb != null){
      if(oldPb!.compare(resultData)){
        sharedPreferences!.setString(resultData.gameplayPreset!.getId(), resultData.getResultString());
      }
    }else{
      oldPb = ResultData.fromString("0,0,0|0|0");
      sharedPreferences!.setString(resultData.gameplayPreset!.getId(), resultData.getResultString());
    }
  
    setState(() {phase = Phase.result;});
  }

  void resultBackButton(){
    setState(() {phase = Phase.mainMenu;});
  }

  void resultAgainButton(){
    setState(() {phase = Phase.gameplay;});
  }


  int personalBestsIndex = 0;
  List<String> personalBestsValue = [];

  void personalBestFunction(int index){
    switch (index){
      case 0:
        personalBestsIndex--;
        setState((){}); 
      default: 
        if(personalBestsIndex <= constants.gameplaySettings.length){
          currentGameplaySettings[personalBestsIndex] = index;
          personalBestsIndex++;
          setState((){}); 
        }
    }

    if (personalBestsIndex < 0){
      personalBestsIndex = 0;
      setState((){phase = Phase.mainMenu;}); 
    }
    else if (personalBestsIndex >= constants.gameplaySettings.length){
      personalBestsIndex = constants.gameplaySettings.length - 1;
      GameplayPreset gameplayPreset = makeGameplayPreset();
      String score = sharedPreferences!.getString(gameplayPreset.getId()) ?? "0,0,0|0|0";
      String name = gameplayPreset.getName();
      
      personalBestsValue = ["back", "$name - $score"];
      setState((){phase = Phase.personalBestResult;}); 
    }
  }
  
  void personalBestResultFunction(int index){
    if(index == 0){
      setState((){phase = Phase.personalBest;}); 
    }
  }

  @override
  Widget build(BuildContext context) {

    return       
      Scaffold(
        body: Builder(
          builder: (context){
            switch(phase){
              case Phase.mainMenu:
                return MenuList(constants.mainMenuList, mainMenuFunction);
              case Phase.touchSettingsMenu:
                return MenuList(constants.touchSettingsMenu, touchSettingsMenuFunction);
              case Phase.touchSettingsMenu2:
                return MenuList(constants.touchSettingsMenu2[touchSettingsMenu2Index], touchSettingsMenuFunction2);
              case Phase.touchSettingsPosition:
                return TouchPositionSetting(touchPositionSettingCallback);
              case Phase.settingsMenu:
                return MenuList(constants.settingsMenu, settingsMenuFunction);
              case Phase.scrollSpeedMenu:
                return MenuList(constants.scrollSpeedMenu, scrollSpeedMenuFunction);
              case Phase.hitPosition:
                return MenuList(constants.hitPositionMenu, hitPositionFunction);
              case Phase.noteHeight:
                return MenuList(constants.noteHeightMenu, noteHeightFunction);
              case Phase.gameplaySettings: 
                return MenuList(constants.gameplaySettings[gameplaySettingsIndex], gameplaySettingsFunction);
              case Phase.gameplay: 
                return Gameplay(
                  makeGameplayPreset(),
                  makePlayerPreset(),
                  gameplayEndedFunction
                );
              case Phase.result:
                return ResultScreen(resultBackButton, resultAgainButton, lastResult!, oldPb!);
              case Phase.personalBest:
                return MenuList(constants.gameplaySettings[personalBestsIndex], personalBestFunction);
              case Phase.personalBestResult:
                return MenuList(personalBestsValue, personalBestResultFunction);
            }
          }
        )
      );
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
    super.initState();
  }
}

class MenuList extends StatelessWidget{
  const MenuList(this.list, this.function, {super.key});

  final List<String> list;
  final Function(int) function;

  @override
  Widget build(BuildContext context) {
    return 
    ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, position) {
        return TextButton(
          onPressed: () => function(position),
          //make button a rectangle
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
          child: Text(
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            list[position]
          ),
        );
      },
    );
  }
}