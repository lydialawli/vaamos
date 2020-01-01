import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
        value: null, valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan));
  }
}

class NowButton extends StatelessWidget {
  final VoidCallback onPressed;

  NowButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: IconButton(
        splashColor: Colors.blueAccent,
        onPressed: onPressed,
        icon: Text('now',
            style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey)),
      ),
    );
  }
}

