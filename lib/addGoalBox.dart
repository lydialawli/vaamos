import 'package:flutter/material.dart';

class AddGoalBox extends StatefulWidget {
  // AddGoalBox({this.storage});
  // final LocalFileSystem storage;
  final Function(String) onSubmitGoal;
  final bool inputPosible;
  final Function inputIsVisible;

  AddGoalBox({this.onSubmitGoal, this.inputPosible, this.inputIsVisible});

  @override
  GoalInputState createState() => GoalInputState();
}

class GoalInputState extends State<AddGoalBox> {
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
      icon: Icon(Icons.cancel),
      iconSize: 30,
      color: Colors.grey[500],
      onPressed: () {
        widget.inputIsVisible();
        setState(() {
          goalText = '';
        });
        // delete();
      },
    );
  }

  IconButton cancelOrSubmit() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.check_circle_outline),
      iconSize: 30,
      color: Colors.grey[500],
      onPressed: () {
        if (goalText != '') {
          writeToFile(goalText);
        }
      },
    );
  }

  textStyle() {
    return TextStyle(
        fontSize: 20, fontFamily: 'Rubik', color: Colors.grey[500]);
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

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.inputPosible,
      child: Material(
        child: InkWell(
          child: Container(
              alignment: Alignment.center,
              height: 90,
              color: Colors.grey[100],
              child: inputButton()),
        ),
      ),
    );
  }
}
