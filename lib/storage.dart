// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'dart:io';
// import 'package:flutter/widgets.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static String goalsFileName = "test14.json";

  static startStorage(todayDate) async {
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

      createFirstData(todayDate, goalsFile);
 
      print('==>' + goalsFile.toString());
      content = json.decode(goalsFile.readAsStringSync());
      print('storage initialised with ' + content.toString());
    }
  }

  static createFirstData(todayDate, goalsFile) {
    Goal initialGoal =
        new Goal(goalName: 'make the bed', goalId: 1, isActive: true);
    Instance firstInstance =
        new Instance(date: todayDate, goalIds: [1]);

    List<Instance> listHistory = new List<Instance>();
    listHistory.add(firstInstance);

    List<Goal> listGoals = new List<Goal>();
    listGoals.add(initialGoal);

    StorageModel storage =
        new StorageModel(goals: listGoals, history: listHistory);

    savetoStorageJson(storage, goalsFile);
  }


  static savetoStorageJson(storage, goalsFile) async {
    String storageString = storageToJson(storage);
    write(goalsFile, storageString);
  }

  static String storageToJson(StorageModel storage) {
    List<Map<String, dynamic>> x = storage.goals
        .map((f) => {
              'name': f.goalName,
              'goalId': f.goalId,
              'isActive': f.isActive
            })
        .toList();
    List<Map<String, dynamic>> y = storage.history
        .map((f) => {'date': f.date.toString(), 'goalIds': f.goalIds})
        .toList();

    Map<String, dynamic> map() => {'goals': x, 'history': y};
    String result = jsonEncode(map());
    return result;
  }


  static write(File aFile, String aString) {
    aFile.writeAsStringSync(aString);
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

  static loadStorage() async {
    String storageJson = await readStorageFile();
    final jsonResponse = json.decode(storageJson);
    StorageModel storage = StorageModel.fromJsonArray(jsonResponse);
    return storage;
  }
}
