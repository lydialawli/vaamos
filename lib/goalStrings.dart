import 'package:flutter/material.dart';

class GoalStrings extends StatefulWidget {
  final String sentence;
  final int goalId;
  final Function(String, int) editGoalName;
  final Function(int) disableGoal;

  GoalStrings(
      {this.sentence, this.goalId, this.editGoalName, this.disableGoal});

  @override
  GoalStringsState createState() => GoalStringsState();
}

class GoalStringsState extends State<GoalStrings> {
  bool longPressFlag = false;
  String textInput;

  void edit(String value) {
    widget.editGoalName(value, widget.goalId);
  }

  void delete() {
    widget.disableGoal(widget.goalId);
  }

  IconButton iconDelete() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.cancel),
      iconSize: 30,
      color: Colors.grey[600],
      onPressed: () {
        _showDialog();
        // delete();
      },
    );
  }

  IconButton cancelOrSubmit() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.check_circle_outline),
      iconSize: 30,
      color: Colors.grey[600],
      onPressed: () {
        if (textInput != null) {
          edit(textInput);
        }
        setState(() {
          longPressFlag = !longPressFlag;
        });
      },
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Delete "' + widget.sentence + '" goal'),
          content: new Text(
              "This action will delete everything related to the goal"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  longPressFlag = !longPressFlag;
                });
              },
            ),
            new FlatButton(
              child: new Text("Delete"),
              onPressed: () {
                delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  textStyle() {
    return TextStyle(fontSize: 20, fontFamily: 'Rubik', color: Colors.black);
  }

  Widget editGoal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        iconDelete(),
        Expanded(
            child: TextField(
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (text) {
            edit(text);
            setState(() {
              longPressFlag = !longPressFlag;
            });
            // print(text);
          },
          onChanged: (text) {
            setState(() {
              textInput = text;
            });
          },
          textAlign: TextAlign.center,
          // maxLength: 20,
          style: textStyle(),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.sentence,
          ),
        )),
        cancelOrSubmit()
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
