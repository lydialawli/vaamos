import 'package:flutter/material.dart';
import 'package:vaamos/addGoalBox.dart';
import 'package:vaamos/goalBox.dart';
import 'package:vaamos/goalString.dart';
import 'package:vaamos/storage.dart';
import 'package:vaamos/model/goal_model.dart';
import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:date_util/date_util.dart';

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
  var dateUtility = new DateUtil();
  List data;
  List<Goal> loadedGoals = [];
  List<Instance> loadedHistory = [];
  List<Instance> allInstances = [];
  bool loadingData = true;
  int indexView = 0;
  File storageFile;
  DateTime dateToday;
  String todayDateString = 'today';
  int todayIndex;
  bool isDailyView = true;
  bool inputPosible = false;
  bool floatingButton;
  PageController _pageController;
  List<Goal> activeGoals;
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
    // print('today is =>' + DateTime.now().weekday.toString());
    // print('utc is =>' + DateTime.utc(2019, 11, 27, 0, 0, 0).toString());
    initLoadStorage();
  }

  initLoadStorage() async {
    DateTime now = DateTime.now();
    int year = int.parse(formatDate(now, [yyyy]));
    int month = int.parse(formatDate(now, [mm]));
    int day = int.parse(formatDate(now, [dd]));
    DateTime todayDate = DateTime.utc(year, month, day, 0, 0, 0);
    todayDateString = formatDate(todayDate, [dd, ' ', M, ' ', yyyy]);
    // DateTime todayDate = DateTime.parse('2019-11-25 12:36:56.270753');

    print('dateutil => ' + todayDate.toString());

    Storage.startStorage(todayDate).then((result) => storageFile = result);
    StorageModel results = await Storage.loadStorage();

    List<Instance> history = results.history;
    List<Instance> allInstances = createEmptyInstances(history);

    List<Goal> activeG = results.goals.where((g) => g.isActive).toList();

    Instance tommorrow = new Instance(date: DateTime.now(), goalIds: []);

    history.add(tommorrow);

    setState(() {
      loadedGoals = results.goals;
      loadingData = false;
      todayDate = todayDate;
      loadedHistory = history;
      allInstances = allInstances;
      indexView = history.length - 2;
      storageFile = storageFile;
      dateToday = todayDate;
      todayIndex = history.length - 2;
      floatingButton = activeG.length < 5 ? true : false;
      activeGoals = activeG;
      _pageController = PageController(
        initialPage: history.length - 2,
        viewportFraction: 0.9,
      );
    });
  }

  createEmptyInstances(history) {
    List years = [];
    List<Instance> allInstances = [];
    Instance thisDay;

    for (int i = 0; i < history.length; i++) {
      Instance instance = history[i];
      int y = int.parse(formatDate(instance.date, [yyyy]));
      years.add(y);
    }
    List yearsFiltered = years.toSet().toList();

    print('years are ===> ' + yearsFiltered.toString());

    for (int i = 0; i < yearsFiltered.length; i++) {
      int thisYear = yearsFiltered[i];

      for (int f = 1; f <= 12; f++) {
        int month = f;
        int totalDays = dateUtility.daysInMonth(month, thisYear);
        for (int q = 1; q <= totalDays; q++) {
          DateTime thisDate = DateTime.utc(thisYear, month, q, 0, 0, 0);
          thisDay = new Instance(date: thisDate, goalIds: []);
          for (int k = 0; k < history.length; k++) {
            String historyDate =
                formatDate(history[k].date, [dd, ' ', M, ' ', yyyy]);
            String instanceDate =
                formatDate(thisDay.date, [dd, ' ', M, ' ', yyyy]);

            if (historyDate == instanceDate) {
              thisDay = history[k];
            }
          }
          allInstances.add(thisDay);
        }
      }
    }
    return allInstances;
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

    if (loadedGoals.length < 5) {
      inputIsVisible();
    } else {
      setState(() {
        inputPosible = false;
      });
    }

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

  onDone(int x, int index) {
    int goalId = x;
    List ids = loadedHistory[index].goalIds;

    ids.contains(goalId)
        ? ids.removeWhere((id) => id == goalId)
        : ids.add(goalId);

    loadedHistory.removeAt(loadedHistory.length - 1);

    updateStorage(loadedGoals, loadedHistory);
  }

  updateStorage(g, h) {
    List<Goal> goals = g;
    List<Instance> history = h;
    List<Goal> activeG = goals.where((g) => g.isActive).toList();

    StorageModel storage = new StorageModel(goals: goals, history: history);

    Storage.savetoStorageJson(storage, storageFile);
    Storage.readStorageFile().then((res) => print('new json is => ' + res));

    Instance tommorrow = new Instance(date: DateTime.now(), goalIds: []);
    loadedHistory.add(tommorrow);

    setState(() {
      loadedGoals = goals;
      loadedHistory = history;
      activeGoals = activeG;
      floatingButton = activeG.length < 5 ? true : false;
    });
  }

  Widget goalBoxWidget(onDone, instance, index) {
    List<Widget> goalsDisplay = [];
    List goalIds = instance.goalIds;
    List<Goal> activeGoals = loadedGoals.where((g) => g.isActive).toList();

    for (int i = 0; i < activeGoals.length; i++) {
      Goal goal = activeGoals[i];
      bool isDone;
      isDone = goalIds.contains(goal.goalId);

      goalsDisplay.add(GoalBox(
          sentence: goal.goalName,
          goalId: goal.goalId,
          index: index,
          bgColor: colorCodes[i],
          isDone: isDone,
          onDone: onDone));
      goalsDisplay.add(Container(height: 10));
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start, children: goalsDisplay);
  }

  Widget goalStringsWidget() {
    List<Widget> goalsStrings = [];

    for (int i = 0; i < activeGoals.length; i++) {
      Goal goal = activeGoals[i];

      goalsStrings.add(GoalString(
          sentence: goal.goalName,
          goalId: goal.goalId,
          editGoalName: editGoalName,
          disableGoal: disableGoal));
      goalsStrings.add(Container(height: 10));
    }

    // if (activeGoals.length < 5) {
    //   goalsStrings.add(AddGoalBox(onSubmitGoal));
    // }

    return Padding(
      padding: const EdgeInsets.only(top:35),
      child: Column(children: goalsStrings),
    );
  }

  switchView(index) {
    setState(() {
      _pageController.jumpToPage(index);
      _pageController = PageController(
        viewportFraction: isDailyView ? 0.9 : 0.15,
      );
    });
  }

  Widget dailyDate(index) {
    String viewDate;

    int weekNum = loadedHistory[index].date.weekday;
    String day = daysOfTheWeek[weekNum - 1];

    if (index == todayIndex)
      viewDate = 'TODAY';
    else if (index == todayIndex + 1) {
      viewDate = 'TOMORROW';
      day = daysOfTheWeek[weekNum];
    } else {
      viewDate = formatDate(loadedHistory[index].date, [dd, ' ', M]).toString();
    }

    return Material(
        child: InkWell(
            onTap: () {
              setState(() {
                isDailyView = false;
              });
              switchView(index);
            },
            child: Container(
                color: Colors.white,
                child: Column(children: [
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
                ]))));
  }

  // Widget topContainer(index) {
  //   return Container(
  //       color: Colors.white,
  //       child: Center(
  //           child: Padding(
  //               padding: const EdgeInsets.only(bottom: 30),
  //               child:
  //                   Column(mainAxisAlignment: MainAxisAlignment.end, children: [
  //                 // AnimatedSwitcher(
  //                 //     duration: const Duration(milliseconds: 500),
  //                 //     transitionBuilder:
  //                 //         (Widget child, Animation<double> animation) {
  //                 //       return ScaleTransition(child: child, scale: animation);
  //                 //     },
  //                 //     child: isDailyView ? dailyDate(index) : weeklyDate(index),
  //                 //     key: ValueKey<bool>(isDailyView)),

  //                 AnimatedCrossFade(
  //                   duration: const Duration(milliseconds: 500),
  //                   firstChild: dailyDate(index),
  //                   secondChild: weeklyDate(index),
  //                   crossFadeState: isDailyView
  //                       ? CrossFadeState.showFirst
  //                       : CrossFadeState.showSecond,
  //                 )
  //               ]))));
  // }

  Widget topContainer(index) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isDailyView ? dailyDate(index) : weeklyDate(index)
                    ]))));
  }

  Widget weeklyDate(index) {
    String viewDate;

    int weekNum = loadedHistory[index].date.weekday;
    String day = daysOfTheWeek[weekNum - 1].substring(0, 1);

    viewDate = formatDate(loadedHistory[index].date, [dd]).toString();
    String t = formatDate(loadedHistory[index].date, [dd, ' ', M, ' ', yyyy])
        .toString();

    var circleBorder = new BoxDecoration(
        borderRadius: new BorderRadius.circular(25.0),
        border: new Border.all(
          width: 1.0,
          color: Colors.black,
        ));

    return Material(
        child: InkWell(
            onTap: () {
              setState(() {
                isDailyView = true;
              });
              switchView(index);
            },
            child: Container(
                color: Colors.white,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: t == todayDateString ? circleBorder : null,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(viewDate,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w300,
                              fontSize: 25,
                              color: Colors.black87,
                            )),
                      ),
                    ),
                  ),
                  Text(day,
                      style: TextStyle(
                          fontFamily: 'Rubik',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Colors.grey))
                ]))));
  }

  Widget bottomContainer(instance, index) {
    return Container(
        color: Colors.white,
        child: Container(
            child: Center(child: goalBoxWidget(onDone, instance, index))));
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

  Widget iconHelp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          alignment: Alignment.bottomLeft,
          icon: Icon(Icons.help_outline, size: 25.0),
          color: Colors.grey[300],
          onPressed: () {
            _showDialog();
            // delete();
          },
        ),
        Text(formatDate(loadedHistory[indexView].date, [MM, ' ', yyyy]),
            style: TextStyle(
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey))
      ],
    );
  }

  inputIsVisible() {
    setState(() {
      inputPosible = !inputPosible;
      floatingButton = !floatingButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadingData
        ? spinner()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: iconHelp(),
              backgroundColor: Colors.white,
            ),
            floatingActionButton: Visibility(
              visible: floatingButton,
              child: FloatingActionButton(
                onPressed: () {
                  inputIsVisible();
                },
                child: Icon(Icons.add),
                // backgroundColor: Colors.green,
              ),
            ),
            body: Stack(
              children: <Widget>[
                PageView.builder(
                    controller: _pageController,
                    scrollDirection: scrollDirection,
                    onPageChanged: (index) {
                      setState(() {
                        indexView = index;
                      });
                      print('current page... ' + index.toString());
                    },
                    itemBuilder: (context, index) {
                      Instance instance = loadedHistory[index];
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(flex: 2, child: topContainer(index)),
                            Expanded(
                                flex: 8,
                                child: bottomContainer(instance, index))
                          ]);
                    },
                    itemCount: loadedHistory.length),
                Container(
                  child: Column(
                    children: <Widget>[
                      Expanded(flex: 2, child: Container()),
                      Expanded(flex: 8, child: goalStringsWidget()),
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: AddGoalBox(
                        onSubmitGoal: onSubmitGoal,
                        inputPosible: inputPosible,
                        inputIsVisible: inputIsVisible))
              ],
            ));
  }
}
