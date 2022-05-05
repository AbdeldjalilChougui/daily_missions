import 'dart:convert';
import 'dart:io';
import 'package:dailymissions/day_review.dart';
import 'package:dailymissions/main.dart';
import 'package:dailymissions/models/missions.dart';
import 'package:dailymissions/models/previous_days.dart';
import 'package:dailymissions/sql_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SavePage extends StatefulWidget {
  static final String id = "savepage";

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
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
  List<DayReview> dayReviws = [];
  List<PreviousDaysReview> previousDaysReview = [];
  List<String> avantage = [];
  List<String> inconvenient = [];
  List<String> feedback = [];
  List<Color> colors = [
    Colors.purple[300],
    Colors.pinkAccent[100],
    Colors.yellowAccent,
    Colors.blueGrey,
    Colors.white70,
    Colors.green[300],
    Colors.orangeAccent,
    Colors.teal,
    Colors.red[300]
  ];

  String MISSIONS_NAME = "mission_name";
  String MISSIONS_STATUS = "mission_status";
  String MISSIONS_DESCRIPTION = "mission_description";
  String REVIEW_CATEGORY = "review_category";
  String REVIEW_CONTENT = "review_content";

  double percentDone = 0;
  int done = 0, doneFlex = 0, totalFlex = 0;

  void setDebute() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<PreviousDaysReview>> previousReview = helper.getPreviousDaysReviewsList();
      previousReview.then((theList) {
        setState(() {
          previousDaysReview = theList;


          fileName = "dayJson${previousDaysReview.length}.json";
          print("file name :  $fileName");

          getApplicationDocumentsDirectory().then((Directory directory) {
            dir = directory;
            jsonFile = new File(dir.path + "/" + fileName);
            fileExists = jsonFile.existsSync();
            if (fileExists) this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
          });
        });
      });

      Future<List<Missions>> mission = helper.getMissionsList();
      mission.then((theList) {
        setState(() {
          missions = theList;
          count += missions.length;

          for (int i = 0;i < missions.length;i++) {
            totalFlex += missions[i].flex;
            if (missions[i].status == 0) {
              done++;
              doneFlex += missions[i].flex;
            }
          }

          percentDone = doneFlex * 100.0 / totalFlex;
        });
      });

      Future<List<DayReview>> review = helper.getReviewsList();
      review.then((theList) {
        setState(() {
          dayReviws = theList;
          if (dayReviws != null) count += dayReviws.length;

          for (int i = 0;i <dayReviws.length;i++) {
            if (dayReviws[i].category == "Avantage") {
              avantage.add(dayReviws[i].content);
            }
            if (dayReviws[i].category == "Inconvenient") {
              inconvenient.add(dayReviws[i].content);
            }
            if (dayReviws[i].category == "FeedBack") {
              feedback.add(dayReviws[i].content);
            }
          }

          heightAvant = avantage.length;
          heightIncon = inconvenient.length;
          heightFeed = feedback.length;
        });
      });
    });
  }

  File jsonFile;
  Directory dir;
  String fileName;
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      Map<String, dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content);
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print("filecontent $fileContent");
  }

  Future getData() async {

    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));

    print("add $fileContent"); //shows the full json string that I want.
  }

  @override
  void dispose() {
    super.dispose();
  }

  void insertion() {
    PreviousDaysReview pDR = PreviousDaysReview.withId(previousDaysReview.length + 1, DateTime.now().toIso8601String(), previousDaysReview.length + 1);
    _save(pDR);
  }

  void _save(PreviousDaysReview pDR) async {
    int result;

    result = await helper.insertPreviousDaysReviews(pDR);

    for (int i = 0;i < missions.length;i++) {
      writeToFile("$MISSIONS_NAME${i + 1}", missions[i].name);
      writeToFile("$MISSIONS_DESCRIPTION${i + 1}", missions[i].description);
      if (missions[i].status == 0) writeToFile("$MISSIONS_STATUS${i + 1}", "Done");
      else writeToFile("$MISSIONS_STATUS${i + 1}", "Uncomplited");
    }

    for (int i = 0;i < dayReviws.length;i++) {
      writeToFile("$REVIEW_CATEGORY${i + 1}", dayReviws[i].category);
      writeToFile("$REVIEW_CONTENT${i + 1}", dayReviws[i].content);
    }

    writeToFile("date", previousDaysReview.length > 0 ? previousDaysReview[previousDaysReview.length - 1].date : DateTime.now().toIso8601String());
    writeToFile("generalstatus", percentDone.round() >= 80 ? "Succeed" : "Failed");

    await _deleteDB();
  }

  _deleteDB() async{
    MyApp.isDayFinished = false;
    MyApp.walking = 0;
    MyApp.plan = 0;
    helper.resetDB();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Save This Day",style: TextStyle(color: Colors.grey,fontSize: 25),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              if (MyApp.walking == 1) {
                Navigator.pop(context);
                MyApp.walking = 0;
              }
              else if (MyApp.walking == 3) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                MyApp.walking = 0;
              }
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: MyApp.isDayFinished || (DateTime.now().hour >= 22 && DateTime.now().minute >= 0) ? FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            insertion();
            if (MyApp.walking == 1) {
              Navigator.pop(context);
            }
            else if (MyApp.walking == 3) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text("Save"),
          ),
        )
        : SizedBox(height: 0,width: 0,),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ClipPath(
                clipper: ClipBottom(),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                  ),
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: getSpots(),
                                  isCurved: true,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                  colors: [Color(0xFF0D8E53)],
                                  barWidth: 3,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        percentDone.isNaN ? "0%"
                                : percentDone < 0 ? "${(percentDone * -1).toStringAsFixed(2)}%" : "${percentDone.toStringAsFixed(2)}%",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        "${done.toString()} / ${missions.length}",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              missions.length > 0 ? Container(
                height: 60,
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          percentDone.round() >= 80 ? "Succeed" : "Failed",
                          style: TextStyle(
                            fontSize: 20,
                            color: percentDone.round() >= 80 ? Colors.green : Colors.red,
                          ),
                        ),
                        Stack(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 200,
                                height: 30,
                                color: Colors.grey
                            ),
                            Container(
                              width: doneFlex * 200 / totalFlex,
                              height: 30,
                              color: percentDone.round() >= 80
                                  ? Colors.green
                                  : percentDone.round() >= 60
                                          ? Colors.yellowAccent[200]
                                          : percentDone.round() >= 40
                                                   ? Colors.orangeAccent
                                                   : percentDone.round() >= 20
                                                            ? Colors.deepOrange
                                                            : Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ) : SizedBox(height: 0,width: 0,),
              Expanded(
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
            ],
          ),
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










List<FlSpot> getSpots () {
  return [
    FlSpot(0, 0.5),
    FlSpot(1, 1.5),
    FlSpot(2, 0.5),
    FlSpot(3, 0.7),
    FlSpot(4, 0.2),
    FlSpot(5, 2),
    FlSpot(6, 1.5),
    FlSpot(7, 1.7),
    FlSpot(8, 1),
    FlSpot(9, 2.8),
    FlSpot(10, 2.5),
    FlSpot(11, 2.65),
    FlSpot(12, 2.95),
  ];
}