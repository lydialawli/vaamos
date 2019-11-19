import 'package:flutter/material.dart';

class AddGoalBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        // onTap: () {
        //   setState(() {
        //     isDone = !isDone;
        //   });
        // },
        child: Container(
          alignment: Alignment.center,
          height: 70,
          color: Colors.grey[100],
          child: Text('long press to add',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              )),
        ),
      ),
    );
  }
}
