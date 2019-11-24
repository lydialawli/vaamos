import 'package:flutter/material.dart';

class GoalWidget extends StatefulWidget {
  final String sentence;
  final Color bgColor;
  final bool isDone;
  final int goalId;
  final Function(int) onDone;

  GoalWidget(
      {this.sentence, this.bgColor, this.isDone, this.onDone, this.goalId});

  @override
  GoalWidgetState createState() => GoalWidgetState();
}

class GoalWidgetState extends State<GoalWidget> {
  bool isDone = false;
  void initState() {
    super.initState();
    if (widget.isDone) {
      setState(() {
        isDone = true;
      });
    }
  }

  void changeDone(int value) {
    widget.onDone(value);
  }

  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            isDone = !isDone;
          });
          changeDone(widget.goalId);
        },
        child: Container(
          alignment: Alignment.center,
          height: 90,
          color: isDone ? widget.bgColor : Colors.grey[100],
          child: new Text(widget.sentence,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
