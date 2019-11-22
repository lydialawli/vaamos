import 'package:flutter/material.dart';
import 'package:vaamos/goal.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/localFileSystem.dart';
import 'package:vaamos/services/goal_services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.pink,
        ),
        home: Home(title: 'vaamos', storage: LocalFileSystem()));
  }
}

class Home extends StatefulWidget {
  Home({Key key, this.title, this.storage}) : super(key: key);
  final String title;
  final LocalFileSystem storage;
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    loadGoals();
    widget.storage
        .startStorage()
        .then((content) =>  print(content));
  }

  Widget dailyContainer() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Text('TODAY',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black87,
          )),
      Text('wednesday',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ))
    ]);
  }

  Widget topContainer() {
    return Container(
        color: Colors.white,
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  dailyContainer(),
                  // RaisedButton(
                  //     child: Text('Read'),
                  //     onPressed: () {
                  //       LocalFileSystem.read();
                  //     })
                ]))));
  }

 

  Widget listGoals() {
    final List<String> entries = <String>[
      'made the bed',
      'no carbs all day',
      'wrote in journal',
      'cold shower',
    ];
    final List<Color> colorCodes = <Color>[
      Colors.orange,
      Colors.cyan,
      Colors.purple,
      Colors.lightGreen,
      Colors.pink
    ];

    List<Widget> goals = [];

    for (int i = 0; i < entries.length; i++) {
      goals.add(Goal(sentence: entries[i], bgColor: colorCodes[i]));
    }

    if (entries.length != 5) {
      goals.add(AddGoalBox());
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: goals);

    // return ListView.separated(
    //   itemCount: entries.length,
    //   itemBuilder: (BuildContext context, int index) {
    //     return Goal(sentence: entries[index], bgColor: colorCodes[index]);
    //   },
    //   separatorBuilder: (BuildContext context, int index) =>
    //       SizedBox(height: 8.0),
    // );
  }

  Widget bottomContainer() {
    return Container(color: Colors.white, child: Center(child: listGoals()));
  }

  Widget homeLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(flex: 3, child: topContainer()),
        Expanded(flex: 7, child: bottomContainer())
        // Expanded(flex: 7, child: Center(child: Goal(sentence:'nice', bgColor:Colors.amber[100]))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.red), child: homeLayout());
  }
}
