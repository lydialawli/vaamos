import 'package:flutter/material.dart';

class GoalWidget extends StatefulWidget {
  final String sentence;
  final Color bgColor;
  final bool isDone;

  GoalWidget({this.sentence, this.bgColor, this.isDone});

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
