import 'package:dailymissions/day_review.dart';
import 'package:dailymissions/missions.dart';
import 'package:dailymissions/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class PreviousDaysReviews extends StatefulWidget {
  static final String id = "previousdaysreviews";
  static int numberOfDays;

  @override
  _PreviousDaysReviewsState createState() => _PreviousDaysReviewsState();
}

class _PreviousDaysReviewsState extends State<PreviousDaysReviews> {

  SQL_Helper helper = new SQL_Helper();
  int count = 0;
  int heightAvant = 0;
  int heightIncon = 0;
  int heightFeed = 0;
  bool avantNotReapeated = true;
  bool inconNotReapeated = true;
  bool feedNotReapeated = true;
  bool avantNotReapeated2 = true;
  bool inconNotReapeated2 = true;
  bool feedNotReapeated2 = true;

  List<Missions> missions = [];
  List<DayReview> dayReviw = [];
  List<String> avantage = [];
  List<String> inconvenient = [];
  List<String> feedback = [];
  List<Color> colors = [
    Colors.purple,
    Colors.pinkAccent[100],
    Colors.yellowAccent,
    Colors.blueGrey,
    Colors.white,
    Colors.green[300],
    Colors.orangeAccent,
    Colors.teal
  ];

  void setDebute() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<Missions>> mission = helper.getMissionsList();
      mission.then((theList) {
        setState(() {
          missions = theList;
        });
      });

      Future<List<DayReview>> review = helper.getReviewsList();
      review.then((theList) {
        setState(() {
          dayReviw = theList;
          if (dayReviw != null) count += dayReviw.length;

          for (int i = 0;i <dayReviw.length;i++) {
            if (dayReviw[i].category == "Avantage") {
              avantage.add(dayReviw[i].content);
            }
            if (dayReviw[i].category == "Inconvenient") {
              inconvenient.add(dayReviw[i].content);
            }
            if (dayReviw[i].category == "FeedBack") {
              feedback.add(dayReviw[i].content);
            }
          }

          heightAvant = avantage.length;
          heightIncon = inconvenient.length;
          heightFeed = feedback.length;
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
      appBar: AppBar(
        title: Text("Previous Days Reviews",style: TextStyle(color: Colors.grey,fontSize: 25),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: count,
          itemBuilder: (context,index) {
            return Center(
              child: index < missions.length ? Container(
                width: 280,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.grey
                  ),
                  margin: EdgeInsets.all(8),
                  child: Card(
                    color: colors[index % colors.length],
                    child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                missions[index].name,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 20,
                                ),
                              ),
                              Divider(height: 1,color: Colors.grey,),
                              Text(
                                missions[index].description,
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(missions[index].status == 0 ? "Done" : "Uncomplited"),
                                  SizedBox(width: 10,),
                                  missions[index].status == 0
                                      ? Icon(Icons.check_box, size: 30, color: Colors.green,)
                                      : Icon(Icons.close, size: 30, color: Colors.red,)
                                ],
                              ),
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              )
                  : index == missions.length ? Container(
                width: avantage.length > 0 ? 280 : 0,
                height: avantage.length > 0 ? 150 + heightAvant * 40.0 : 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: avantage.length > 0
                          ? BorderRadius.all(Radius.circular(8))
                          : BorderRadius.all(Radius.circular(0)),
                      color: Colors.grey
                  ),
                  margin: avantage.length > 0 ? EdgeInsets.all(8) : EdgeInsets.all(0),
                  child: Card(
                    color: colors[index % colors.length],
                    child: Center(
                      child: Padding(
                        padding: avantage.length > 0
                            ? const EdgeInsets.only(left: 40, right: 40)
                            : const EdgeInsets.only(left: 0, right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            avantage.length > 0 ? Text(
                              "Avantage",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ) : SizedBox(height: 0,width: 0,),
                            Divider(height: 1,color: Colors.grey,),
                            avantage.length > 0
                                ? createPanel(avantage)
                                : SizedBox(height: 0,width: 0,
                            ),
                            avantage.length > 0
                                ? createPanel(avantage)
                                : SizedBox(height: 0,width: 0,
                            ),
                            avantage.length > 0
                                ? createPanel(avantage)
                                : SizedBox(height: 0,width: 0,
                            ),
                            avantage.length > 0
                                ? createPanel(avantage)
                                : SizedBox(height: 0,width: 0,
                            ),
                            avantage.length > 0
                                ? createPanel(avantage)
                                : SizedBox(height: 0,width: 0,
                            ),
                          ],),),),),),)
                  : index == missions.length + 1 ? Container(
                width: inconvenient.length > 0 ? 280 : 0,
                height: inconvenient.length > 0 ? 150 + heightIncon * 40.0 : 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: inconvenient.length > 0
                          ? BorderRadius.all(Radius.circular(8))
                          : BorderRadius.all(Radius.circular(0)),
                      color: Colors.grey
                  ),
                  margin: inconvenient.length > 0 ? EdgeInsets.all(8) : EdgeInsets.all(0),
                  child: Card(
                    color: colors[index % colors.length],
                    child: Center(
                      child: Padding(
                        padding: inconvenient.length > 0
                            ? const EdgeInsets.only(left: 40, right: 40)
                            : const EdgeInsets.only(left: 0, right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            inconvenient.length > 0 ? Text(
                              "Inconvenient",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ) : SizedBox(height: 0,width: 0,),
                            Divider(height: 1,color: Colors.grey,),
                            inconvenient.length > 0
                                ? createPanel(inconvenient)
                                : SizedBox(height: 0,width: 0,
                            ),
                            inconvenient.length > 0
                                ? createPanel(inconvenient)
                                : SizedBox(height: 0,width: 0,
                            ),
                            inconvenient.length > 0
                                ? createPanel(inconvenient)
                                : SizedBox(height: 0,width: 0,
                            ),
                            inconvenient.length > 0
                                ? createPanel(inconvenient)
                                : SizedBox(height: 0,width: 0,
                            ),
                            inconvenient.length > 0
                                ? createPanel(inconvenient)
                                : SizedBox(height: 0,width: 0,
                            ),
                          ],),),),),),)
                  : index == missions.length + 2 ? Container(
                width: feedback.length > 0 ? 280 : 0,
                height: feedback.length > 0 ? 150 + heightFeed * 40.0 : 0,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: feedback.length > 0
                          ? BorderRadius.all(Radius.circular(8))
                          : BorderRadius.all(Radius.circular(0)),
                      color: Colors.grey
                  ),
                  margin: feedback.length > 0 ? EdgeInsets.all(8) : EdgeInsets.all(0),
                  child: Card(
                    color: colors[index % colors.length],
                    child: Center(
                      child: Padding(
                        padding: feedback.length > 0
                            ? const EdgeInsets.only(left: 40, right: 40)
                            : const EdgeInsets.only(left: 0, right: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            feedback.length > 0 ? Text(
                              "FeedBack",
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 20,
                              ),
                            ) : SizedBox(height: 0,width: 0,),
                            Divider(height: 1,color: Colors.grey,),
                            feedback.length > 0
                                ? createPanel(feedback)
                                : SizedBox(height: 0,width: 0,
                            ),
                            feedback.length > 0
                                ? createPanel(feedback)
                                : SizedBox(height: 0,width: 0,
                            ),
                            feedback.length > 0
                                ? createPanel(feedback)
                                : SizedBox(height: 0,width: 0,
                            ),
                            feedback.length > 0
                                ? createPanel(feedback)
                                : SizedBox(height: 0,width: 0,
                            ),
                            feedback.length > 0
                                ? createPanel(feedback)
                                : SizedBox(height: 0,width: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox(height: 0,width: 0,),
            );
          },
        ),
      ),
    );
  }

  createPanel(List<String> list) {
    String name = list.removeAt(0);

    return Center(
      child: Text(
        name,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 25,
        ),
      ),
    );
  }
}