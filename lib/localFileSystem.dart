import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:vaamos/model/goal_model.dart';

// import 'package:flutter/material.dart';

class LocalFileSystem {
  String fileName = "test7.json";
//   Map<String, dynamic> initialData = {
//     "goals": [
//         {
//             "name": "made my bed",
//             "id": 1,
//             "isActive": true
//         }
//     ],
//     "history": [
//         {
//             "day": 20,
//             "month": 11,
//             "year": 2019,
//             "goals": [
//                 {
//                     "id": 1,
//                     "isDone": false
//                 }
//             ]
//         }
//     ]
// };



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

  // static List<GoalModel> fromJsonArray(String jsonString) {
  //   Map<String, dynamic> decodedMap = jsonDecode(jsonString);
  //   List<dynamic> dynamicList = decodedMap['goals'];
  //   List<GoalModel> goals = new List<GoalModel>();
  //   dynamicList.forEach((f) {
  //     GoalModel s = fromJsonMap(f);
  //     goals.add(s);
  //   });
  //   return goals;
  // }


  static String goalToJson(Goal s) {
    Map<String, dynamic> map() =>
        {'name': s.goalName, 'id': s.goalId, 'isActive': s.isActive};

    String result = jsonEncode(map());
    return result;
  }

  Future<String> read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      return "==> Couldn't read file";
    }
  }

  // void writeToFile(String key, dynamic value) {
  //   print("Writing to file!");
  //   Map<String, dynamic> content = {key: value};
  //   if (fileExists) {
  //     print("File exists");
  //     Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
  //     jsonFileContent.addAll(content);
  //     jsonFile.writeAsStringSync(json.encode(jsonFileContent));

  //    fileContent = json.decode(jsonFile.readAsStringSync()));
  //   print(fileContent);
  // }

  Future<File> write(aString) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    final text = aString;
    await file.writeAsString(text);

    return file;
  }
  // static write(aString) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/storage.json');
  //   final text = aString;
  //   await file.writeAsString(text);
  //   print('saved');
  // }

}
