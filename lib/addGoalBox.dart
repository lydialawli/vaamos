import 'package:flutter/material.dart';

class AddGoalBox extends StatefulWidget {
  @override
  GoalInputState createState() => GoalInputState();
}

class GoalInputState extends State<AddGoalBox> {
  bool longPressFlag = false;
  String goalText = '';

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
        setState(() {
          goalText = text;
        });
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
