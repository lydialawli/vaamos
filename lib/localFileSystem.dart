import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileSystem {
  String fileName = "storage.txt";

  Future<bool> checkIfFileExists() async {
    final dir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${dir.path}/$fileName');
    bool fileExists = false;
    fileExists = jsonFile.existsSync();
    return fileExists;
  }

  Future<String> startStorage() async {
    final dir = await getApplicationDocumentsDirectory();
    final jsonFile = File('${dir.path}/$fileName');
    bool fileExists = false;
    fileExists = jsonFile.existsSync();

    String content;

    if (fileExists) {
      content = await jsonFile.readAsString();
    } else {
      content = 'no content';
    }

    return content;
  }


  Future<String> read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      String text = await file.readAsString();
      return text;
    } catch (e) {
      return "==> Couldn't read file";
    }
  }

  Future<File> write(aString) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    final text = aString;
    await file.writeAsString(text);

    return file;
  }
  // static write(aString) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/storage.json');
  //   final text = aString;
  //   await file.writeAsString(text);
  //   print('saved');
  // }

}
