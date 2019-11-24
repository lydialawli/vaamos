import 'package:flutter/material.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/goalWidget.dart';
import 'package:vaamos/storage.dart';
// import 'package:vaamos/localFileSystem.dart';
import 'package:vaamos/model/goal_model.dart';
// import 'package:vaamos/services/goal_services.dart';
// import 'dart:convert';
import 'dart:io';
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
        home: Home(title: 'vaamos'));
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    this.title,
  }) : super(key: key);
  final String title;

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  List data;
  List<Goal> loadedGoals = [];
  List<Instance> loadedHistory = [];
  int goalsCount;
  bool loadingData = true;
  Instance todayInstance;
  int indexInstanceView = 0;
  File storageFile;

  @override
  void initState() {
    super.initState();
    initLoadStorage();
  }

  initLoadStorage() async {
    DateTime todayDate = DateTime.now();
    String today = formatDate(todayDate, [dd, ' ', M, ' ', yyyy]).toString();
    Storage.startStorage(todayDate).then((result) => storageFile = result);
    StorageModel results = await Storage.loadStorage();

    List<Instance> history = results.history;
    todayInstance = history.singleWhere(
        (i) => formatDate(i.date, [dd, ' ', M, ' ', yyyy]).toString() == today,
        orElse: () => null);
    print('today instance is => ' + history[0].date.toString());
    setState(() {
      loadedGoals = results.goals;
      goalsCount = results.goals.length;
      loadingData = false;
      todayDate = todayDate;
      loadedHistory = history;
      todayInstance = todayInstance;
      storageFile = storageFile;
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
    int newId = goalsCount + 1;
    Goal newGoal = new Goal(goalName: value, goalId: newId, isActive: true);

    List<Goal> goals = loadedGoals;
    goals.add(newGoal);

    List<Instance> history = loadedHistory;

    StorageModel storage = new StorageModel(goals: goals, history: history);

    Storage.savetoStorageJson(storage, storageFile);
    Storage.readStorageFile().then((res) => print('new json is => ' + res));
    setState(() {
      loadedGoals = goals;
      loadedHistory = history;
      goalsCount = newId;
    });
  }

  Widget widgetGoals() {
    List<Widget> goalsDisplay = [];
    List goalIds = todayInstance.goalIds;
    List<Goal> activeGoals = loadedGoals.where((g) => g.isActive).toList();

    for (int i = 0; i < activeGoals.length; i++) {
      // Goal goal = activeGoals.singleWhere((g) => g.goalId == goalIds[i],
      //     orElse: () => null);
      Goal goal = activeGoals[i];
      bool isDone;
     
     isDone = goalIds.contains(goal.goalId);

      goalsDisplay.add(GoalWidget(
          sentence: goal.goalName, bgColor: colorCodes[i], isDone: isDone));
      goalsDisplay.add(Container(height: 10));
    }

    if (activeGoals.length < 5) {
      goalsDisplay.add(AddGoalBox(onSubmitGoal));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: goalsDisplay);
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

  Widget bottomContainer() {
    return Container(
        color: Colors.white,
        child: Container(
            child: Center(child: loadingData ? spinner() : widgetGoals())));
  }

  Widget spinner() {
    return CircularProgressIndicator(
      value: null,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
    );
  }

  @override
  Widget build(BuildContext context) {
    var todayDate = DateTime.now();
    String today = formatDate(todayDate, [dd, ' ', M, ' ', yyyy]).toString();
    print(todayDate.toString());
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
            Expanded(flex: 8, child: bottomContainer()),
            // Expanded(flex: 1, child: AddGoalBox(onSubmitGoal))
          ],
        ));
  }
}
