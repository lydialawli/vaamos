import 'package:flutter/material.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/goalBox.dart';
import 'package:vaamos/goalStrings.dart';
import 'package:vaamos/storage.dart';
import 'package:vaamos/model/goal_model.dart';
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
  Instance viewInstance;
  int indexView = 0;
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

    indexView = history.indexWhere(
        (i) => formatDate(i.date, [dd, ' ', M, ' ', yyyy]).toString() == today);

    setState(() {
      loadedGoals = results.goals;
      goalsCount = results.goals.length;
      loadingData = false;
      todayDate = todayDate;
      loadedHistory = history;
      viewInstance = history[indexView];
      storageFile = storageFile;
      indexView = indexView;
    });
  }

  final List<Color> colorCodes = <Color>[
    Color(0xffb80DEEA),
    Color(0xffbFFD78C),
    Color(0xffbFF959D),
    Color(0xffbF06292),
    Color(0xffb72768A)
  ];

  onSubmitGoal(String value) {
    int newId = goalsCount + 1;
    Goal newGoal = new Goal(goalName: value, goalId: newId, isActive: true);

    List<Goal> goals = loadedGoals;
    goals.add(newGoal);

    updateStorage(loadedGoals, loadedHistory);

    setState(() {
      goalsCount = newId;
    });
  }

  editGoalName(String value, int id) {
    List<Goal> goals = loadedGoals;
    int index = goals.indexWhere((g) => g.goalId == id);
    goals[index].goalName = value;
    updateStorage(goals, loadedHistory);
  }

  onDone(int x) {
    int goalId = x;
    List ids = loadedHistory[indexView].goalIds;

    ids.contains(goalId)
        ? ids.removeWhere((id) => id == goalId)
        : ids.add(goalId);

    updateStorage(loadedGoals, loadedHistory);
  }

  updateStorage(g, h) {
    List<Goal> goals = g;
    List<Instance> history = h;

    StorageModel storage = new StorageModel(goals: goals, history: history);

    Storage.savetoStorageJson(storage, storageFile);
    Storage.readStorageFile().then((res) => print('new json is => ' + res));
    setState(() {
      loadedGoals = goals;
      loadedHistory = history;
    });
  }

  Widget goalBoxWidget(onDone) {
    List<Widget> goalsDisplay = [];
    List goalIds = viewInstance.goalIds;
    List<Goal> activeGoals = loadedGoals.where((g) => g.isActive).toList();

    for (int i = 0; i < activeGoals.length; i++) {
      // Goal goal = activeGoals.singleWhere((g) => g.goalId == goalIds[i],
      //     orElse: () => null);
      Goal goal = activeGoals[i];
      bool isDone;
      isDone = goalIds.contains(goal.goalId);

      goalsDisplay.add(GoalBox(
          sentence: goal.goalName,
          goalId: goal.goalId,
          bgColor: colorCodes[i],
          isDone: isDone,
          onDone: onDone));
      goalsDisplay.add(Container(height: 10));
    }

    if (activeGoals.length < 5) {
      goalsDisplay.add(AddGoalBox(onSubmitGoal));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: goalsDisplay);
  }

  Widget goalStringsWidget() {
    List<Widget> goalsStrings = [];
    List<Goal> activeGoals = loadedGoals.where((g) => g.isActive).toList();

    for (int i = 0; i < activeGoals.length; i++) {
      Goal goal = activeGoals[i];

      goalsStrings.add(GoalStrings(
          sentence: goal.goalName,
          goalId: goal.goalId,
          editGoalName: editGoalName));
      goalsStrings.add(Container(height: 10));
    }

    if (activeGoals.length < 5) {
      goalsStrings.add(Container(height: 90));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: goalsStrings);
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
            child: Center(
                child: loadingData ? spinner() : goalBoxWidget(onDone))));
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
            Expanded(
                flex: 8,
                child: Stack(
                  children: <Widget>[
                    bottomContainer(),
                    goalStringsWidget(),
                  ],
                )),
            // Expanded(flex: 1, child: AddGoalBox(onSubmitGoal))
          ],
        ));
  }
}
