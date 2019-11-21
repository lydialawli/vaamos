class Goal {
  int goalId;
  String goalSentence;
  bool goalIsActive;

  Goal({this.goalSentence, this.goalId, this.goalIsActive});

  factory Goal.fromJson(Map<String, dynamic> parsedJson) {
    return Goal(
        goalId: parsedJson['id'],
        goalSentence: parsedJson['sentence'],
        goalIsActive: parsedJson['isActive']);
  }
}
