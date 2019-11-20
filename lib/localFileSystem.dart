import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileSystem {
  String fileName = "storage.json";

  Future<bool> checkIfFileExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFile = File('${directory.path}/storage.json');
    bool fileExists = false;
    fileExists = jsonFile.existsSync();
    return fileExists;
  }

  Future<String> read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/storage.json');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      return "Couldn't read file";
    }
  }

  static save(aString) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/storage.txt');
    final text = aString;
    await file.writeAsString(text);
    print('saved');
  }


}
