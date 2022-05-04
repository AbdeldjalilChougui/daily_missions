import 'dart:async';

import 'package:dailymissions/day_review.dart';
import 'package:dailymissions/main.dart';
import 'package:dailymissions/missions.dart';
import 'package:dailymissions/previous_days.dart';
import 'package:dailymissions/save_page.dart';
import 'package:dailymissions/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class AvanIncon extends StatefulWidget {
  static final String id = "avanincon";

  @override
  _AvanInconState createState() => _AvanInconState();
}

class _AvanInconState extends State<AvanIncon> {
  TextEditingController avantage = new TextEditingController();
  TextEditingController avantage2 = new TextEditingController();
  TextEditingController avantage3 = new TextEditingController();
  TextEditingController avantage4 = new TextEditingController();
  TextEditingController avantage5 = new TextEditingController();

  TextEditingController inconvenient = new TextEditingController();
  TextEditingController inconvenient2 = new TextEditingController();
  TextEditingController inconvenient3 = new TextEditingController();
  TextEditingController inconvenient4 = new TextEditingController();
  TextEditingController inconvenient5 = new TextEditingController();

  TextEditingController myFeedBack = new TextEditingController();
  TextEditingController myFeedBack2 = new TextEditingController();
  TextEditingController myFeedBack3 = new TextEditingController();
  TextEditingController myFeedBack4 = new TextEditingController();
  TextEditingController myFeedBack5 = new TextEditingController();

  SQL_Helper helper = SQL_Helper();
  DayReview dayReview;
  List<DayReview> dayReviews = [];

  int count = 0;

  bool markedAvan1 = false;
  bool markedAvan2 = false;
  bool markedAvan3 = false;
  bool markedAvan4 = false;
  bool markedAvan5 = false;
  bool markedIncon1 = false;
  bool markedIncon2 = false;
  bool markedIncon3 = false;
  bool markedIncon4 = false;
  bool markedIncon5 = false;
  bool markedFeed1 = false;
  bool markedFeed2 = false;
  bool markedFeed3 = false;
  bool markedFeed4 = false;
  bool markedFeed5 = false;

  int markedIndexAvan1 = -1;
  int markedIndexAvan2 = -1;
  int markedIndexAvan3 = -1;
  int markedIndexAvan4 = -1;
  int markedIndexAvan5 = -1;
  int markedIndexIncon1 = -1;
  int markedIndexIncon2 = -1;
  int markedIndexIncon3 = -1;
  int markedIndexIncon4 = -1;
  int markedIndexIncon5 = -1;
  int markedIndexFeed1 = -1;
  int markedIndexFeed2 = -1;
  int markedIndexFeed3 = -1;
  int markedIndexFeed4 = -1;
  int markedIndexFeed5 = -1;

  void setDebute() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<DayReview>> dayRev = helper.getReviewsList();
      dayRev.then((theList) {
        setState(() {
          dayReviews = theList;
          for(int item = 0;item < dayReviews.length;item++) {
            if (dayReviews[item].category == "Avantage") {
              if (avantage.text == null || avantage.text == "") {
                markedIndexAvan1 = item;
                markedAvan1 = true;
                avantage.text = dayReviews[item].content;
              } else if (avantage2.text == null || avantage2.text == "") {
                markedIndexAvan2 = item;
                markedAvan2 = true;
                avantage2.text = dayReviews[item].content;
              } else if (avantage3.text == null || avantage3.text == "") {
                markedIndexAvan3 = item;
                markedAvan3 = true;
                avantage3.text = dayReviews[item].content;
              } else if (avantage4.text == null || avantage4.text == "") {
                markedIndexAvan4 = item;
                markedAvan4 = true;
                avantage4.text = dayReviews[item].content;
              } else if (avantage5.text == null || avantage5.text == "") {
                markedIndexAvan5 = item;
                markedAvan5 = true;
                avantage5.text = dayReviews[item].content;
              }
            }
            if (dayReviews[item].category == "Inconvenient") {
              if (inconvenient.text == null || inconvenient.text == "") {
                markedIndexIncon1 = item;
                markedIncon1 = true;
                inconvenient.text = dayReviews[item].content;
              } else if (inconvenient2.text == null || inconvenient2.text == "") {
                markedIndexIncon2 = item;
                markedIncon2 = true;
                inconvenient2.text = dayReviews[item].content;
              } else if (inconvenient3.text == null || inconvenient3.text == "") {
                markedIndexIncon3 = item;
                markedIncon3 = true;
                inconvenient3.text = dayReviews[item].content;
              } else if (inconvenient4.text == null || inconvenient4.text == "") {
                markedIndexIncon4 = item;
                markedIncon4 = true;
                inconvenient4.text = dayReviews[item].content;
              } else if (inconvenient5.text == null || inconvenient5.text == "") {
                markedIndexIncon5 = item;
                markedIncon5 = true;
                inconvenient5.text = dayReviews[item].content;
              }
            }
            if (dayReviews[item].category == "FeedBack") {
              if (myFeedBack.text == null || myFeedBack.text == "") {
                markedIndexFeed1 = item;
                markedFeed1 = true;
                myFeedBack.text = dayReviews[item].content;
              } else if (myFeedBack2.text == null || myFeedBack2.text == "") {
                markedIndexFeed2 = item;
                markedFeed2 = true;
                myFeedBack2.text = dayReviews[item].content;
              } else if (myFeedBack3.text == null || myFeedBack3.text == "") {
                markedIndexFeed3 = item;
                markedFeed3 = true;
                myFeedBack3.text = dayReviews[item].content;
              } else if (myFeedBack4.text == null || myFeedBack4.text == "") {
                markedIndexFeed4 = item;
                markedFeed4 = true;
                myFeedBack4.text = dayReviews[item].content;
              } else if (myFeedBack5.text == null || myFeedBack5.text == "") {
                markedIndexFeed5 = item;
                markedFeed5 = true;
                myFeedBack5.text = dayReviews[item].content;
              }
            }
          }

          count = dayReviews.length;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  void _save(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Do you want to delete the mission ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () async {
            final Future<Database> db = helper.initializedDatabase();
            db.then((database) {
              faire(avantage, "Avantage", markedAvan1, markedIndexAvan1);
              faire(avantage2, "Avantage", markedAvan2, markedIndexAvan2);
              faire(avantage3, "Avantage", markedAvan3, markedIndexAvan3);
              faire(avantage4, "Avantage", markedAvan4, markedIndexAvan4);
              faire(avantage5, "Avantage", markedAvan5, markedIndexAvan5);
              faire(inconvenient, "Inconvenient", markedIncon1, markedIndexIncon1);
              faire(inconvenient2, "Inconvenient", markedIncon2, markedIndexIncon2);
              faire(inconvenient3, "Inconvenient", markedIncon3, markedIndexIncon3);
              faire(inconvenient4, "Inconvenient", markedIncon4, markedIndexIncon4);
              faire(inconvenient5, "Inconvenient", markedIncon5, markedIndexIncon5);
              faire(myFeedBack, "FeedBack", markedFeed1, markedIndexFeed1);
              faire(myFeedBack2, "FeedBack", markedFeed2, markedIndexFeed2);
              faire(myFeedBack3, "FeedBack", markedFeed3, markedIndexFeed3);
              faire(myFeedBack4, "FeedBack", markedFeed4, markedIndexFeed4);
              faire(myFeedBack5, "FeedBack", markedFeed5, markedIndexFeed5);
            });
            Navigator.pop(context, false);

            MyApp.walking++;
            Navigator.pushNamed(context, SavePage.id);
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context, false);
          },
        )
      ],
    );
    showDialog(context: context, builder: (context) => alertDialog);
  }

  void faire(TextEditingController controller, String category, bool marked, int index) async{
    if (controller.text != null && controller.text != "") {
      if (marked) {
        dayReviews[index].content = controller.text;
        await helper.updateReviewContent(dayReviews[index]);
        dayReview = dayReviews[index];
        await helper.updateReview(dayReview);
      }
      else {
        count++;
        dayReview = DayReview.withId(count, category, controller.text);
        helper.insertReview(dayReview);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;

    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Avantage & Inconvenients",style: TextStyle(color: Colors.grey[300],fontSize: 22),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              MyApp.walking--;
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(8,16,8,16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.blueGrey,
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: avantage,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Avantage 1:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: avantage2,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Avantage 2:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: avantage3,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Avantage 3:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: avantage4,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Avantage 4:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: avantage5,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Avantage 5:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.fromLTRB(8,16,8,16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.deepOrangeAccent[100],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: inconvenient,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Inconvenient 1:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: inconvenient2,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Inconvenient 2:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: inconvenient3,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Inconvenient 3:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: inconvenient4,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Inconvenient 4:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: inconvenient5,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "Inconvenient 5:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.fromLTRB(8,16,8,16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.blue[200],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: myFeedBack,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "FeedBack 1:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: myFeedBack2,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "FeedBack 2:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: myFeedBack3,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "FeedBack 3:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: myFeedBack4,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "FeedBack 4:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          TextField(
                            controller: myFeedBack5,
                            style: textStyle,
                            decoration: InputDecoration(
                              labelText: "FeedBack 5:",
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                        ],
                      ),
                    ),
                    SizedBox(height: 50,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal: 55),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.circular(30.0),
                        child: MaterialButton(
                          onPressed: () {
                            _save(context);
                          },
                          minWidth: 200.0,
                          height: 42.0,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}