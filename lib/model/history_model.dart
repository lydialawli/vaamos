import 'dart:convert';

class Instance {
  String date;
  List<int> goalIds;

  Instance({this.date, this.goalIds});

  factory Instance.goalFromJson(Map<String, dynamic> parsedJson) {
    return Instance(
        date: parsedJson['date'].toString(), goalIds: parsedJson['goalIds']);
  }
}

class ListInstances {
  final List<Instance> history;

  ListInstances({
    this.history,
  });

  static List<Instance> fromJson(List<dynamic> parsedJson) {
    List<Instance> history = new List<Instance>();
    history = parsedJson.map((i) => Instance.goalFromJson(i)).toList();

    return history;
  }

  static List<Instance> fromJsonArray(String jsonString) {
    Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    List<dynamic> dynamicList = decodedMap['history'];
    List<Instance> history = new List<Instance>();
    dynamicList.forEach((f) {
      Instance s = Instance.goalFromJson(f);
      history.add(s);
    });
    return history;
  }
}
