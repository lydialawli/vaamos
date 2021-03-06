import 'dart:convert';

class Goal {
  String goalName;
  int goalId;
  bool isActive;

  Goal({this.goalName, this.goalId, this.isActive});

  factory Goal.goalFromJson(Map<String, dynamic> parsedJson) {
    return Goal(
        goalName: parsedJson['name'].toString(),
        goalId: parsedJson['goalId'],
        isActive: parsedJson['isActive']);
  }
}

class Instance {
  DateTime date;
  List<dynamic> goalIds;

  Instance({this.date, this.goalIds});

  factory Instance.instanceFromJson(Map<String, dynamic> parsedJson) {
    return Instance(
        date: DateTime.parse(parsedJson['date']), goalIds: parsedJson['goalIds']);
  }
}

class StorageModel {
  final List<Goal> goals;
  final List<Instance> history;

  StorageModel({this.goals, this.history});

  factory StorageModel.fromJsonArray(Map<String, dynamic> parsedJson) {
    var historyL = parsedJson['history'] as List;

    var goals = parsedJson['goals'] as List;

    List<Goal> goalsList = goals.map((i) => Goal.goalFromJson(i)).toList();
    List<Instance> historyList =
        historyL.map((i) => Instance.instanceFromJson(i)).toList();

    return StorageModel(goals: goalsList, history: historyList);
  }
}

class ListGoals {
  final List<Goal> goals;

  ListGoals({
    this.goals,
  });

  static List<Goal> fromJson(List<dynamic> parsedJson) {
    List<Goal> goals = new List<Goal>();
    goals = parsedJson.map((i) => Goal.goalFromJson(i)).toList();

    return goals;
  }

  static List<Goal> fromJsonArray(String jsonString) {
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = decodedMap['goals'];
    List<Goal> goals = new List<Goal>();
    dynamicList.forEach((f) {
      Goal s = Goal.goalFromJson(f);
      goals.add(s);
    });
    return goals;
  }
}
