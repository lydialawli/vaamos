import 'package:flutter/material.dart';

class GoalStrings extends StatefulWidget {
  final String sentence;
  final int goalId;
  // final Function(String) onChangeName;

  GoalStrings({this.sentence, this.goalId});

  @override
  GoalStringsState createState() => GoalStringsState();
}

class GoalStringsState extends State<GoalStrings> {
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(33.0),
      child: Text(widget.sentence,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            backgroundColor: Colors.transparent,
          )),
    );

    // return Material(
    //   child: InkWell(
    //     child: Container(
    //       alignment: Alignment.center,
    //       height: 90,
    //       color: Colors.transparent,
    //       child: new Text(widget.sentence,
    //           style: TextStyle(
    //             fontSize: 20,
    //             color: Colors.black,
    //             backgroundColor: Colors.transparent,
    //           )),
    //     ),
    //   ),
    // );
  }
}
