import 'package:flutter/material.dart';
import 'package:vaamos/goal.dart';
import 'package:vaamos/addGoalBox.dart';

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
      home: MyHomePage(title: 'vaamos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;

  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

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
          child: dailyContainer(),
        )));
  }

  Widget addButton() {
    return Container(
      alignment: Alignment.center,
      height: 70,
      color: Colors.grey[100],
      child: Text('long press to add a goal',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          )),
    );
  }

  Widget listGoals() {
    final List<String> entries = <String>[
      'made the bedd',
      'no carbs all day',
      'wrote in journal',
      'cold shower',
      'hakuna'
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
