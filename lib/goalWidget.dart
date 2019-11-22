import 'package:flutter/material.dart';

class GoalWidget extends StatefulWidget {
  GoalWidget({this.sentence, this.bgColor});
  final String sentence;
  final Color bgColor;

  @override
  GoalWidgetState createState() => GoalWidgetState();
}

class GoalWidgetState extends State<GoalWidget> {
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
          height: 80,
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
