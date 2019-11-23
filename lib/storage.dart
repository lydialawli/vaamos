// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:convert';
import 'dart:io';
// import 'package:flutter/widgets.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static readGoalsFile() async {
    String fileName = "test7.json";

    try {
      final directory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${directory.path}/$fileName');
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
