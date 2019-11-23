// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
// import 'package:flutter/widgets.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static String goalsFileName = "test7.json";

  static startStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final goalsFile = File('${dir.path}/$goalsFileName');
    bool fileExists = false;
    fileExists = goalsFile.existsSync();

    Map<String, dynamic> content;

    if (fileExists) {
      content = json.decode(goalsFile.readAsStringSync());
      print('storage started with ' + content.toString());
    } else {
      goalsFile.createSync();

      Goal initialGoal =
          new Goal(goalName: 'make the bed', goalId: 1, goalIsActive: true);

      List<Goal> goals = new List<Goal>();
      goals.add(initialGoal);

      saveGoals(goals);

      content = json.decode(goalsFile.readAsStringSync());
      print('storage initialised with ' + content.toString());
    }
  }

  static saveGoals(goals) async {
    final dir = await getApplicationDocumentsDirectory();
    final goalsFile = File('${dir.path}/$goalsFileName');

    String goalsString = goalsListToJson(goals);
    write(goalsFile, goalsString);
  }

  static write(File aFile, String aString) {
    aFile.writeAsStringSync(aString);
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

  static readStorageFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${directory.path}/$goalsFileName');
      String text = await jsonFile.readAsString();
      return text;
    } catch (e) {
      return "==> Couldn't read file";
    }
  }

  static loadGoals() async {
    String storageJson = await readStorageFile();
    StorageModel storage = StorageModel.fromJsonArray(storageJson);
    print('storage ==> ' + storage.toString());
    return storage;
  }

  // static loadGoals() async {
  //   String jsonGoals = await readStorageFile();
  //   List<Goal> goals = ListGoals.fromJsonArray(jsonGoals);
  //   return goals;
  // }

  // static Goal fromJsonMap(Map<String, dynamic> parsedJson) {
  //   return Goal(
  //       goalId: parsedJson['id'],
  //       goalName: parsedJson['name'],
  //       goalIsActive: parsedJson['isActive']);
  // }

  // static ListGoals fromJsonArray(List<dynamic> parsedJson) {
  //   List<Goal> goals = new List<Goal>();
  //   goals = parsedJson.map((i) => fromJsonMap(i)).toList();
  //   return new ListGoals(goals: goals);
  // }
}
