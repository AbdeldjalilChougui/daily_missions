import 'package:dailymissions/screens/save_page.dart';
import 'package:dailymissions/screens/show_previous_day.dart';
import 'package:dailymissions/widgets/avan_incon.dart';
import 'package:dailymissions/screens/day_missions.dart';
import 'package:dailymissions/screens/first_screen.dart';
import 'package:dailymissions/screens/mission_detail.dart';
import 'package:dailymissions/screens/plan_choice.dart';
import 'package:dailymissions/screens/recentdays.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static bool isDayFinished = false;
  static int walking = 0;
  static int plan = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      routes: {
        FirstScreen.id: (context) => FirstScreen(),
        DayMissions.id: (context) => DayMissions(),
        MissionDetails.id: (context) => MissionDetails(null,"",null,null),
        SavePage.id: (context) => SavePage(),
        AvanIncon.id: (context) => AvanIncon(),
        PlanChoice.id: (context) => PlanChoice(),
        RecentDays.id: (context) => RecentDays(),
        ShowPreviousDay.id: (context) => ShowPreviousDay(),
      },
      initialRoute: FirstScreen.id,
    );
  }
}