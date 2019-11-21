import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
// import 'package:flutter/material.dart';

class LocalFileSystem {
  String fileName = "test2.json";
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


   startStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${dir.path}/$fileName');
    bool fileExists = false;
    fileExists = jsonFile.existsSync();

    Map<String, dynamic> content;

    if (fileExists) {
      content = json.decode(jsonFile.readAsStringSync());
      return content;
    } else {
      Map<String, dynamic> firstGoal = {'name': 'made my bed'};
      jsonFile.createSync();
      jsonFile.writeAsStringSync(json.encode(firstGoal));

      content = json.decode(jsonFile.readAsStringSync());
      return content;
    }

    
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
