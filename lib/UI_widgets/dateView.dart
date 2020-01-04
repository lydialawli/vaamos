// import 'package:flutter/material.dart';
// import 'package:date_format/date_format.dart';


//  List<String> daysOfTheWeek = [
//     'monday',
//     'tuesday',
//     'wednesday',
//     'thursday',
//     'friday',
//     'saturday',
//     'sunday',
//     'monday'
//   ];

// class DateView extends StatefulWidget {
//   final int index;
//   final List history;
//   final Function(int) onTapped;

//   DateView({this.index, this.history, this.onTapped})

//   @override
//   DateViewState createState() => DateViewState();
// }



// class DateViewState extends State<DateView>{
//    String viewDate;
//    int index;
//    List history;

//     void initState() {
//     super.initState();
//       setState(() {
//         index = widget.index;
//         history = widget.history;
//       });
    
//   }

//   getDayOfTheWeek(i){
//     int weekNum = history[index].date.weekday;
//     String dayOfTheWeek = daysOfTheWeek[weekNum - 1].substring(0, 1);
//     return dayOfTheWeek;
//   }

//   getDayInMonth(){

//   }

//   String dayOfTheWeek = getDayOfTheWeek(index);
//     // int weekNum = history[index].date.weekday;
//     // String day = daysOfTheWeek[weekNum - 1].substring(0, 1);

//     viewDate = formatDate(array[index].date, [dd]).toString();
//     String t =
//         formatDate(array[index].date, [dd, ' ', M, ' ', yyyy]).toString();

//     var circleBorder = new BoxDecoration(
//         borderRadius: new BorderRadius.circular(25.0),
//         border: new Border.all(
//           width: 1.0,
//           color: Colors.black,
//         ));

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         child: InkWell(
//             onTap: () {
//               widget.onTapped(widget.index);
//             },
//             child: Container(
//                 color: Colors.white,
//                 child: Column(children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20.0),
//                     child: Container(
//                       decoration: t == todayDateString ? circleBorder : null,
//                       child: Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Text(viewDate,
//                             style: TextStyle(
//                               fontFamily: 'Rubik',
//                               fontWeight: FontWeight.w300,
//                               fontSize: 25,
//                               color: Colors.black87,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Text(dayOfTheWeek,
//                       style: TextStyle(
//                           fontFamily: 'Rubik',
//                           fontWeight: FontWeight.w300,
//                           fontSize: 15,
//                           color: Colors.grey))
//                 ]))));}
// }