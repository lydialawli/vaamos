// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
// import 'package:flutter/widgets.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static String goalsFile = "test7.json";


  static startStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final goalsJson = File('${dir.path}/$goalsFile');
    bool fileExists = false;
    fileExists = goalsJson.existsSync();

    Map<String, dynamic> content;

    if (fileExists) {
      content = json.decode(goalsJson.readAsStringSync());
      print('storage started with ' + content.toString());
    } else {
      goalsJson.createSync();

      Goal initialGoal =
          new Goal(goalName: 'make the bed', goalId: 1, goalIsActive: true);

      List<Goal> goals = new List<Goal>();
      goals.add(initialGoal);

      String listGoals = goalsListToJson(goals);
      goalsJson.writeAsStringSync(listGoals);

      content = json.decode(goalsJson.readAsStringSync());
      print('storage initialised with ' + content.toString());
    }
  }

  static String goalsListToJson(List<Goal> goals) {
    List<Map<String, dynamic>> x = goals
        .map((f) =>
            {'name': f.goalName, 'id': f.goalId, 'isActive': f.goalIsActive})
        .toList();

    Map<String, dynamic> map() => {'goals': x};
    String result = jsonEncode(map());
    return result;
  }

  static readGoalsFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${directory.path}/$goalsFile');
      String text = await jsonFile.readAsString();
      return text;
    } catch (e) {
      return "==> Couldn't read file";
    }
  }

  static loadGoals() async {
    String jsonGoals = await readGoalsFile();
    List<Goal> goals = ListGoals.fromJsonArray(jsonGoals);
    return goals;
  }
}
