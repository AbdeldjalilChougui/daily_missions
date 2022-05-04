import 'package:dailymissions/avan_incon.dart';
import 'package:dailymissions/day_missions.dart';
import 'package:dailymissions/first_screen.dart';
import 'package:dailymissions/mission_detail.dart';
import 'package:dailymissions/plan_choice.dart';
import 'package:dailymissions/recentdays.dart';
import 'package:dailymissions/save_page.dart';
import 'package:dailymissions/show_previous_day.dart';
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