// import 'dart:convert';

class GoalModel {
  String goalSentence;
  int goalId;
  bool goalIsActive;

  GoalModel({this.goalSentence, this.goalId, this.goalIsActive});

  factory GoalModel.fromJson(Map<String, dynamic> parsedJson) {
    return GoalModel(
        goalId: parsedJson['id'],
        goalSentence: parsedJson['sentence'],
        goalIsActive: parsedJson['isActive']);
  }

  //  static String toJson(new GoalModel s,) {
  //   Map<String, dynamic> map() =>
  //       {'name': s.goalSentence, 'id': s.goalId, 'isActive': s.goalIsActive};

  //   String result = jsonEncode(map());
  //   return result;
  // }
}


