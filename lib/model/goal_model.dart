// import 'dart:convert';
import 'dart:convert';

class Goal {
  String goalName;
  int goalId;
  bool goalIsActive;

  Goal({this.goalName, this.goalId, this.goalIsActive});

  factory Goal.goalFromJson(Map<String, dynamic> parsedJson) {
    return Goal(
        goalName: parsedJson['name'].toString(),
        goalId: parsedJson['id'],
        goalIsActive: parsedJson['isActive']);
  }

  //  static String toJson(new GoalModel s,) {
  //   Map<String, dynamic> map() =>
  //       {'name': s.goalSentence, 'id': s.goalId, 'isActive': s.goalIsActive};

  //   String result = jsonEncode(map());
  //   return result;
  // }
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
  // factory ListGoals.fromJson(List<dynamic> parsedJson) {
  //   List<Goal> goals = new List<Goal>();
  //   goals = parsedJson.map((i) => Goal.fromJson(i)).toList();

  //   return new ListGoals(goals: goals);
  // }

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
