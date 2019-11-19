import 'package:flutter/material.dart';

class Goal extends StatefulWidget {
  Goal({this.sentence, this.bgColor});
  final String sentence;
  final Color bgColor;

  @override
  State<StatefulWidget> createState() {
    return GoalState();
  }
}

class GoalState extends State<Goal> {
  bool isDone = false;

  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          setState(() {
            isDone = !isDone;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 70,
          color: isDone ? widget.bgColor : Colors.grey[100],
          child: Text(widget.sentence,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
