import 'package:flutter/material.dart';

class GoalBox extends StatefulWidget {
  final String sentence;
  final Color bgColor;
  final bool isDone;
  final int goalId;
  final Function(int) onDone;

  GoalBox(
      {this.sentence, this.bgColor, this.isDone, this.onDone, this.goalId});

  @override
  GoalBoxState createState() => GoalBoxState();
}

class GoalBoxState extends State<GoalBox> {
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
          // child: new Text(widget.sentence,
          //     style: TextStyle(
          //       fontSize: 20,
          //       color: Colors.black,
          //     )),
        ),
      ),
    );
  }
}
