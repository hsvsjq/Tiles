
import 'package:tile/gameplay.dart';
import 'package:tile/menu.dart';
import 'package:tile/util.dart';
import 'dart:math' as math;

List<String> mainMenuList = [
  "play",
  "settings",
  "personal best",
];

List<String> touchSettingsMenu = [
  "back",
  "use custom position",
  "custom positions",
];

List<List<String>> touchSettingsMenu2 = [
  [],
  ["true", "false"],
  ["back", "key 1", "key 2", "key 3", "key 4", "key 5", "key 6"],
];

List<String> settingsMenu = [
  "back",
  "scroll speed",
  "hit position",
  "note height",
  "button positions",
];

//player preset----------------------------------------------------------------------------------------
List<String> scrollSpeedMenu = scrollSpeeds.map((e) => "${e / 1000} second").toList();

List<int> scrollSpeeds = [
  2000, 1900, 1800, 1700, 1600, 1500, 1400, 1300, 1200, 1100, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100,
];

List<String> hitPositionMenu = hitPositions.map((e) => "$e").toList();

List<int> hitPositions = [
  300, 325, 350, 375, 400, 425, 450, 475, 500, 525, 550, 575, 600, 625, 650, 675, 700
];

List<String> noteHeightMenu = noteHeights.map((e) => e.toString()).toList();

List<double> noteHeights = [
  80.0, 70.0, 60.0, 50.0, 40.0, 30.0, 20.0, 10.0, 1.0, 
];



//-----------------------------------------------------------------------------------------------------


//gampley presets--------------------------------------------------------------------------------------
//do not change the ids to preserve stored data index

List<List<String>> gameplaySettings = [
  keyCounts.map((e) => e.name).toList(),
  endConditions.map((e) => e.name).toList(),
  notePositioningAlgorithms.map((e) => e.name).toList(),
  noteFrequencies.map((e) => e.name).toList(),
];

List<NotePositioningAlgorithm> notePositioningAlgorithms = [
  NotePositioningAlgorithm("00", "back", (count, keyCount) => {}),
  NotePositioningAlgorithm("01", "single stream", (count, keyCount) => {math.Random().nextInt(keyCount)}), 
  NotePositioningAlgorithm("02", "1/4 jump stream",
    (count, keyCount) { return  (count % 4 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("03", "1/3 jump stream",
    (count, keyCount) { return  (count % 3 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("04", "1/2 jump stream",
    (count, keyCount) { return  (count % 2 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("05", "1/1 jump stream",
    (count, keyCount) { return  (getUniqueRandomNumbers(2, keyCount)).toSet(); }
  ), 
  NotePositioningAlgorithm("06", "1/4 hand stream",
    (count, keyCount) { return  (count % 4 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("07", "1/3 hand stream",
    (count, keyCount) { return  (count % 3 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("08", "1/2 hand stream",
    (count, keyCount) { return  (count % 2 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }
  ), 
  NotePositioningAlgorithm("09", "1/1 hand stream",
    (count, keyCount) { return  (getUniqueRandomNumbers(3, keyCount)).toSet(); }
  ), 
];

List<EndCondition> endConditions = [
  EndCondition("00", "back", EndMode.noteCount, 666), 
  EndCondition("01", "25 notes", EndMode.noteCount, 25), 
  EndCondition("02", "50 notes", EndMode.noteCount, 50), 
  EndCondition("03", "100 notes", EndMode.noteCount, 100), 
  EndCondition("04", "endless 10 miss to fail", EndMode.missCount, 10), 
  EndCondition("05", "endless 5 miss to fail", EndMode.missCount, 5), 
  EndCondition("06", "endless 3 miss to fail", EndMode.missCount, 3), 
  EndCondition("07", "endless 1 miss to fail", EndMode.missCount, 1), 
  EndCondition("08", "endless 10 miss or spam to fail", EndMode.spamMissCount, 10), 
  EndCondition("09", "endless 5 miss or spam to fail", EndMode.spamMissCount, 5), 
  EndCondition("10", "endless 3 miss or spam to fail", EndMode.spamMissCount, 3), 
  EndCondition("11", "endless 1 miss or spam to fail", EndMode.spamMissCount, 1), 
];

List<KeyCount> keyCounts = [
  KeyCount("00", "back", 666),
  KeyCount("01", "1 key", 1),
  KeyCount("02", "2 key", 2),
  KeyCount("03", "3 key", 3),
  KeyCount("04", "4 key", 4),
  KeyCount("05", "5 key", 5),
  KeyCount("06", "6 key", 6),
];

class KeyCount{
  KeyCount(this.id, this.name, this.value);

  String id;
  String name;
  int value;
}

List<NoteFrequency> noteFrequencies = [
  NoteFrequency("00", "back", 666),
  NoteFrequency("01", "1/3 note per second", 3000),
  NoteFrequency("02", "1/2 note per second", 2000),
  NoteFrequency("03", "1 note per second", 1000),
  NoteFrequency("04", "2 note per second", 500),
  NoteFrequency("05", "3 note per second", 333),
  NoteFrequency("06", "4 note per second", 250),
  NoteFrequency("07", "5 note per second", 200),
  NoteFrequency("08", "6 note per second", 166),
  NoteFrequency("09", "7 note per second", 142),
  NoteFrequency("10", "8 note per second", 125),
  NoteFrequency("11", "9 note per second", 111),
  NoteFrequency("12", "10 note per second", 100),
];

class NoteFrequency{
  NoteFrequency(this.id, this.name, this.value);

  String id;
  String name;
  int value;
}

List<Judgement> judgements = [
  Judgement("good", 40, 3),
  Judgement("goof", 70, 2),
  Judgement("goon", 120, 1),
];

class Judgement{
  Judgement(this.name, this.ms, this.value);
  
  String name;
  int ms;
  int value;
}


//-------------------------------------------------------------------------------------------------