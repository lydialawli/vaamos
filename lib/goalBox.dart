import 'package:flutter/material.dart';

class GoalBox extends StatefulWidget {
  final String sentence;
  final Color bgColor;
  final bool isDone;
  final int index;
  final int goalId;
  final Function(int, int) onDone;
  final bool isDailyView;

  GoalBox(
      {this.sentence,
      this.bgColor,
      this.isDone,
      this.onDone,
      this.goalId,
      this.index, 
      this.isDailyView});

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
    widget.onDone(value, widget.index);
  }

  Widget build(BuildContext context) {
    Color boxColor = isDone ? widget.bgColor : Colors.grey[100];

    return Material(
      child: InkWell(
        onTap: () {
          if(widget.isDailyView) {setState(() {
            isDone = !isDone;
          });
          changeDone(widget.goalId);}
        },
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Container(
              decoration: BoxDecoration(
                color: boxColor,
              ),
              // child: Text(widget.index.toString()),
              alignment: Alignment.center,
              height: 90),
        ),
      ),
    );
  }
}
