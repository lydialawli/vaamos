import 'package:flutter/material.dart';

class CustomPopupMenu {
  CustomPopupMenu({this.title, this.icon});
  String title;
  IconData icon;
}

List<CustomPopupMenu> choices = <CustomPopupMenu>[
  CustomPopupMenu(title: 'Daily', icon: Icons.home),
  CustomPopupMenu(title: 'Weekly', icon: Icons.bookmark),
];

class PopupMenu extends StatefulWidget {
  final Function onSelected;

  PopupMenu({this.onSelected});

  @override
  PopupMenuState createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      initialValue: choices[1],
      onCanceled: () {
        print('You have not chossed anything');
      },
      tooltip: 'choose view',
      onSelected: widget.onSelected,
      itemBuilder: (BuildContext context) {
        return choices.map((CustomPopupMenu choice) {
          return PopupMenuItem<CustomPopupMenu>(
            value: choice,
            child: Text(choice.title),
          );
        }).toList();
      },
    );
  }
}
