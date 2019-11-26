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
  bool loadingData = true;
  int indexView = 0;
  File storageFile;
  DateTime dateToday;
  String todayDateString = 'today';
  int todayIndex;
  List<String> daysOfTheWeek = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
    'monday'
  ];

  var scrollDirection = Axis.horizontal;

  @override
  void initState() {
    super.initState();
    initLoadStorage();
  }

  initLoadStorage() async {
    DateTime todayDate = DateTime.now();
    // DateTime todayDate = DateTime.parse('2019-11-25 12:36:56.270753');
    todayDateString = formatDate(todayDate, [dd, ' ', M, ' ', yyyy]).toString();
    Storage.startStorage(todayDate).then((result) => storageFile = result);
    StorageModel results = await Storage.loadStorage();

    List<Instance> history = results.history;
    Instance tommorrow = new Instance(date: DateTime.now(), goalIds: []);

    history.add(tommorrow);
    print(' this is ittt => ' + todayDate.weekday.toString());

    setState(() {
      loadedGoals = results.goals;
      loadingData = false;
      todayDate = todayDate;
      loadedHistory = history;
      indexView = history.length - 2;
      storageFile = storageFile;
      dateToday = todayDate;
      todayIndex = history.length - 2;
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
    int newId = loadedGoals.length + 1;
    Goal newGoal = new Goal(goalName: value, goalId: newId, isActive: true);

    List<Goal> goals = loadedGoals;
    goals.add(newGoal);

    loadedHistory.removeAt(loadedHistory.length - 1);
    updateStorage(loadedGoals, loadedHistory);
  }

  disableGoal(int goalId) {
    List<Goal> goals = loadedGoals;

    // for (int i = 0; i < loadedGoals.length; i++) {
    //   Goal goal = loadedGoals[i];
    //   if (goal.goalId == goalId) {
    //     goal.isActive = false;
    //   }
    // }
    loadedGoals.forEach((g) => g.goalId == goalId ? g.isActive = false : null);

    // to delete the goal and its history fully
    // goals.removeWhere((g) => g.goalId == goalId);
    // for (int i = 0; i < loadedHistory.length; i++) {
    //   Instance instance = loadedHistory[i];
    //   instance.goalIds.removeWhere((g) => g == goalId);
    // }

    loadedHistory.removeAt(loadedHistory.length - 1);

    updateStorage(goals, loadedHistory);
  }

  editGoalName(String value, int id) {
    List<Goal> goals = loadedGoals;
    int index = goals.indexWhere((g) => g.goalId == id);
    goals[index].goalName = value;
    loadedHistory.removeAt(loadedHistory.length - 1);
    updateStorage(goals, loadedHistory);
  }

  onDone(int x) {
    int goalId = x;
    List ids = loadedHistory[indexView].goalIds;

    ids.contains(goalId)
        ? ids.removeWhere((id) => id == goalId)
        : ids.add(goalId);

    loadedHistory.removeAt(loadedHistory.length - 1);

    updateStorage(loadedGoals, loadedHistory);
  }

  updateStorage(g, h) {
    List<Goal> goals = g;
    List<Instance> history = h;

    StorageModel storage = new StorageModel(goals: goals, history: history);

    Storage.savetoStorageJson(storage, storageFile);
    Storage.readStorageFile().then((res) => print('new json is => ' + res));

    Instance tommorrow = new Instance(date: DateTime.now(), goalIds: []);
    loadedHistory.add(tommorrow);

    setState(() {
      loadedGoals = goals;
      loadedHistory = history;
    });
  }

  Widget goalBoxWidget(onDone, instance) {
    List<Widget> goalsDisplay = [];
    List goalIds = instance.goalIds;
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

    // if (activeGoals.length < 5) {
    //   goalsDisplay.add(AddGoalBox(onSubmitGoal));
    // }

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
          editGoalName: editGoalName,
          disableGoal: disableGoal));
      goalsStrings.add(Container(height: 10));
    }

    if (activeGoals.length < 5) {
      goalsStrings.add(AddGoalBox(onSubmitGoal));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: goalsStrings);
  }

  Widget dateTitle() {
    String viewDate;

    int weekNum = loadedHistory[indexView].date.weekday;
    String day = daysOfTheWeek[weekNum - 1];

    if (indexView == todayIndex)
      viewDate = 'TODAY';
    else if (indexView == todayIndex + 1) {
      viewDate = 'TOMORROW';
      day = daysOfTheWeek[weekNum];
    } else {
      viewDate =
          formatDate(loadedHistory[indexView].date, [dd, ' ', M, ' ', yyyy])
              .toString();
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Text(viewDate,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w300,
              fontSize: 35,
              color: Colors.black87,
            )),
      ),
      Text(day,
          style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: Colors.grey))
    ]);
  }

  Widget topContainer() {
    return Container(
        color: Colors.white,
        child: Center(
            child: Padding(
                padding: const EdgeInsets.all(30),
                child:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  dateTitle(),
                ]))));
  }

  Widget bottomContainer(instance) {
    return Container(
        color: Colors.white,
        child:
            Container(child: Center(child: goalBoxWidget(onDone, instance))));
  }

  Widget spinner() {
    return CircularProgressIndicator(
      value: null,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text('Tips'),
          content: new Text(
              "blablablabablablalbalbalblablalbalb balbalbal albla,abablalbalb"),
          // actions: <Widget>[

          // ],
        );
      },
    );
  }

  IconButton iconHelp() {
    return IconButton(
      alignment: Alignment.bottomLeft,
      icon: Icon(Icons.help_outline, size: 25.0),
      color: Colors.grey[300],
      onPressed: () {
        _showDialog();
        // delete();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: iconHelp(),
          backgroundColor: Colors.white,
        ),
        body: loadingData
            ? spinner()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(flex: 2, child: topContainer()),
                  Expanded(
                      flex: 8,
                      child: Stack(
                        children: <Widget>[
                          PageView.builder(
                              controller: PageController(
                                initialPage: todayIndex,
                                viewportFraction: 0.9,
                              ),
                              scrollDirection: scrollDirection,
                              onPageChanged: (index) {
                                setState(() {
                                  indexView = index;
                                });
                                print('current page... ' + index.toString());
                              },
                              itemBuilder: (context, index) {
                                Instance instance = loadedHistory[index];
                                return bottomContainer(instance);
                              },
                              itemCount: loadedHistory.length),
                          goalStringsWidget(),
                        ],
                      )),
                ],
              ));
  }
}
