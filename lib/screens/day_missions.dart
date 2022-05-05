import 'dart:async';

import 'package:dailymissions/widgets/avan_incon.dart';
import 'package:dailymissions/main.dart';
import 'package:dailymissions/screens/mission_detail.dart';
import 'package:dailymissions/models/missions.dart';
import 'package:dailymissions/models/mission_model.dart';
import 'package:dailymissions/helpers/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


class DayMissions extends StatefulWidget {
  static final String id = "daymissions";

  @override
  _DayMissionsState createState() => _DayMissionsState();
}

class _DayMissionsState extends State<DayMissions> {
  List<String> chosenList = [];
  List<bool> isPressed = [];
  List<Icon> icon = [];

  double percent = 0;
  int numberDone = 0;
  int numberFlexTotal = 0;
  int numberFlexDone = 0;
  SQL_Helper helper = new SQL_Helper();
  int count;
  int nbAdded = 0;
  List<Missions> m = [];
  List<Missions> mTemp = [];

  @override
  void initState() {
    super.initState();
    setDebute();
  }

  Missions missions;
  bool isDone = false;

  void setDebute() {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<Missions>> mission = helper.getMissionsList();
      mission.then((theList) {
        setState(() {
          if (theList.length == 0) {
            if (MyApp.plan == 1) {
              chosenList = list;
              isPressed = isPressedList;
              icon = iconList;
              numberFlexTotal = chosenList.length;
            }
            if (MyApp.plan == 2) {
              chosenList = list_1;
              isPressed = isPressedList2;
              icon = iconList2;
              numberFlexTotal = chosenList.length;
            }
            if (MyApp.plan == 3) {
              chosenList = list2;
              isPressed = isPressedList;
              icon = iconList;
              numberFlexTotal = chosenList.length;
            }
            if (MyApp.plan == 4) {
              chosenList = list2_1;
              isPressed = isPressedList2;
              icon = iconList2;
              numberFlexTotal = chosenList.length;
            }

            this.count = chosenList.length;

            for (int i = 0; i < chosenList.length; i++) {
              icon[i] = Icon(Icons.check_box_outline_blank, size: 30, color: Colors.purple,);
              isPressed[i] = false;
            }

            for (int i = 0; i < chosenList.length; i++) {
              missions = Missions.withId(i + 1, chosenList[i], "", 1, 1);
              _save(missions);
              mTemp.add(missions);
            }
          }
          else {
            this.count = theList.length;
            icon.length = chosenList.length;
            isPressed.length = chosenList.length;
            numberFlexTotal = chosenList.length;

            if(theList.length == chosenList.length) {
              for (int i = 0; i < chosenList.length; i++) {
                missions = Missions.withId(theList[i].id, theList[i].name, theList[i].description, theList[i].status, theList[i].flex);
                theList[i].status == 1
                                ? icon[i] = Icon(Icons.check_box_outline_blank, size: 30, color: Colors.purple,)
                                : icon[i] = Icon(Icons.check_box, size: 30, color: Colors.purple,);
                theList[i].status == 1 ? isPressed[i] = false : isPressed[i] = true;
                if (theList[i].status == 0) {
                  numberDone++;
                  numberFlexDone += theList[i].flex;
                  percent = numberFlexDone / numberFlexTotal * 100;
                }
                mTemp.add(missions);
              }
            }
            else if (theList.length > chosenList.length) {
              nbAdded = theList.length - chosenList.length;
              for (int i = 0; i < chosenList.length; i++) {
                missions = Missions.withId(theList[i].id, theList[i].name, theList[i].description, theList[i].status, theList[i].flex);
                theList[i].status == 1
                                ? icon[i] = Icon(Icons.check_box_outline_blank, size: 30, color: Colors.purple,)
                                : icon[i] = Icon(Icons.check_box, size: 30, color: Colors.purple,);
                theList[i].status == 1 ? isPressed[i] = false : isPressed[i] = true;
                if (theList[i].status == 0) {
                  numberDone++;
                  numberFlexDone += theList[i].flex;
                  percent = numberFlexDone / numberFlexTotal * 100;
                }
                mTemp.add(missions);
              }
              for (int i = 0; i < nbAdded; i++) {
                numberFlexTotal += theList[i + chosenList.length].flex;

                missions = Missions.withId(
                  theList[i + chosenList.length].id,
                  theList[i + chosenList.length].name,
                  theList[i + chosenList.length].description,
                  theList[i + chosenList.length].status,
                  theList[i + chosenList.length].flex,
                );
                mTemp.add(missions);
                theList[i + chosenList.length].status == 1
                                  ? icon.add(Icon(Icons.check_box_outline_blank, size: 30, color: Colors.purple,))
                                  : icon.add(Icon(Icons.check_box, size: 30, color: Colors.purple,));
                theList[i + chosenList.length].status == 1 ? isPressed.add(false) : isPressed.add(true);
                if (theList[i + chosenList.length].status == 0) {
                  numberDone++;
                  numberFlexDone += theList[i].flex;
                  percent = numberFlexDone / numberFlexTotal * 100;
                }

              }
            }

          }
          count = mTemp.length;
          isDone = true;
        });
      });
    });
  }

  void _save(Missions mT) async {
    int result;

    result = await helper.insertMission(mT);
  }

  faire(Missions mm) async{
    int result;

    result = await helper.updateStatusMission(mm);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Day Missions",style: TextStyle(color: Colors.black54,fontSize: 25),),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              MyApp.walking--;
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                setState(() {
                  navigateToMission(Missions.withId(mTemp[mTemp.length - 1].id + 1,'', '', 1, 1), "Add New Mission", 1, mTemp.length);
                });
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          onPressed: () {
            MyApp.walking++;
            Navigator.pushNamed(context, AvanIncon.id);
            if (percent.round() == 100) {
              MyApp.isDayFinished = true;
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Text("Next"),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                ),
                padding: EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      percent < 0 ? "${(percent * -1).toStringAsFixed(2)}%" : "${percent.toStringAsFixed(2)}%",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey
                      ),
                    ),
                    Text(
                      "${numberDone.toString()} / $count",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              isDone ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: count,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      onDoubleTap: () {
                        _update(context, mTemp[index], index);
                      },
                      onLongPress: () {
                        setState(() {
                          if (index >= chosenList.length) {
                            _delete(context, mTemp[index], index);
                          }
                        });
                      },
                      onTap: () {
                        setState(() {
                          if (isPressed[index]) {
                            isPressed[index] = false;
                            icon[index] = Icon(
                              Icons.check_box_outline_blank, size: 30, color: Colors.purple,
                            );

                            mTemp[index].status = 1;
                            faire(mTemp[index]);

                            numberFlexDone -= mTemp[index].flex;

                            percent = numberFlexDone / numberFlexTotal * 100;
                            if (percent.round() != 100) MyApp.isDayFinished = false;

                            numberDone--;
                          }
                          else {
                            isPressed[index] = true;
                            icon[index] = Icon(Icons.check_box, size: 30, color: Colors.purple,);

                            mTemp[index].status = 0;
                            faire(mTemp[index]);

                            numberFlexDone += mTemp[index].flex;

                            percent = numberFlexDone / numberFlexTotal * 100;
                            if (percent.round() == 100) MyApp.isDayFinished = true;

                            numberDone++;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.grey
                        ),
                        margin: EdgeInsets.all(8),
                        height: 80,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(mTemp[index].name, style: TextStyle(fontSize: 24),),
                                icon[index],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : Center(child: CircularProgressIndicator(value: 30,)),
            ],
          ),
        ),
      ),
    );
  }


  void _delete(BuildContext context, Missions missions,int index) async {
    int result;

    AlertDialog alertDialog = AlertDialog(
      title: Text("Do you want to delete the mission ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () async {
            result = await helper.deleteMission(missions.id);
            helper.getMissionsList();

            if (result != 0) {
              _showSnackBar(context, "Mission has been deleted");
              updateListView(index,2);
            }
            Navigator.pop(context, false);
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



  void _update(BuildContext context, Missions missions,int index) async {
    int result;

    AlertDialog alertDialog = AlertDialog(
      title: Text("Do you want to update the mission ?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: () async {
            Navigator.pop(context);
            navigateToMission(missions, "Update Mission Info", 3, index);
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

  void _showSnackBar(BuildContext context, String msg) {
    final snackBar = SnackBar(content: Text(msg),duration: Duration(seconds: 2,),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(int index,int choice) {
    final Future<Database> db = helper.initializedDatabase();
    db.then((database) {
      Future<List<Missions>> mission = helper.getMissionsList();
      mission.then((theList) {
        setState(() {
          if (choice == 1) {
            count++;
            Missions mi = Missions.withId(
              theList[theList.length - 1].id,
              theList[theList.length - 1].name,
              theList[theList.length - 1].description,
              theList[theList.length - 1].status,
              theList[theList.length - 1].flex,
            );
            m.add(mi);
            nbAdded = m.length;
            mTemp.add(m[m.length - 1]);
            numberFlexTotal += mTemp[index].flex;
            percent = numberFlexDone / numberFlexTotal * 100;
            mTemp[index].status == 1
                              ? icon.add(Icon(Icons.check_box_outline_blank,size: 30,color: Colors.purple,))
                              : icon.add(Icon(Icons.check_box,size: 30,color: Colors.purple,));
            mTemp[index].status == 1
                              ? isPressed.add(false)
                              : isPressed.add(true);
            if (mTemp[index].status == 0) {
              numberDone++;
              numberFlexDone += mTemp[index].flex;
              percent = numberFlexDone / numberFlexTotal * 100;
            }
          }
          else if(choice == 2) {
            if (isPressed[index]) {
              numberDone--;
              numberFlexDone -= mTemp[index].flex;
            }
            nbAdded--;
            mTemp.removeAt(index);

            isPressed.removeAt(index);
            icon.removeAt(index);
            count--;

            numberFlexTotal -= mTemp[index].flex;

            percent = numberFlexDone / numberFlexTotal * 100;
          }
          else if (choice == 3) {
            mTemp[index].status == 1
                                ? icon[index] = Icon(Icons.check_box_outline_blank,size: 30,color: Colors.purple,)
                                : icon[index] = Icon(Icons.check_box,size: 30,color: Colors.purple,);
            mTemp[index].status == 1
                                ? isPressed[index] = false
                                : isPressed[index] = true;
            numberFlexTotal -= mTemp[index].flex;
            if (mTemp[index].status == 0) {
              numberFlexTotal += mTemp[index].flex;
              numberFlexDone += mTemp[index].flex;
              numberDone++;
              percent = numberFlexDone / numberFlexTotal * 100;
            }
            else {
              numberFlexTotal += mTemp[index].flex;
              numberFlexDone -= mTemp[index].flex;
              numberDone--;
              percent = numberFlexDone / numberFlexTotal * 100;
            }
          }
        });
      });
    });
  }


  void navigateToMission(Missions missions, String appTitle, int choice, int index) async {
    bool deletePossibility = index >= mTemp.length;
    List<Object> result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) {
      return MissionDetails(missions, appTitle, choice, deletePossibility);
    }));

    if (result[0] && result[1]) {
        updateListView(index,choice);
    }
    if (result[0] && !result[1] && deletePossibility){
      updateListView(index, 2);
    }
  }
}