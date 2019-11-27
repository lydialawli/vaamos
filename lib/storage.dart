import 'dart:convert';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  static String storageFileName = "test21.json";

  static startStorage(todayDate) async {
    final dir = await getApplicationDocumentsDirectory();
    final storageFile = File('${dir.path}/$storageFileName');
    bool fileExists = false;
    fileExists = storageFile.existsSync();

    Map<String, dynamic> content;

    if (fileExists) {
      String storageJson = await storageFile.readAsString();
      final jsonResponse = json.decode(storageJson);
      StorageModel storage = StorageModel.fromJsonArray(jsonResponse);

      String today = formatDate(todayDate, [dd, mm, yyyy]);
      String yesterday = formatDate(
          storage.history[storage.history.length - 1].date, [dd, mm, yyyy]);

      if (today != yesterday)
        createNewInstance(todayDate, storage, storageFile);

      content = json.decode(storageFile.readAsStringSync());
      print('storage started with ' + content.toString());
      return storageFile;
    } else {
      storageFile.createSync();

      // createTestData(todayDate, storageFile);
      createFirstData(todayDate, storageFile);

      print('==>' + storageFile.toString());
      content = json.decode(storageFile.readAsStringSync());
      print('storage initialised with ' + content.toString());
      return storageFile;
    }
  }

  static createNewInstance(todayDate, storageDart, goalsFile) {
    StorageModel storage = storageDart;

    Instance newInstance = new Instance(date: todayDate, goalIds: []);

    storage.history.add(newInstance);

    savetoStorageJson(storage, goalsFile);
  }

  // static createTestData(todayDate, goalsFile) {
  //   Goal initialGoal =
  //       new Goal(goalName: 'make the bed', goalId: 1, isActive: true);

  //   Instance a = new Instance(
  //       date: DateTime.parse('2019-11-10 12:36:56.270753'), goalIds: [1]);
  //   Instance b = new Instance(
  //       date: DateTime.parse('2019-11-11 12:36:56.270753'), goalIds: [1]);
  //   Instance c = new Instance(
  //       date: DateTime.parse('2019-11-12 12:36:56.270753'), goalIds: [1]);
  //   Instance d = new Instance(
  //       date: DateTime.parse('2019-11-15 12:36:56.270753'), goalIds: [1]);
  //   Instance e = new Instance(
  //       date: DateTime.parse('2019-11-16 12:36:56.270753'), goalIds: [1]);
  //   Instance f = new Instance(
  //       date: DateTime.parse('2019-11-22 12:36:56.270753'), goalIds: [1]);
  //   Instance g = new Instance(
  //       date: DateTime.parse('2019-11-23 12:36:56.270753'), goalIds: [1]);
  //   Instance h = new Instance(
  //       date: DateTime.parse('2019-11-24 12:36:56.270753'), goalIds: [1]);
  //   Instance i = new Instance(
  //       date: DateTime.parse('2019-11-26 12:36:56.270753'), goalIds: [1]);
  //   Instance j = new Instance(date: todayDate, goalIds: [1]);

  //   List<Instance> listHistory = new List<Instance>();
  //   listHistory.add(a);
  //   listHistory.add(b);
  //   listHistory.add(c);
  //   listHistory.add(d);
  //   listHistory.add(e);
  //   listHistory.add(f);
  //   listHistory.add(g);
  //   listHistory.add(h);
  //   listHistory.add(i);
  //   listHistory.add(j);

  //   List<Goal> listGoals = new List<Goal>();
  //   listGoals.add(initialGoal);

  //   StorageModel storage =
  //       new StorageModel(goals: listGoals, history: listHistory);

  //   savetoStorageJson(storage, goalsFile);
  // }

  static createFirstData(todayDate, goalsFile) {
    Goal initialGoal =
        new Goal(goalName: 'make the bed', goalId: 1, isActive: true);
    Instance firstInstance = new Instance(date: todayDate, goalIds: [1]);

    List<Instance> listHistory = new List<Instance>();
    listHistory.add(firstInstance);

    List<Goal> listGoals = new List<Goal>();
    listGoals.add(initialGoal);

    StorageModel storage =
        new StorageModel(goals: listGoals, history: listHistory);

    savetoStorageJson(storage, goalsFile);
  }

  static savetoStorageJson(storage, storageFile) async {
    String storageString = storageToJson(storage);
    write(storageFile, storageString);
  }

  static String storageToJson(StorageModel storage) {
    List<Map<String, dynamic>> x = storage.goals
        .map((f) =>
            {'name': f.goalName, 'goalId': f.goalId, 'isActive': f.isActive})
        .toList();
    List<Map<String, dynamic>> y = storage.history
        .map((f) => {'date': f.date.toString(), 'goalIds': f.goalIds})
        .toList();

    Map<String, dynamic> map() => {'goals': x, 'history': y};
    String result = jsonEncode(map());
    return result;
  }

  static write(File aFile, String aString) {
    aFile.writeAsStringSync(aString);
  }

  static readStorageFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final jsonFile = File('${directory.path}/$storageFileName');
      String text = await jsonFile.readAsString();
      return text;
    } catch (e) {
      return "==> Couldn't read file";
    }
  }

  static loadStorage() async {
    String storageJson = await readStorageFile();
    final jsonResponse = json.decode(storageJson);
    StorageModel storage = StorageModel.fromJsonArray(jsonResponse);

    // storage.history.removeAt(storage.history.length - 1);

    return storage;
  }
}
