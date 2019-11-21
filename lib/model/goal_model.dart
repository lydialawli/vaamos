class Goal{
  String goalSentence;
  int goalId;
  bool goalIsActive;

  Goal({
    this.goalSentence,
    this.goalId,
    this.goalIsActive
});

 factory Goal.fromJson(Map<String, dynamic> parsedJson){
    return Goal(
      goalSentence: parsedJson['sentence'],
      goalId : parsedJson['id'],
      goalIsActive : parsedJson ['isActive']
    );
  }
}

