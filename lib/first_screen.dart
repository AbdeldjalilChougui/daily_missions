import 'package:dailymissions/card.dart';
import 'package:dailymissions/day_missions.dart';
import 'package:dailymissions/main.dart';
import 'package:dailymissions/plan_choice.dart';
import 'package:dailymissions/recentdays.dart';
import 'package:dailymissions/save_page.dart';
import 'package:dailymissions/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class FirstScreen extends StatefulWidget {
  static final String id = "firstscreen";

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  SQL_Helper helper = new SQL_Helper();
  List<int> chosenPlan = [];

  void setDebute() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<int>> plan = helper.getPlanList();
      plan.then((theList) {
        setState(() {
          chosenPlan = theList;
          if(chosenPlan.length == 1) {
            MyApp.plan = chosenPlan[0];
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipPath(
            clipper: ClipTop(),
            child: Container(
              height: 190,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.pinkAccent
              ),
              child: Center(
                child: Text(
                  "MY DIARIES",
                  style: TextStyle(color: Colors.grey,fontSize: 45,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CardLayout(
                              onTapped: () {
                                if (MyApp.plan == 0)
                                  Navigator.pushNamed(context, PlanChoice.id);
                                else {
                                  MyApp.walking++;
                                  Navigator.pushNamed(context, DayMissions.id);
                                }
                              },
                              text: "Day Missions",
                            ),
                            CardLayout(
                              onTapped: () {
                                MyApp.walking++;
                                Navigator.pushNamed(context, SavePage.id);
                              },
                              text: "Day Reviews",
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CardLayout(
                              onTapped: () {

                              },
                              text: "This Month",
                            ),
                            CardLayout(
                              onTapped: () {
                                Navigator.pushNamed(context, RecentDays.id, arguments: 1);
                              },
                              text: "Recent Days",
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CardLayout(
                              onTapped: () {

                              },
                              text: "Notes",
                            ),
                            CardLayout(
                              onTapped: () {

                              },
                              text: "TODOs",
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class ClipTop extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.moveTo(0, 0);
    p.lineTo(0, size.height / 2 + 20);
    p.quadraticBezierTo(30, size.height * 5 / 6, size.width / 2, size.height - 20);

    p.quadraticBezierTo(size.width - 30, size.height * 5 / 6, size.width, size.height / 2 + 20);
    p.lineTo(size.width,0);



    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}