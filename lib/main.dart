import 'package:flutter/material.dart';
import 'package:vaamos/goalWidget.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/localFileSystem.dart';
import 'package:vaamos/model/goal_model.dart';
import 'package:vaamos/services/goal_services.dart';
import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Load local JSON file"),
        ),
        body: Container(
          child: Center(
            child: FutureBuilder(
                future: loadGoals(),
                builder: (context, goalsSnap) {
                  // Decode the JSON
                  // var goalsList = json.decode(snapshot.data.toString());
                  var goalsList = goalsSnap.data;
                  if (goalsSnap.connectionState == ConnectionState.none &&
                      goalsSnap.hasData == null) {
                    print('goalsSnap data is: ${goalsSnap.data}');
                    return Container();
                  }
                  var todayDate = DateTime.now();
                  String today =
                      formatDate(todayDate, [dd, ' ', M, ' ', yyyy]).toString();

                  final List<Color> colorCodes = <Color>[
                    Colors.orange,
                    Colors.cyan,
                    Colors.purple,
                    Colors.lightGreen,
                    Colors.pink
                  ];

                  return ListView.builder(
                    // Build the ListView
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(today),
                            GoalWidget(
                                sentence: goalsList[index].goalName,
                                bgColor: colorCodes[index])
                            // Text("goal name is: " + goalsList[index]['name']),
                            // Text("is active: " +
                            //     goalsList[index]['isActive'].toString()),
                            // Text("id: " + goalsList[index]['id'].toString()),
                          ],
                        ),
                      );
                    },
                    itemCount: goalsList == null ? 0 : goalsList.length,
                  );
                }),
          ),
        ));
  }
  // List<Goal> goalsList;
  // @override
  // void initState() {
  //   super.initState();
  //   loadGoals();
  //   // loadGoals().then((result) => goalsList = result);
  //   // loadGoals().then((result) => setState(() {
  //   //       goals = result;
  //   //     }));
  //   widget.storage.startStorage().then((content) => print(content));
  // }

  // Widget dailyContainer() {
  //   return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
  //     Text('TODAY',
  //         style: TextStyle(
  //           fontSize: 30,
  //           color: Colors.black87,
  //         )),
  //     Text('wednesday',
  //         style: TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey,
  //         ))
  //   ]);
  // }

  // Widget topContainer() {
  //   return Container(
  //       color: Colors.white,
  //       child: Center(
  //           child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(children: [
  //                 dailyContainer(),
  //                 // RaisedButton(
  //                 //     child: Text('Read'),
  //                 //     onPressed: () {
  //                 //       LocalFileSystem.read();
  //                 //     })
  //               ]))));
  // }

  // Widget listGoals() {
  //   final List<String> listGoalsName = <String>[
  //     'made the bed',
  //     'no carbs all day',
  //     'wrote in journal',
  //     'cold shower',
  //   ];
  //   final List<Color> colorCodes = <Color>[
  //     Colors.orange,
  //     Colors.cyan,
  //     Colors.purple,
  //     Colors.lightGreen,
  //     Colors.pink
  //   ];

  //   List<Widget> goals = [];

  //   for (int i = 0; i < listGoalsName.length; i++) {
  //     goals.add(GoalWidget(sentence: listGoalsName[i], bgColor: colorCodes[i]));
  //   }

  //   if (listGoalsName.length != 5) {
  //     goals.add(AddGoalBox());
  //   }

  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: goals);

  //   // return ListView.separated(
  //   //   itemCount: entries.length,
  //   //   itemBuilder: (BuildContext context, int index) {
  //   //     return Goal(sentence: entries[index], bgColor: colorCodes[index]);
  //   //   },
  //   //   separatorBuilder: (BuildContext context, int index) =>
  //   //       SizedBox(height: 8.0),
  //   // );
  // }

  // Widget bottomContainer() {
  //   return Container(color: Colors.white, child: Center(child: listGoals()));
  // }

  // Widget homeLayout() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: [
  //       Expanded(flex: 3, child: topContainer()),
  //       Expanded(flex: 7, child: bottomContainer())
  //       // Expanded(flex: 7, child: Center(child: Goal(sentence:'nice', bgColor:Colors.amber[100]))),
  //     ],
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   // print('result is: ' + goalsList[0].goalName.toString());
  //   return Container(
  //       decoration: BoxDecoration(color: Colors.red), child: homeLayout());
  // }
}
