import 'package:flutter/material.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/goalWidget.dart';
// import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/storage.dart';
import 'package:vaamos/localFileSystem.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:vaamos/services/goal_services.dart';
// import 'dart:convert';
import 'package:date_format/date_format.dart';

void main() {
  runApp(MyApp());
}

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
  List data;
  List<Goal> loadedGoals;

  @override
  void initState() {
    super.initState();
    initGoals();
    Storage.startStorage();
  }

  initGoals() async {
    var results = await Storage.loadGoals();
    print('here is ==> ' + results[0].goalName);
    setState(() {
      loadedGoals = results;
    });
  }

  final List<Color> colorCodes = <Color>[
    Colors.orange,
    Colors.cyan,
    Colors.purple,
    Colors.lightGreen,
    Colors.pink
  ];

  onSubmitGoal(String value) {
    print(value);
  }

  Widget dailyGoals(goals) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GoalWidget(
                    sentence: goals[index].goalName,
                    bgColor: colorCodes[index],
                    isDone: false),
              ],
            )
          ],
        );
      },
      itemCount: goals == null ? 0 : goals.length,
    );
  }

  Widget dateTitle() {
    return Column(children: [
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
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  dateTitle(),
                ]))));
  }

  Widget bottomContainer(x) {
    return Container(
        color: Colors.white,
        child: Container(child: Center(child: dailyGoals(x))));
  }

  @override
  Widget build(BuildContext context) {
    var todayDate = DateTime.now();
    String today = formatDate(todayDate, [dd, ' ', M, ' ', yyyy]).toString();

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text('Today is ' + today,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              )),
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(flex: 2, child: topContainer()),
            Expanded(flex: 7, child: bottomContainer(loadedGoals)),
            Expanded(flex: 1, child: AddGoalBox(onSubmitGoal))
          ],
        ));
  }
}
