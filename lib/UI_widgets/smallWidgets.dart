import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        value: null, valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan));
  }
}

class TodayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // color: Colors.red,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Text('TODAY',
              style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Colors.grey)),
        ));
  }
}

// class TodayButton extends StatelessWidget {
//   // final VoidCallback onPressed;
//   final Function() onPressed;

//   TodayButton(this.onPressed);

//   @override
//   Widget build(BuildContext context) {
//     return OutlineButton(
//       // color: Colors.blue,
//       // textColor: Colors.grey,
//       disabledTextColor: Colors.black,
//       padding: EdgeInsets.all(8.0),
//       splashColor: Colors.blueAccent,
//       onPressed: onPressed
//       ,
//       child: Text("Today",
//           style: TextStyle(
//               fontFamily: 'Rubik',
//               fontWeight: FontWeight.w300,
//               fontSize: 16,
//               color: Colors.grey)),
//     );
//   }
// }
