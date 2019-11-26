import 'package:flutter/material.dart';

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
  String goalText;

  void writeToFile(String value) {
    widget.onSubmitGoal(value);
  }

  TextStyle buttonStyling() {
    return TextStyle(
        fontSize: 15, color: Colors.grey[400], fontFamily: 'Rubik');
  }

  IconButton iconCancel() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.delete),
      color: Colors.grey[500],
      onPressed: () {
        setState(() {
          longPressFlag = !longPressFlag;
          goalText = '';
        });
        // delete();
      },
    );
  }

  IconButton cancelOrSubmit() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.done_outline),
      color: Colors.grey[500],
      onPressed: () {
        if (goalText != null) {
          writeToFile(goalText);
        }
        setState(() {
          longPressFlag = !longPressFlag;
        });
      },
    );
  }

  textStyle() {
    return TextStyle(fontSize: 20, fontFamily: 'Rubik', color: Colors.grey[500]);
  }

  Widget inputButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        iconCancel(),
        Expanded(
            child: TextField(
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (text) {
            writeToFile(text);
            setState(() {
              goalText = text;
              longPressFlag = !longPressFlag;
            });
            // print(text);
          },
          onChanged: (text) {
            setState(() {
              goalText = text;
            });
          },
          textAlign: TextAlign.center,
          maxLength: 30,
          style: textStyle(),
          decoration: InputDecoration(
            focusColor: Colors.grey,
            border: InputBorder.none,
            hintText: 'What is your goal?',
          ),
        )),
        cancelOrSubmit()
      ],
    );
  }


  Widget longPressButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.add, color: Colors.grey[400]),
        Text('long press', style: buttonStyling()),
      ],
    );
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
