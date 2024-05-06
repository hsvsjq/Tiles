
import 'package:tile/gameplay.dart';
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
List<String> scrollSpeedsMenu = scrollSpeeds.map((e) => "${e / 1000} second").toList();

List<int> scrollSpeeds = [
  2000, 1900, 1800, 1700, 1600, 1500, 1400, 1300, 1200, 1100, 1000, 900, 800, 700, 600, 500, 400, 300, 200, 100,
];

List<String> hitPositionsMenu = hitPositions.map((e) => "$e").toList();

List<int> hitPositions = [
  200, 225, 250, 275, 300, 325, 350, 375, 400, 425, 450, 475, 500, 525, 550, 575, 600, 625, 650, 675, 700
];

List<String> noteHeightsMenu = noteHeights.map((e) => e.toString()).toList();

List<double> noteHeights = [
  80.0, 70.0, 60.0, 50.0, 40.0, 30.0, 20.0, 10.0, 1.0, 
];

List<double> buttonSizes = [
  20,30,40,50,60,70,80,90,100,110,120,130,140,150
];



//-----------------------------------------------------------------------------------------------------


//gampley presets--------------------------------------------------------------------------------------
//do not change the ids to preserve stored data index

class KeyCount{
  KeyCount(this.id, this.name, this.value);
  
  String id;
  String name;
  int value;
}

List<KeyCount> keyCounts = [
  KeyCount("01", "1 key", 1),
  KeyCount("02", "2 key", 2),
  KeyCount("03", "3 key", 3),
  KeyCount("04", "4 key", 4),
  KeyCount("05", "5 key", 5),
  KeyCount("06", "6 key", 6),
];

List<NotePositioningAlgorithm> allNotePositioningAlgorithms = [
  NotePositioningAlgorithm("00", "random singles", (count, keyCount) => {math.Random().nextInt(keyCount)}), 
  NotePositioningAlgorithm("01", "1/4 jumps",
    (count, keyCount) { return  (count % 4 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("02", "1/3 jumps",
    (count, keyCount) { return  (count % 3 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("03", "1/2 jumps",
    (count, keyCount) { return  (count % 2 == 0 ? getUniqueRandomNumbers(2, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("04", "all jumps",
    (count, keyCount) { return  (getUniqueRandomNumbers(2, keyCount)).toSet(); }), 
  NotePositioningAlgorithm("05", "1/4 hands",
    (count, keyCount) { return  (count % 4 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("06", "1/3 hands",
    (count, keyCount) { return  (count % 3 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("07", "1/2 hands",
    (count, keyCount) { return  (count % 2 == 0 ? getUniqueRandomNumbers(3, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("08", "all hands",
    (count, keyCount) { return  (getUniqueRandomNumbers(3, keyCount)).toSet(); }),
  NotePositioningAlgorithm("09", "1/4 quads",
    (count, keyCount) { return  (count % 4 == 0 ? getUniqueRandomNumbers(4, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("10", "1/3 quads",
    (count, keyCount) { return  (count % 3 == 0 ? getUniqueRandomNumbers(4, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("11", "1/2 quads",
    (count, keyCount) { return  (count % 2 == 0 ? getUniqueRandomNumbers(4, keyCount) : [math.Random().nextInt(keyCount)]).toSet(); }), 
  NotePositioningAlgorithm("12", "all quads",
    (count, keyCount) { return  (getUniqueRandomNumbers(4, keyCount)).toSet(); }), 
  NotePositioningAlgorithm("13", "full random",
    (count, keyCount) { return  (getUniqueRandomNumbers(getRandomNumber(keyCount), keyCount)).toSet(); }), 
  NotePositioningAlgorithm("14", "roll",
    (count, keyCount) { return  {count % keyCount}; }), 
  NotePositioningAlgorithm("15", "reverse roll",
    (count, keyCount) { return  {keyCount - 1 - count % keyCount}; }), 
  NotePositioningAlgorithm("16", "zig zag",
    (count, keyCount) { return  {(count % ((keyCount - 1) * 2) - keyCount + 1).abs()}; }), 
  NotePositioningAlgorithm("17", "walking bracket",
    (count, keyCount) { return  {(count % ((keyCount - 1) * 2) - keyCount + 1).abs(), ((count + 2) % ((keyCount - 1) * 2) - keyCount + 1).abs(), }; }), 
  NotePositioningAlgorithm("18", "full bracket",
    (count, keyCount) { return List.generate(keyCount, (index) => index).where((element) => element % 2 == count % 2).toSet(); }),
  NotePositioningAlgorithm("19", "all full chords",
    (count, keyCount) { return  List.generate(keyCount, (index) => index).toSet(); }), 
  NotePositioningAlgorithm("20", "cu bracket",
    (count, keyCount) { return  List.generate(keyCount - 1, (index) => index).where((element) => element % 2 == count % 2).toSet()..addAll(count % 5 == 0 ? [keyCount - 1] : []); }), 
  NotePositioningAlgorithm("21", "reverse cu bracket",
    (count, keyCount) { return  List.generate(keyCount - 1, (index) => index + 1).where((element) => (element) % 2 == count % 2).toSet()..addAll(count % 5 == 0 ? [0] : []); }), 
  NotePositioningAlgorithm("22", "cu break",
    (count, keyCount) { return count % 32 == 24 ? <int>{} : (List.generate(keyCount - 1, (index) => index).where((element) => element % 2 == count % 2).toSet()..addAll([4,7,9,12,15,20,23,25,28,31].contains(count % 32) ? [keyCount - 1] : [])); }), 
  NotePositioningAlgorithm("23", "reverse cu break",
    (count, keyCount) { return count % 32 == 24 ? <int>{} : (List.generate(keyCount - 1, (index) => index + 1).where((element) => (element) % 2 == count % 2).toSet()..addAll([4,7,9,12,15,20,23,25,28,31].contains(count % 32) ? [0] : [])); }), 
  NotePositioningAlgorithm("24", "cu jack",
    (count, keyCount) { return count % 2 == 0 ? {(count ~/ 2 % ((keyCount - 1) * 2) - keyCount + 1).abs()} : (List.generate(keyCount, (index) => index).toSet()); }), 
  NotePositioningAlgorithm("25", "running man",
    (count, keyCount) { return count % 2 == 0 ? {1 + (count ~/ 2 % ((keyCount - 2) * 2) - keyCount + 2).abs()} : {0}; }), 
  NotePositioningAlgorithm("26", "reverse running man",
    (count, keyCount) { return count % 2 == 0 ? {(count ~/ 2 % ((keyCount - 2) * 2) - keyCount + 2).abs()} : {keyCount - 1}; }), 
  NotePositioningAlgorithm("27", "walking trill",
    (count, keyCount) { return {(((count + 1) % 2 + (count ~/ 4)) % ((keyCount - 1) * 2) - keyCount + 1).abs()}; }), 
  NotePositioningAlgorithm("28", "smooth walking trill",
    (count, keyCount) { return {(((count ) % 2 + (count ~/ 4 * 2)) % ((keyCount - 1) * 2) - keyCount + 1).abs()}; }), 
  NotePositioningAlgorithm("29", "reverse smooth walking trill",
    (count, keyCount) { return {keyCount - 1 - ((((count) % 2 + (count ~/ 4 * 2)) % ((keyCount - 1) * 2) - keyCount + 1)).abs()}; }), 
  NotePositioningAlgorithm("30", "spaced roll",
    (count, keyCount) { var c = count % keyCount; var h = (keyCount / 2).ceil(); return {c % h * 2 + (c >= h ? 1 : 0)}; }), 
  NotePositioningAlgorithm("31", "reverse spaced roll",
    (count, keyCount) { var c = count % keyCount; var h = (keyCount / 2).ceil(); return {keyCount - 1 - (c % h * 2 + (c >= h ? 1 : 0))}; }), 
  

];

Map<KeyCount, List<NotePositioningAlgorithm>> notePositioningAlgorithms = {
  keyCounts[0]: [ //1 key
    allNotePositioningAlgorithms[19], //all full chords
  ],
  keyCounts[1]: [ //2 key
    allNotePositioningAlgorithms[0], //random singles
    allNotePositioningAlgorithms[13], //full random
    allNotePositioningAlgorithms[16], //zig zag
    allNotePositioningAlgorithms[1], //1/4 jumps
    allNotePositioningAlgorithms[2], //1/3 jumps
    allNotePositioningAlgorithms[3], //1/2 jumps
    allNotePositioningAlgorithms[19], //all full chords
  ],
  keyCounts[2]: [ //3 key
    allNotePositioningAlgorithms[0], //  random singles
    allNotePositioningAlgorithms[13], //  full random
    allNotePositioningAlgorithms[14], //  roll
    allNotePositioningAlgorithms[15], //  reverse roll
    allNotePositioningAlgorithms[16], //  zig zag
    allNotePositioningAlgorithms[1], //   1/4 jumps
    allNotePositioningAlgorithms[2], //   1/3 jumps
    allNotePositioningAlgorithms[3], //   1/2 jumps
    allNotePositioningAlgorithms[4], //   all jumps
    allNotePositioningAlgorithms[5], //   1/4 hands
    allNotePositioningAlgorithms[6], //   1/3 hands
    allNotePositioningAlgorithms[7], //   1/2 hands
    allNotePositioningAlgorithms[19], //  all full chords
    allNotePositioningAlgorithms[18], //  full bracket
    allNotePositioningAlgorithms[24], //  cu jack
    allNotePositioningAlgorithms[25], //  running man
    allNotePositioningAlgorithms[26], //  reverse running man
    allNotePositioningAlgorithms[27], //  walking trill
    allNotePositioningAlgorithms[28], //  smooth walking trill
    allNotePositioningAlgorithms[29], //  reverse smooth walking trill
  ],
  keyCounts[3]: [ //4 key
    allNotePositioningAlgorithms[0], //  random singles
    allNotePositioningAlgorithms[13], //  full random
    allNotePositioningAlgorithms[14], //  roll
    allNotePositioningAlgorithms[15], //  reverse roll
    allNotePositioningAlgorithms[16], //  zig zag
    allNotePositioningAlgorithms[1], //   1/4 jumps
    allNotePositioningAlgorithms[2], //   1/3 jumps
    allNotePositioningAlgorithms[3], //   1/2 jumps
    allNotePositioningAlgorithms[4], //   all jumps
    allNotePositioningAlgorithms[5], //   1/4 hands
    allNotePositioningAlgorithms[6], //   1/3 hands
    allNotePositioningAlgorithms[7], //   1/2 hands
    allNotePositioningAlgorithms[8], //   all hands
    allNotePositioningAlgorithms[9], //   1/4 quads
    allNotePositioningAlgorithms[10], //  1/3 quads
    allNotePositioningAlgorithms[11], //  1/2 quads
    allNotePositioningAlgorithms[19], //  all full chords
    allNotePositioningAlgorithms[17], //  walking chords
    allNotePositioningAlgorithms[18], //  full bracket
    allNotePositioningAlgorithms[24], //  cu jack
    allNotePositioningAlgorithms[25], //  running man
    allNotePositioningAlgorithms[26], //  reverse running man
    allNotePositioningAlgorithms[27], //  walking trill
    allNotePositioningAlgorithms[28], //  smooth walking trill
    allNotePositioningAlgorithms[29], //  reverse smooth walking trill
    allNotePositioningAlgorithms[30], //  spaced roll
    allNotePositioningAlgorithms[31], //  reverse spaced roll
  ],
  keyCounts[4]: [ //5 key
    allNotePositioningAlgorithms[0], //  random singles
    allNotePositioningAlgorithms[13], //  full random
    allNotePositioningAlgorithms[14], //  roll
    allNotePositioningAlgorithms[15], //  reverse roll
    allNotePositioningAlgorithms[16], //  zig zag
    allNotePositioningAlgorithms[1], //   1/4 jumps
    allNotePositioningAlgorithms[2], //   1/3 jumps
    allNotePositioningAlgorithms[3], //   1/2 jumps
    allNotePositioningAlgorithms[4], //   all jumps
    allNotePositioningAlgorithms[5], //   1/4 hands
    allNotePositioningAlgorithms[6], //   1/3 hands
    allNotePositioningAlgorithms[7], //   1/2 hands
    allNotePositioningAlgorithms[8], //   all hands
    allNotePositioningAlgorithms[9], //   1/4 quads
    allNotePositioningAlgorithms[10], //  1/3 quads
    allNotePositioningAlgorithms[11], //  1/2 quads
    allNotePositioningAlgorithms[12], //  all quads
    allNotePositioningAlgorithms[19], //  all full chords
    allNotePositioningAlgorithms[17], //  walking chords
    allNotePositioningAlgorithms[18], //  full bracket
    allNotePositioningAlgorithms[20], //  cu bracket
    allNotePositioningAlgorithms[21], //  reverse cu bracket
    allNotePositioningAlgorithms[22], //  cu break
    allNotePositioningAlgorithms[23], //  reverse cu break
    allNotePositioningAlgorithms[24], //  cu jack
    allNotePositioningAlgorithms[25], //  running man
    allNotePositioningAlgorithms[26], //  reverse running man
    allNotePositioningAlgorithms[27], //  walking trill
    allNotePositioningAlgorithms[28], //  smooth walking trill
    allNotePositioningAlgorithms[29], //  reverse smooth walking trill
    allNotePositioningAlgorithms[30], //  spaced roll
    allNotePositioningAlgorithms[31], //  reverse spaced roll
  ],
  keyCounts[5]: [ //6 key
    allNotePositioningAlgorithms[0], //  random singles
    allNotePositioningAlgorithms[13], //  full random
    allNotePositioningAlgorithms[14], //  roll
    allNotePositioningAlgorithms[15], //  reverse roll
    allNotePositioningAlgorithms[16], //  zig zag
    allNotePositioningAlgorithms[1], //   1/4 jumps
    allNotePositioningAlgorithms[2], //   1/3 jumps
    allNotePositioningAlgorithms[3], //   1/2 jumps
    allNotePositioningAlgorithms[4], //   all jumps
    allNotePositioningAlgorithms[5], //   1/4 hands
    allNotePositioningAlgorithms[6], //   1/3 hands
    allNotePositioningAlgorithms[7], //   1/2 hands
    allNotePositioningAlgorithms[8], //   all hands
    allNotePositioningAlgorithms[9], //   1/4 quads
    allNotePositioningAlgorithms[10], //  1/3 quads
    allNotePositioningAlgorithms[11], //  1/2 quads
    allNotePositioningAlgorithms[12], //  all quads
    allNotePositioningAlgorithms[19], //  all full chords
    allNotePositioningAlgorithms[17], //  walking chords
    allNotePositioningAlgorithms[18], //  full bracket
    allNotePositioningAlgorithms[24], //  cu jack
    allNotePositioningAlgorithms[25], //  running man
    allNotePositioningAlgorithms[26], //  reverse running man
    allNotePositioningAlgorithms[27], //  walking trill
    allNotePositioningAlgorithms[28], //  smooth walking trill
    allNotePositioningAlgorithms[29], //  reverse smooth walking trill
    allNotePositioningAlgorithms[30], //  spaced roll
    allNotePositioningAlgorithms[31], //  reverse spaced roll
  ],
};


enum EndMode{
  missCount,
  noteCount,
  spamMissCount
}


List<EndCondition> endConditions = [
  EndCondition("01", "25 notes", EndMode.noteCount, 25, ClearCondition(null, 0), null), 
  EndCondition("02", "50 notes", EndMode.noteCount, 50, ClearCondition(null, 0), 0), 
  EndCondition("03", "100 notes", EndMode.noteCount, 100, ClearCondition(null, 0), 1), 
  EndCondition("04", "endless 10 miss to fail", EndMode.missCount, 10, ClearCondition(200, null), null), 
  EndCondition("05", "endless 5 miss to fail", EndMode.missCount, 5, ClearCondition(200, null), 3), 
  EndCondition("06", "endless 3 miss to fail", EndMode.missCount, 3, ClearCondition(200, null), 4), 
  EndCondition("07", "endless 1 miss to fail", EndMode.missCount, 1, ClearCondition(200, null), 5), 
  EndCondition("08", "endless 10 miss or spam to fail", EndMode.spamMissCount, 10, ClearCondition(200, null), 6), 
  EndCondition("09", "endless 5 miss or spam to fail", EndMode.spamMissCount, 5, ClearCondition(200, null), 7), 
  EndCondition("10", "endless 3 miss or spam to fail", EndMode.spamMissCount, 3, ClearCondition(200, null), 8), 
  EndCondition("11", "endless 1 miss or spam to fail", EndMode.spamMissCount, 1, ClearCondition(200, null), 9), 
];


class NoteFrequency{
  NoteFrequency(this.id, this.name, this.value, this.level);

  String id;
  String name;
  int value;
  int level;
}


List<NoteFrequency> acceleratingNoteFrequencies = [
  NoteFrequency("01", "accelerating 1", -90, 0),
  NoteFrequency("02", "accelerating 2", -70, 0),
  NoteFrequency("03", "accelerating 3", -50, 0),
];

List<NoteFrequency> noteFrequencies(int length) => List.generate(length + 1, (index) => 
  NoteFrequency("${10 + index}", "${(index + 1)} note per second", (1 / (index + 1) * 1000).ceil(), index));

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