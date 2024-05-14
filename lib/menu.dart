
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tile/constants.dart';
import 'package:tile/gameplay.dart';

class MenuList extends StatefulWidget{
  const MenuList(this.menuPathSplit, {super.key});

  final MenuPathSplit menuPathSplit;

  @override
  State<StatefulWidget> createState() => _MenuList();
}

class _MenuList extends State<MenuList>{
  late MenuPathSplit currentMenu = widget.menuPathSplit;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: currentMenu.nextPaths.length,
      itemBuilder: (context, position) {
        return TextButton(
          onPressed: () {
            if(currentMenu.nextPaths[position].callbackFunction != null){
              currentMenu.nextPaths[position].callbackFunction!(currentMenu.nextPaths[position].value);
            }
            setState(() {currentMenu = currentMenu.nextPaths[position].nextPathSplit() ?? currentMenu;});
          },
          //make button a rectangle
          style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
          child: Text(
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
            currentMenu.nextPaths[position].text
          ),
        );
      },
    );
  }
}

class MenuPathSplit<E>{
  MenuPathSplit(this.nextPaths);
  final List<MenuPath<E>> nextPaths;
}

class MenuPath<E>{
  MenuPath(this.text, this.value, this.callbackFunction, this.nextPathSplit);

  final String text;
  final E? value;
  final Function? callbackFunction;
  final MenuPathSplit? Function() nextPathSplit;
}

enum Phase{
  menu,
  gameplay,
  customButton,
  result,
}

class MenuSingleton{
  static final MenuSingleton _singleton = MenuSingleton._internal();
  
  factory MenuSingleton() { return _singleton; }
  MenuSingleton._internal();

  late SharedPreferences sharedPreferences;
  late GameplayPreset gameplayPreset;
  late Function(Phase) exitMenuCallback;

  void init(Function(Phase) func){
    exitMenuCallback = func;
    SharedPreferences.getInstance().then((value) {
      sharedPreferences = value;
      customButtonSize = sharedPreferences.getDouble("customButtonSize") ?? 40.0;
    });
    gameplayPreset = GameplayPreset(keyCounts[0], notePositioningAlgorithms[keyCounts[0]]![0], endConditions[0], NoteFrequency("10", "default", 1000, 0));
  }

  PlayerPreset makePlayerPreset(){
    var hpos = sharedPreferences.getInt("hitPosition");
    var sspeed = sharedPreferences.getInt("scrollSpeed");
    var nheight = sharedPreferences.getDouble("noteHeight");
    var ctouch = sharedPreferences.getBool("useCustomButtonPositions");
    var cbuttonsize = sharedPreferences.getDouble("customButtonSize");
    var nimagepath = sharedPreferences.getString("noteImage");
    var nmulticolor = sharedPreferences.getBool("multicolouredNotes");
    var quarterRotations = sharedPreferences.getInt("quarterRotations");
    var widthPercentage = sharedPreferences.getDouble("widthPercentage");

    quarterRotations = quarterRotations ?? 0;
    widthPercentage = widthPercentage ?? 1;

    nimagepath = nimagepath ?? "rectangle";

    ctouch = ctouch ?? false;
    nmulticolor = nmulticolor ?? false;
    List<TouchPosition>? touchPositions;
    if(ctouch){
       touchPositions = getTouchPositions(gameplayPreset.keyCount.value);
    }

    return PlayerPreset(2000, hpos == null ? 80 : hpos.toDouble(), sspeed ?? 1500, nheight ?? 40.0, ctouch, touchPositions, cbuttonsize ?? 40, nmulticolor, nimagepath, quarterRotations, widthPercentage);
  }

  List<TouchPosition> getTouchPositions(int count){
    count--;
    List<TouchPosition> touchPositions = [];
    for(int i = 0; i < keyCounts[count].value; i++){
      var x = sharedPreferences.getDouble("customButton${i}X");
      var y = sharedPreferences.getDouble("customButton${i}Y");
      if(x != null && y != null){
        touchPositions.add(TouchPosition(i, x, y));
      }else {
        touchPositions.add(TouchPosition(i, 0, 0));
      }
    }
    return touchPositions;
  }

  int getHighestNoteFrequencyLevel(GameplayPreset gPreset){
    String id = gPreset.getId();
    int level = sharedPreferences.getInt("level$id") ?? 5;
    return level;
  }

  void increaseNoteFrequencyLevel(GameplayPreset gPreset){
    String id = gPreset.getId();
    sharedPreferences.setInt("level$id", gPreset.noteFrequency.level + 1);
  }

  void keyCountSelectCallback(KeyCount keyCount){
    gameplayPreset.keyCount = keyCount;
  }
  
  void notePositioningAlgorithmSelectCallback(NotePositioningAlgorithm notePositioningAlgorithm){
    gameplayPreset.notePositioningAlgorithm = notePositioningAlgorithm;
  }

  void endConditionSelectCallback(EndCondition endCondition){
    gameplayPreset.endCondition = endCondition;
  }

  void noteFrequencySelectCallback(NoteFrequency noteFrequency){
    gameplayPreset.noteFrequency = noteFrequency;
    exitMenuCallback(Phase.gameplay);
  }

  void scrollSpeedSelectCallback(int scrollSpeed){
    sharedPreferences.setInt("scrollSpeed", scrollSpeed);
  }

  void hitPositionSelectCallback(int hitPosition){
    sharedPreferences.setInt("hitPosition", hitPosition);
  }

  void noteHeightSelectCallback(double noteHeight){
    sharedPreferences.setDouble("noteHeight", noteHeight);
  }

  void useCustomPositionSelectCallback(bool value){
    sharedPreferences.setBool("useCustomButtonPositions", value);
  }

  double customButtonSize = 40; //this is here because of the preview

  void buttonSizeSelectCallback(double value){
    customButtonSize = value;
    sharedPreferences.setDouble("customButtonSize", value);
  }

  int customPositionKeySelection = 0;

  void customPositionKeySelectCallback(int key){
    customPositionKeySelection = key - 1;
    exitMenuCallback(Phase.customButton);
  }

  void noteImagesMulticolouredSelectCallback(bool b){
    sharedPreferences.setBool("multicolouredNotes", b);
  }

  void noteImagesSelectCallback(String s){
    sharedPreferences.setString("noteImage", s);
  }

  void playfieldWidthSelectCallback(double d){
    sharedPreferences.setDouble("widthPercentage", d);
  }

  void playfieldRotationSelectCallback(int i){
    sharedPreferences.setInt("quarterRotations", i);
  }
}


MenuPathSplit mainMenu() => MenuPathSplit([
  MenuPath("play", null, null, keyCountMenu),
  MenuPath("settings", null, null, settingsMenu),
]);


MenuPathSplit keyCountMenu() => MenuPathSplit([
  MenuPath("back", null, null, mainMenu), 
  ...keyCounts.map((e) => MenuPath(e.name, e, MenuSingleton().keyCountSelectCallback, notePositioningAlgorithmMenu)),
]);


MenuPathSplit notePositioningAlgorithmMenu() => MenuPathSplit([
  MenuPath("back", null, null, keyCountMenu), 
  ...notePositioningAlgorithms[MenuSingleton().gameplayPreset.keyCount]!.map((e) => MenuPath(e.name, e, MenuSingleton().notePositioningAlgorithmSelectCallback, endConditionMenu)),
]);


MenuPathSplit endConditionMenu() => MenuPathSplit([
  MenuPath("back", null, null, notePositioningAlgorithmMenu), 
  ...endConditions.map((e) => MenuPath(e.name, e, MenuSingleton().endConditionSelectCallback, noteFrequencyMenu)),
]);


MenuPathSplit noteFrequencyMenu() => MenuPathSplit([
  MenuPath("back", null, null, endConditionMenu), 
  ...noteFrequencies(MenuSingleton().getHighestNoteFrequencyLevel(MenuSingleton().gameplayPreset)).map((e) => MenuPath(e.name, e, MenuSingleton().noteFrequencySelectCallback, () => null)),
  MenuPath("<blocked>", null, null, noteFrequencyMenu), 
  ...acceleratingNoteFrequencies.map((e) => MenuPath(e.name, e, MenuSingleton().noteFrequencySelectCallback, () => null)),
]);



//-----------------------------------------------------------------

MenuPathSplit settingsMenu() => MenuPathSplit([
  MenuPath("back", null, null, mainMenu),
  MenuPath("scroll speed", null, null, scrollSpeedMenu),
  MenuPath("hit position", null, null, hitPositionMenu),
  MenuPath("note height", null, null, noteHeightMenu),
  MenuPath("button positions", null, null, buttonPositionMenu),
  MenuPath("note images", null, null, noteImagesMenu),
  MenuPath("playfield width", null, null, playfieldWidthMenu),
  MenuPath("playfield rotation", null, null, playfieldRotationMenu),
]);



MenuPathSplit scrollSpeedMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  ...scrollSpeeds.map((e) => MenuPath(e.toString(), e, MenuSingleton().scrollSpeedSelectCallback, settingsMenu))
]);


MenuPathSplit hitPositionMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  ...hitPositions.map((e) => MenuPath(e.toString(), e, MenuSingleton().hitPositionSelectCallback, settingsMenu))
]);



MenuPathSplit noteHeightMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  MenuPath("square", 0, MenuSingleton().noteHeightSelectCallback, settingsMenu),
  ...noteHeights.map((e) => MenuPath(e.toString(), e, MenuSingleton().noteHeightSelectCallback, settingsMenu)),
  
]);


MenuPathSplit buttonPositionMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  MenuPath("use custom position", null, null, () =>
    MenuPathSplit([
      MenuPath("back", null, null, buttonPositionMenu),
      MenuPath("true", true, MenuSingleton().useCustomPositionSelectCallback, buttonPositionMenu),
      MenuPath("false", false, MenuSingleton().useCustomPositionSelectCallback, buttonPositionMenu),
    ])
  ),
  MenuPath("button size", null, null, buttonSizeMenu),
  MenuPath("custom position", null, null, buttonPositionKeyMenu),
]);

MenuPathSplit buttonSizeMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  ...buttonSizes.map((e) => MenuPath(e.toString(), e, MenuSingleton().buttonSizeSelectCallback, buttonPositionMenu))
]);

MenuPathSplit buttonPositionKeyMenu() => MenuPathSplit([
  MenuPath("back", null, null, buttonPositionMenu),
  ...keyCounts.map((e) => MenuPath("key ${e.value}", e.value, MenuSingleton().customPositionKeySelectCallback, () => null))
]);

MenuPathSplit noteImagesMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  MenuPath("use multicoloured notes", null, null, () =>
    MenuPathSplit([
      MenuPath("back", null, null, buttonPositionMenu),
      MenuPath("true", true, MenuSingleton().noteImagesMulticolouredSelectCallback, noteImagesMenu),
      MenuPath("false", false, MenuSingleton().noteImagesMulticolouredSelectCallback, noteImagesMenu),
    ])
  ),
  ...noteImagePaths.map((e) => MenuPath(e, e, MenuSingleton().noteImagesSelectCallback, settingsMenu)),
]);

MenuPathSplit playfieldWidthMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  ...playfieldWidths.map((e) => MenuPath("${e * 100}%", e, MenuSingleton().playfieldWidthSelectCallback, settingsMenu)),
]);

MenuPathSplit playfieldRotationMenu() => MenuPathSplit([
  MenuPath("back", null, null, settingsMenu),
  MenuPath("0", 0, MenuSingleton().playfieldRotationSelectCallback, settingsMenu),
  MenuPath("90", 1, MenuSingleton().playfieldRotationSelectCallback, settingsMenu),
  MenuPath("180", 2, MenuSingleton().playfieldRotationSelectCallback, settingsMenu),
  MenuPath("270", 3, MenuSingleton().playfieldRotationSelectCallback, settingsMenu),
]);