import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class AddGoalBox extends StatefulWidget {
  // AddGoalBox({this.storage});
  // final LocalFileSystem storage;

  @override
  GoalInputState createState() => GoalInputState();
}

class GoalInputState extends State<AddGoalBox> {
  bool longPressFlag = false;
  String goalText = '';

  File jsonFile;
  Directory dir;
  String fileName = "test1.json";
  bool fileExists = true;
  Map<String, String> goalsContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
    });
  }

  void writeToFile(String value) {
    print("Writing to file!");
    Map<String, dynamic> content = {'name': value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
      this.setState(
          () => goalsContent = json.decode(jsonFile.readAsStringSync()));
      print(goalsContent);
    }
  }

  Future<File> write(aString) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    final text = aString;
    await file.writeAsString(text);

    return file;
  }

  TextStyle buttonStyling() {
    return TextStyle(fontSize: 20, color: Colors.black);
  }

  Widget input() {
    return TextField(
      // onChanged: (text) {
      //   print("First text field: $text");
      // },
      textInputAction: TextInputAction.done,
      onSubmitted: (text) {
        writeToFile(text);
        setState(() {
          goalText = text;
          longPressFlag = !longPressFlag;
        });
        // print(text);
      },
      textAlign: TextAlign.center,
      maxLength: 30,
      style: buttonStyling(),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'What is your goal?',
      ),
    );
  }

  Widget longPressButton() {
    return Text('long press to add', style: buttonStyling());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onLongPress: () {
          setState(() {
            longPressFlag = !longPressFlag;
          });
        },
        child: Container(
            alignment: Alignment.center,
            height: 70,
            color: Colors.grey[100],
            child: longPressFlag ? input() : longPressButton()),
      ),
    );
  }
}
