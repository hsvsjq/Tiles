import 'package:flutter/material.dart';
import 'package:tile/gameplay.dart';
import 'package:tile/constants.dart' as constants;

class ResultScreen extends StatelessWidget{
  const ResultScreen(this.resultBackButton, this.resultAgainButton, this.resultData, this.oldPb, {super.key});

  final Function resultBackButton;
  final Function resultAgainButton;
  final ResultData resultData;
  final ResultData oldPb;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Result", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),),
          Text(
              resultData.gameplayPreset!.getName(), 
            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1),
          ),
          Text("personal best", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1),),
          Text(oldPb.getResultString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1),),
          Text("hit count", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          Text(resultData.hitCount.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          Text("miss count", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          Text(resultData.missCount.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          Text("spam count", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          Text(resultData.spamCount.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2),),
          OutlinedButton(
            onPressed: () => {resultAgainButton()},
            child: Text(
              "again",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
            )
          ),
          OutlinedButton(
            onPressed: () => {resultBackButton()},
            child: Text(
              "return",
              style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 3.0),
            )
          ),   
        ]
      )
    );
  }
}



class ResultData{
  ResultData();

  List<int> hitCount = [0,0,0];
  int missCount = 0;
  int spamCount = 0;
  GameplayPreset? gameplayPreset;

  String getResultString(){
    return "${hitCount[0]},${hitCount[1]},${hitCount[2]}|$missCount|$spamCount";
  }

  ResultData.fromString(String s){
    List<String> l = s.split("|").toList();//.map((e) => int.parse(e)).toList();
    hitCount = l[0].split(",").map((e) => int.parse(e)).toList();
    missCount = int.parse(l[1]);
    spamCount = int.parse(l[2]);
  }

  int getScore(){
    int result = 0;
    for (int i = 0; i< constants.judgements.length; i++){
      result += constants.judgements[i].value * hitCount[i];
    }
    return result;
  }

  //if received is higher return true
  bool compare(ResultData result){

    return result.getScore() > getScore();
  }
}
