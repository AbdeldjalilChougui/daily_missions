import 'dart:convert';
import 'dart:io';

import 'package:dailymissions/recentdays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ShowPreviousDay extends StatefulWidget {
  static final String id = "showpreviousday";
  final Map<String, dynamic> file =  RecentDays.jsonChosenFile;

  @override
  _ShowPreviousDayState createState() => _ShowPreviousDayState();
}

class _ShowPreviousDayState extends State<ShowPreviousDay> {
  String date;
  String year, month, day;
  String generalStatus;
  int missions;
  int reviews;
  int avantages = 0;
  int inconvenients = 0;
  int feedbacks = 0;
  int nbAdded = 0;
  bool reviewExists = false;
  List<String> missionsName = [];
  List<String> missionsDescription = [];
  List<String> missionsStatus = [];
  List<String> reviewCategory = [];
  List<String> reviewContent = [];
  List<String> avantage = [];
  List<String> inconvenient = [];
  List<String> feedback = [];
  List<String> reviewCategories = [];

  setDebute() {
    date = widget.file["date"].toString();
    year = date.substring(0,4);
    month = date.substring(5,7);
    day = date.substring(8,10);
    generalStatus = widget.file["generalstatus"].toString();
    for (int i = 0;i < 50;i++) {
      if (widget.file.toString().contains("mission_name${i + 1}"))         missionsName.add(widget.file["mission_name${i + 1}"].toString());
      if (widget.file.toString().contains("mission_description${i + 1}"))  missionsDescription.add(widget.file["mission_description${i + 1}"].toString());
      if (widget.file.toString().contains("mission_status${i + 1}"))       missionsStatus.add(widget.file["mission_status${i + 1}"].toString());
      if (widget.file.toString().contains("review_category${i + 1}"))      reviewCategory.add(widget.file["review_category${i + 1}"].toString());
      if (widget.file.toString().contains("review_content${i + 1}"))       reviewContent.add(widget.file["review_content${i + 1}"].toString());
    }

    missions = missionsName.length;
    reviews = reviewContent.length;

    for (int i = 0;i < reviews;i++) {
      if (reviewCategory[i] == "Avantage") {
        avantage.add(reviewContent[i]);
      }
      if (reviewCategory[i] == "Inconvenient") {
        inconvenient.add(reviewContent[i]);
      }
      if (reviewCategory[i] == "FeedBack") {
        feedback.add(reviewContent[i]);
      }
    }

    avantages = avantage.length;
    inconvenients = inconvenient.length;
    feedbacks = feedback.length;

    if (avantages > 0) {
      reviewCategories.add("Avantage");
      reviewExists = true;
    }
    if (inconvenients > 0) {
      reviewCategories.add("Inconvenient");
      reviewExists = true;
    }
    if (feedbacks > 0) {
      reviewCategories.add("FeedBack");
      reviewExists = true;
    }

    if (missions > 8) {
      nbAdded = missions - 8;
    }

    nbAdded += reviews;
  }

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  ScrollController s = ScrollController();

  double size = 300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  height: size,
                  width: MediaQuery.of(context).size.width - 45,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '$year/$month/$day',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 35,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            generalStatus == "Succeed" ? Icons.done : Icons.close,
                            color: generalStatus == "Succeed" ? Colors.green[400] : Colors.redAccent,
                            size: 35,
                          ),
                          SizedBox(width: 15,),
                          Text(
                            generalStatus,
                            style: TextStyle(
                              color: generalStatus == "Succeed" ? Colors.green[400] : Colors.redAccent,
                              fontSize: 35,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      SizedBox(width: 20,),
                      ExpansionTile(
                        title: Text(
                          'Missions : ' ,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        onExpansionChanged: (val) {
                          setState(() {
                            if (val)
                              size += missions * 50;
                            else
                              size -= missions * 50;
                          });
                        },
                        children: <Widget>[
                          ListView.builder(
                            controller: s,
                            shrinkWrap: true,
                            itemCount: missions,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(width: 20,),
                                      Text(
                                        missionsName[index] ,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        missionsStatus[index] == "0" ? "Done" : "Uncomplited",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    missionsDescription[index] ,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Divider(height: 1,),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      ExpansionTile(
                        title: Text(
                          'Reviews : ' ,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                        onExpansionChanged: (val) {
                          setState(() {
                            if (val)
                              size += reviews * 50;
                            else
                              size -= reviews * 50;
                          });
                        },
                        children: <Widget>[
                          reviewExists ? ListView.builder(
                            shrinkWrap: true,
                            controller: s,
                            itemCount: reviewCategories.length,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(width: 0,),
                                  Text(
                                    reviewCategories[index],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Flexible(
                                    flex: 2,
                                    child: ListView(
                                      children: buildWidget(reviewCategories[index] == "Avantage"
                                          ? avantage
                                          : reviewCategories[index] == "Inconvenient"
                                          ? inconvenient
                                          : feedback,
                                      ),
                                      shrinkWrap: true,
                                      padding: EdgeInsets.symmetric(horizontal: 20),
                                    ),
                                  )
                                ],
                              );
                            },
                          ) : SizedBox(height: 0,width: 0,),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildWidget(List list) {
    List<Widget> widgetList = [];
    for (int i = 0;i < list.length;i++) {
      widgetList.add(
        Text(
          list[i],
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      );
    }

    return widgetList;
  }
}