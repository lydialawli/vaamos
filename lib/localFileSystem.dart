import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileSystem {
  String fileName = "storage.json";

  static checkIfFileExists() async {
    final directory = await getApplicationDocumentsDirectory();
    final jsonFile = File('${directory.path}/storage.json');
    bool fileExists = false;
    fileExists = jsonFile.existsSync();

    print(fileExists);
  }

  // static createJsonFile() async {
    
  // }

  static read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/storage.txt');
      String text = await file.readAsString();
      print(text);
    } catch (e) {
      print("Couldn't read file");
    }
  }

  static save(aString) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/storage.txt');
    final text = aString;
    await file.writeAsString(text);
    print('saved');
  }

  static void test() {
    print('--> connected to LocalFileSystem');
    // return 'yay, it works!';
  }
}
