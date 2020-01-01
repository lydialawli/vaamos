import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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
  final bool isDaily;

  PopupMenu({this.onSelected, this.isDaily});

  @override
  PopupMenuState createState() => PopupMenuState();
}

class PopupMenuState extends State<PopupMenu> {
  void _select(CustomPopupMenu choice) {
     widget.onSelected();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CustomPopupMenu>(
      elevation: 3.2,
      initialValue: widget.isDaily ? choices[0] : choices[1],
      icon: Icon(
        FeatherIcons.moreVertical,
        color: Colors.grey,
      ),
      tooltip: 'choose view',
      onSelected:_select,
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
