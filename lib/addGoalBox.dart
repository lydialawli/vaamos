import 'package:flutter/material.dart';
import 'dart:io';
// import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class AddGoalBox extends StatefulWidget {
  // AddGoalBox({this.storage});
  // final LocalFileSystem storage;
  final Function(String) onSubmitGoal;

  AddGoalBox(this.onSubmitGoal);

  @override
  GoalInputState createState() => GoalInputState();
}



class GoalInputState extends State<AddGoalBox> {
  bool longPressFlag = false;
  String goalText = '';
  int lengthGoals;

  File jsonFile;
  Directory dir;
  String fileName = "test2.json";
  bool fileExists = true;
  Map<String, String> goalsContent;

  @override
  void initState() {
    super.initState();
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      setState(() {
        lengthGoals = 1; //should be calculated, not hardcoded
      });
    });
  }

  void writeToFile(String value) {
    widget.onSubmitGoal(value);
  }

  TextStyle buttonStyling() {
    return TextStyle(fontSize: 20, color: Colors.grey);
  }

  Widget inputButton() {
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
            height: 90,
            color: Colors.grey[100],
            child: longPressFlag ? inputButton() : longPressButton()),
      ),
    );
  }
}
