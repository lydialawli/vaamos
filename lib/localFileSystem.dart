import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileSystem  {
  File jsonFile;
  Directory dir;

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

  static save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/storage.txt');
    final text = 'buu';
    await file.writeAsString(text);
    print('saved');
  }

  

  static void test() {
    print('--> connected to LocalFileSystem');
    // return 'yay, it works!';
  }
}
