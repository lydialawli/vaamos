import 'package:flutter/material.dart';

class GoalStrings extends StatefulWidget {
  final String sentence;
  final int goalId;
  final Function(String, int) editGoalName;
  final Function(int) deleteGoal;

  GoalStrings({this.sentence, this.goalId, this.editGoalName, this.deleteGoal});

  @override
  GoalStringsState createState() => GoalStringsState();
}

class GoalStringsState extends State<GoalStrings> {
  bool longPressFlag = false;

  void edit(String value) {
    widget.editGoalName(value, widget.goalId);
  }

  void delete() {
    widget.deleteGoal(widget.goalId);
  }

  IconButton iconDelete() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.delete),
      color: Colors.grey,
      onPressed: () {
        delete();
      },
    );
  }

  textStyle() {
    return TextStyle(fontSize: 20, color: Colors.black);
  }

  Widget editGoal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        iconDelete(),

        Expanded(
            child: TextField(
          textInputAction: TextInputAction.done,
          onSubmitted: (text) {
            edit(text);
            setState(() {
              longPressFlag = !longPressFlag;
            });
            // print(text);
          },
          textAlign: TextAlign.center,
          // maxLength: 20,
          style: textStyle(),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(1),
            hintText: widget.sentence,
            
          ),
        )),
      ],
    );
  }

  Widget goalString() {
    return Text(widget.sentence, style: textStyle());
  }

  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: () {
          setState(() {
            longPressFlag = !longPressFlag;
          });
        },
        child: Stack(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(33.0),
                child: longPressFlag ? editGoal() : goalString()),
          ],
        ));
  }
}
