import 'package:flutter/material.dart';
import 'package:vaamos/goalWidget.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/localFileSystem.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:vaamos/services/goal_services.dart';
// import 'dart:convert';
import 'package:date_format/date_format.dart';

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
  List data;

  final List<Color> colorCodes = <Color>[
    Colors.orange,
    Colors.cyan,
    Colors.purple,
    Colors.lightGreen,
    Colors.pink
  ];

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
            ),
            AddGoalBox()
            
          ],
        );
      },
      itemCount: goals == null ? 0 : goals.length,
    );
  }


  // Widget listGoals(goals) {
   
  //   List<Widget> goals = [];

  //   for (int i = 0; i < goals.length; i++) {
  //     goals.add(GoalWidget(sentence: goals[i].goalName, bgColor: colorCodes[i]));
  //   }

  //   if (goals.length != 5) {
  //     goals.add(AddGoalBox());
  //   }

  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: goals);

  // }

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
    return Container(color: Colors.white, child: Center(child: dailyGoals(x)));
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
        body: Container(
          child: Center(
            child: FutureBuilder(
                future: loadGoals(),
                builder: (context, goalsSnap) {
                  var goalsList = goalsSnap.data;
                  if (goalsSnap.connectionState == ConnectionState.none &&
                      goalsSnap.hasData == null) {
                    print('goalsSnap data is: ${goalsSnap.data}');
                    return Container();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(flex: 2, child: topContainer()),
                      Expanded(flex: 8, child: bottomContainer(goalsList))
                    ],
                  );
                }),
          ),
        ));
  }
}
