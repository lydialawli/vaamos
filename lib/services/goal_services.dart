import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
import 'dart:io';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

// Future<String> _loadGoalsFolder() async {
//   return await rootBundle.loadString('assets/goal.json');
// }

Future<String> readStorageFile() async {
  String fileName = "test12.json";

  try {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFile = File('${directory.path}/$fileName');
    String text = await jsonFile.readAsString();
    return text;
  } catch (e) {
    return "==> Couldn't read file";
  }
}




Future loadGoalsOld() async {
  String jsonGoals = await readStorageFile();
  List<Goal> goals = ListGoals.fromJsonArray(jsonGoals);
  // print("1st goal is " + goals[0].goalName + 'and is ' + goals[0].goalIsActive.toString());
    
  return goals;
}


// Future<String> _loadPhotoAsset() async {
//   return await rootBundle.loadString('assets/photo.json');
// }

// Future loadPhotos() async {
//   String jsonPhotos = await _loadPhotoAsset();
//   final jsonResponse = json.decode(jsonPhotos);
//   PhotosList photosList = PhotosList.fromJson(jsonResponse);
//   print("photos " + photosList.photos[0].title);
// }